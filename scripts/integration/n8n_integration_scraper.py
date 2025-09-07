#!/usr/bin/env python3
"""
N8N Integration Scraper with Enhanced Icon & Data Extraction
===========================================================

This script scrapes the N8N integrations page to extract:
- Colored integration icons (high-quality)
- Complete integration metadata
- Categories and descriptions
- Updates the saas_channel_master table with enhanced data

Usage:
    python n8n_integration_scraper.py --scrape-and-update
    python n8n_integration_scraper.py --scrape-only
    python n8n_integration_scraper.py --update-icons-only
"""

import asyncio
import aiohttp
import json
import logging
import argparse
import re
import os
import uuid
from datetime import datetime
from typing import Dict, List, Optional, Any
from urllib.parse import urljoin, urlparse
from pathlib import Path
import base64
from dataclasses import dataclass, asdict
import psycopg2
from psycopg2.extras import RealDictCursor
import requests
from bs4 import BeautifulSoup
from playwright.async_api import async_playwright
import hashlib

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@dataclass
class IntegrationIcon:
    """Integration icon data"""
    name: str
    url: str
    local_path: Optional[str] = None
    base64_data: Optional[str] = None
    color_scheme: Optional[str] = None
    format: str = 'svg'

@dataclass
class IntegrationData:
    """Complete integration data structure"""
    name: str
    key: str
    description: str
    category: str
    subcategory: Optional[str]
    icon: IntegrationIcon
    base_url: Optional[str]
    docs_url: Optional[str]
    tags: List[str]
    features: List[str]
    is_popular: bool = False
    is_core: bool = False
    is_trigger: bool = False
    is_regular: bool = False
    node_type: str = 'regular'
    auth_methods: List[str] = None
    rating: Optional[float] = None
    
    def to_channel_master_format(self) -> Dict[str, Any]:
        """Convert to format for saas_channel_master table"""
        return {
            'channel_key': self.key.upper().replace(' ', '_').replace('-', '_'),
            'channel_name': self.name,
            'base_url': self.base_url,
            'docs_url': self.docs_url,
            'channel_logo_url': self.icon.url,
            'default_channel_config': {
                'category': self.category,
                'subcategory': self.subcategory,
                'description': self.description,
                'node_type': self.node_type,
                'tags': self.tags,
                'features': self.features,
                'is_popular': self.is_popular,
                'is_core': self.is_core
            },
            'capabilities': {
                'category': self.category,
                'subcategory': self.subcategory,
                'supported_operations': self.features,
                'node_types': [self.node_type],
                'auth_methods': self.auth_methods or [],
                'rating': self.rating
            }
        }

class N8NIntegrationScraper:
    """Advanced N8N integration scraper with icon extraction"""
    
    BASE_URL = "https://n8n.io"
    INTEGRATIONS_URL = "https://n8n.io/integrations/"
    ICONS_DIR = Path(__file__).parent / "icons"
    
    def __init__(self, db_config: Optional[Dict] = None):
        self.db_config = db_config
        self.icons_dir = self.ICONS_DIR
        self.icons_dir.mkdir(exist_ok=True)
        self.session = None
        self.scraped_data = []
        
    async def __aenter__(self):
        self.session = aiohttp.ClientSession(
            timeout=aiohttp.ClientTimeout(total=30),
            headers={
                'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
            }
        )
        return self
        
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        if self.session:
            await self.session.close()
    
    async def scrape_integrations_with_playwright(self) -> List[IntegrationData]:
        """Scrape integrations using Playwright for dynamic content"""
        integrations = []
        
        async with async_playwright() as p:
            browser = await p.chromium.launch(headless=True)
            context = await browser.new_context(
                user_agent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
            )
            page = await context.new_page()
            
            try:
                logger.info("Loading N8N integrations page...")
                await page.goto(self.INTEGRATIONS_URL, wait_until='networkidle')
                await page.wait_for_timeout(3000)  # Wait for dynamic content
                
                # Get total count
                try:
                    count_text = await page.locator('.text-sm.text-gray-600').first.inner_text()
                    total_count = int(re.search(r'(\d+)\s+integrations', count_text).group(1))
                    logger.info(f"Found {total_count} total integrations")
                except:
                    logger.warning("Could not determine total integration count")
                
                # Load more integrations if needed
                await self._load_all_integrations(page)
                
                # Extract integration cards
                cards = await page.locator('[data-testid="integration-card"], .integration-card, article').all()
                logger.info(f"Found {len(cards)} integration cards")
                
                for i, card in enumerate(cards):
                    try:
                        integration = await self._extract_integration_from_card(card, page)
                        if integration:
                            integrations.append(integration)
                            logger.info(f"Extracted: {integration.name} ({i+1}/{len(cards)})")
                    except Exception as e:
                        logger.error(f"Error extracting card {i}: {e}")
                        continue
                
                # Also scrape category-based data
                categories_data = await self._scrape_by_categories(page)
                integrations.extend(categories_data)
                
            except Exception as e:
                logger.error(f"Error scraping with Playwright: {e}")
            finally:
                await browser.close()
        
        # Remove duplicates based on key
        unique_integrations = {}
        for integration in integrations:
            if integration.key not in unique_integrations:
                unique_integrations[integration.key] = integration
        
        logger.info(f"Extracted {len(unique_integrations)} unique integrations")
        return list(unique_integrations.values())
    
    async def _load_all_integrations(self, page):
        """Load all integrations by scrolling and clicking load more"""
        try:
            # Scroll to load more content
            for _ in range(5):
                await page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
                await page.wait_for_timeout(2000)
                
                # Look for "Load More" or "Show More" buttons
                load_more_selectors = [
                    'button:has-text("Load more")',
                    'button:has-text("Show more")',
                    '[data-testid="load-more"]',
                    '.load-more-btn'
                ]
                
                for selector in load_more_selectors:
                    try:
                        load_more = page.locator(selector)
                        if await load_more.count() > 0 and await load_more.is_visible():
                            await load_more.click()
                            await page.wait_for_timeout(2000)
                            logger.info("Clicked load more button")
                    except:
                        continue
        except Exception as e:
            logger.warning(f"Error loading all integrations: {e}")
    
    async def _extract_integration_from_card(self, card, page) -> Optional[IntegrationData]:
        """Extract integration data from a card element"""
        try:
            # Get integration name
            name_selectors = ['h3', '.card-title', '[data-testid="integration-name"]', 'h4', 'h2']
            name = None
            for selector in name_selectors:
                try:
                    name_elem = card.locator(selector).first
                    if await name_elem.count() > 0:
                        name = await name_elem.inner_text()
                        name = name.strip()
                        if name:
                            break
                except:
                    continue
            
            if not name:
                return None
            
            # Get description
            description = ""
            desc_selectors = ['p', '.description', '[data-testid="integration-description"]', '.card-text']
            for selector in desc_selectors:
                try:
                    desc_elem = card.locator(selector).first
                    if await desc_elem.count() > 0:
                        description = await desc_elem.inner_text()
                        description = description.strip()
                        if description and len(description) > 10:
                            break
                except:
                    continue
            
            # Get icon
            icon_data = await self._extract_icon_from_card(card, name)
            
            # Get category and tags
            category, tags = await self._extract_category_and_tags(card)
            
            # Get URLs
            docs_url = await self._extract_docs_url(card, name)
            base_url = self._generate_base_url(name)
            
            # Determine node type and features
            node_type, features = await self._determine_node_type_and_features(card)
            
            # Create integration data
            integration = IntegrationData(
                name=name,
                key=self._generate_key(name),
                description=description or f"{name} integration for workflow automation",
                category=category,
                subcategory=self._determine_subcategory(category, name),
                icon=icon_data,
                base_url=base_url,
                docs_url=docs_url,
                tags=tags,
                features=features,
                node_type=node_type,
                is_popular=await self._is_popular(card),
                is_core=await self._is_core_node(card),
                auth_methods=self._determine_auth_methods(name)
            )
            
            return integration
            
        except Exception as e:
            logger.error(f"Error extracting integration from card: {e}")
            return None
    
    async def _extract_icon_from_card(self, card, name: str) -> IntegrationIcon:
        """Extract high-quality icon from card"""
        try:
            # Look for various icon selectors
            icon_selectors = [
                'img',
                'svg',
                '[data-testid="integration-icon"]',
                '.icon',
                '.integration-icon'
            ]
            
            icon_url = None
            for selector in icon_selectors:
                try:
                    icon_elem = card.locator(selector).first
                    if await icon_elem.count() > 0:
                        if 'img' in selector:
                            icon_url = await icon_elem.get_attribute('src')
                        elif 'svg' in selector:
                            # For SVG, get the outerHTML
                            svg_content = await icon_elem.inner_html()
                            if svg_content:
                                # Save SVG as base64
                                svg_b64 = base64.b64encode(svg_content.encode()).decode()
                                icon_url = f"data:image/svg+xml;base64,{svg_b64}"
                        
                        if icon_url:
                            break
                except:
                    continue
            
            if not icon_url:
                # Generate default icon URL based on name
                icon_url = self._generate_default_icon_url(name)
            elif icon_url.startswith('/'):
                icon_url = urljoin(self.BASE_URL, icon_url)
            
            # Download and process icon
            icon_data = IntegrationIcon(
                name=name,
                url=icon_url,
                format='svg' if 'svg' in icon_url else 'png'
            )
            
            # Download icon for local storage
            await self._download_icon(icon_data)
            
            return icon_data
            
        except Exception as e:
            logger.error(f"Error extracting icon for {name}: {e}")
            return IntegrationIcon(
                name=name,
                url=self._generate_default_icon_url(name)
            )
    
    async def _download_icon(self, icon_data: IntegrationIcon):
        """Download and save icon locally"""
        try:
            if not self.session:
                return
                
            async with self.session.get(icon_data.url) as response:
                if response.status == 200:
                    content = await response.read()
                    
                    # Save locally
                    safe_name = re.sub(r'[^\w\-_.]', '_', icon_data.name)
                    filename = f"{safe_name}.{icon_data.format}"
                    icon_path = self.icons_dir / filename
                    
                    with open(icon_path, 'wb') as f:
                        f.write(content)
                    
                    icon_data.local_path = str(icon_path)
                    icon_data.base64_data = base64.b64encode(content).decode()
                    
                    logger.debug(f"Downloaded icon for {icon_data.name}")
                    
        except Exception as e:
            logger.warning(f"Could not download icon for {icon_data.name}: {e}")
    
    async def _extract_category_and_tags(self, card) -> tuple:
        """Extract category and tags from card"""
        category = "Productivity"  # Default
        tags = []
        
        try:
            # Look for category indicators
            category_selectors = [
                '.category',
                '.tag',
                '[data-category]',
                '.badge',
                'small'
            ]
            
            for selector in category_selectors:
                try:
                    elements = card.locator(selector).all()
                    for elem in await elements:
                        text = await elem.inner_text()
                        text = text.strip()
                        if text:
                            # Common categories mapping
                            if any(word in text.lower() for word in ['communication', 'chat', 'email', 'messaging']):
                                category = "Communication"
                            elif any(word in text.lower() for word in ['ai', 'artificial', 'machine learning', 'openai']):
                                category = "AI"
                            elif any(word in text.lower() for word in ['e-commerce', 'shop', 'payment', 'stripe']):
                                category = "E-commerce"
                            elif any(word in text.lower() for word in ['marketing', 'crm', 'sales']):
                                category = "Marketing"
                            elif any(word in text.lower() for word in ['developer', 'git', 'code', 'api']):
                                category = "Development"
                            
                            tags.append(text)
                except:
                    continue
        except:
            pass
        
        return category, tags
    
    async def _extract_docs_url(self, card, name: str) -> Optional[str]:
        """Extract documentation URL"""
        try:
            # Look for documentation links
            doc_selectors = [
                'a[href*="docs"]',
                'a[href*="documentation"]',
                'a:has-text("docs")',
                'a:has-text("documentation")'
            ]
            
            for selector in doc_selectors:
                try:
                    link = card.locator(selector).first
                    if await link.count() > 0:
                        href = await link.get_attribute('href')
                        if href:
                            if href.startswith('/'):
                                return urljoin(self.BASE_URL, href)
                            return href
                except:
                    continue
            
            # Generate default docs URL
            safe_name = name.lower().replace(' ', '-').replace('_', '-')
            return f"https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.{safe_name}/"
            
        except:
            return None
    
    def _generate_base_url(self, name: str) -> Optional[str]:
        """Generate base URL for integration"""
        name_lower = name.lower()
        
        # Common URL mappings
        url_mappings = {
            'google': 'https://www.google.com',
            'gmail': 'https://gmail.com',
            'slack': 'https://slack.com/api',
            'facebook': 'https://developers.facebook.com',
            'twitter': 'https://developer.twitter.com',
            'linkedin': 'https://www.linkedin.com',
            'discord': 'https://discord.com/api',
            'telegram': 'https://core.telegram.org/api',
            'shopify': 'https://shopify.dev',
            'stripe': 'https://stripe.com/docs/api',
            'openai': 'https://api.openai.com',
            'anthropic': 'https://api.anthropic.com',
            'github': 'https://api.github.com',
            'gitlab': 'https://gitlab.com/api',
            'trello': 'https://api.trello.com',
            'notion': 'https://api.notion.com',
            'airtable': 'https://airtable.com/api'
        }
        
        for key, url in url_mappings.items():
            if key in name_lower:
                return url
        
        return None
    
    async def _scrape_by_categories(self, page) -> List[IntegrationData]:
        """Scrape integrations by categories for comprehensive coverage"""
        categories_data = []
        
        try:
            # Get category filters
            category_selectors = [
                '[data-testid="category-filter"]',
                '.category-filter',
                'button[data-category]'
            ]
            
            categories = ['AI', 'Communication', 'Development', 'Marketing', 'Productivity', 'Sales']
            
            for category in categories:
                try:
                    logger.info(f"Scraping category: {category}")
                    
                    # Click category filter if available
                    category_filter = page.locator(f'text="{category}"').first
                    if await category_filter.count() > 0:
                        await category_filter.click()
                        await page.wait_for_timeout(2000)
                    
                    # Extract integrations for this category
                    cards = await page.locator('[data-testid="integration-card"]').all()
                    for card in cards:
                        integration = await self._extract_integration_from_card(card, page)
                        if integration:
                            integration.category = category
                            categories_data.append(integration)
                    
                except Exception as e:
                    logger.warning(f"Error scraping category {category}: {e}")
                    continue
        
        except Exception as e:
            logger.error(f"Error in category scraping: {e}")
        
        return categories_data
    
    async def _determine_node_type_and_features(self, card) -> tuple:
        """Determine node type and features"""
        node_type = "regular"
        features = []
        
        try:
            # Look for node type indicators
            card_html = await card.inner_html()
            
            if 'trigger' in card_html.lower():
                node_type = "trigger"
                features.append("trigger")
            elif 'webhook' in card_html.lower():
                node_type = "trigger"
                features.append("webhook")
            elif 'core' in card_html.lower():
                node_type = "core"
                features.append("core")
            
            # Common features based on content
            if 'api' in card_html.lower():
                features.append("api")
            if 'auth' in card_html.lower():
                features.append("authentication")
            if 'webhook' in card_html.lower():
                features.append("webhook")
        except:
            pass
        
        return node_type, features
    
    async def _is_popular(self, card) -> bool:
        """Check if integration is marked as popular"""
        try:
            card_html = await card.inner_html()
            return any(indicator in card_html.lower() for indicator in ['popular', 'trending', 'featured'])
        except:
            return False
    
    async def _is_core_node(self, card) -> bool:
        """Check if integration is a core node"""
        try:
            card_html = await card.inner_html()
            return 'core' in card_html.lower()
        except:
            return False
    
    def _generate_key(self, name: str) -> str:
        """Generate consistent key from name"""
        return re.sub(r'[^\w]', '_', name.upper()).strip('_')
    
    def _determine_subcategory(self, category: str, name: str) -> Optional[str]:
        """Determine subcategory based on category and name"""
        name_lower = name.lower()
        
        subcategory_mappings = {
            'Communication': {
                'email': 'Email',
                'chat': 'Team Chat', 
                'messaging': 'Messaging',
                'social': 'Social Media'
            },
            'AI': {
                'openai': 'Language Models',
                'anthropic': 'Language Models',
                'agent': 'AI Agents',
                'vision': 'Computer Vision'
            },
            'Development': {
                'git': 'Version Control',
                'api': 'API Tools',
                'database': 'Database',
                'cloud': 'Cloud Services'
            },
            'Marketing': {
                'crm': 'CRM',
                'email': 'Email Marketing',
                'social': 'Social Media',
                'analytics': 'Analytics'
            }
        }
        
        if category in subcategory_mappings:
            for keyword, subcategory in subcategory_mappings[category].items():
                if keyword in name_lower:
                    return subcategory
        
        return None
    
    def _determine_auth_methods(self, name: str) -> List[str]:
        """Determine authentication methods based on integration name"""
        name_lower = name.lower()
        auth_methods = []
        
        # Common auth methods
        if any(word in name_lower for word in ['google', 'gmail', 'sheets']):
            auth_methods = ['oauth2', 'api_key']
        elif 'github' in name_lower:
            auth_methods = ['oauth2', 'token']
        elif any(word in name_lower for word in ['slack', 'discord']):
            auth_methods = ['oauth2', 'webhook']
        elif 'openai' in name_lower:
            auth_methods = ['api_key']
        else:
            auth_methods = ['api_key']
        
        return auth_methods
    
    def _generate_default_icon_url(self, name: str) -> str:
        """Generate default icon URL using simple-icons or similar service"""
        # Use simple-icons CDN for common services
        safe_name = name.lower().replace(' ', '').replace('-', '').replace('_', '')
        return f"https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/{safe_name}.svg"
    
    def save_scraped_data(self, integrations: List[IntegrationData], filename: str = None):
        """Save scraped data to JSON file"""
        if not filename:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"n8n_integrations_scraped_{timestamp}.json"
        
        data = {
            'scraped_at': datetime.now().isoformat(),
            'total_integrations': len(integrations),
            'integrations': [asdict(integration) for integration in integrations]
        }
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        
        logger.info(f"Saved {len(integrations)} integrations to {filename}")
        return filename
    
    def update_channel_master_db(self, integrations: List[IntegrationData]):
        """Update saas_channel_master table with scraped data"""
        if not self.db_config:
            logger.error("No database configuration provided")
            return False
        
        try:
            conn = psycopg2.connect(**self.db_config)
            cur = conn.cursor(cursor_factory=RealDictCursor)
            
            updated_count = 0
            inserted_count = 0
            
            for integration in integrations:
                try:
                    channel_data = integration.to_channel_master_format()
                    
                    # Check if channel exists
                    cur.execute(
                        "SELECT channel_id FROM saas_channel_master WHERE channel_key = %s",
                        (channel_data['channel_key'],)
                    )
                    
                    if cur.fetchone():
                        # Update existing
                        update_sql = """
                        UPDATE saas_channel_master 
                        SET channel_name = %s,
                            base_url = %s,
                            docs_url = %s,
                            channel_logo_url = %s,
                            default_channel_config = %s,
                            capabilities = %s,
                            updated_at = NOW()
                        WHERE channel_key = %s
                        """
                        cur.execute(update_sql, (
                            channel_data['channel_name'],
                            channel_data['base_url'],
                            channel_data['docs_url'],
                            channel_data['channel_logo_url'],
                            json.dumps(channel_data['default_channel_config']),
                            json.dumps(channel_data['capabilities']),
                            channel_data['channel_key']
                        ))
                        updated_count += 1
                        
                    else:
                        # Insert new
                        insert_sql = """
                        INSERT INTO saas_channel_master 
                        (channel_key, channel_name, base_url, docs_url, channel_logo_url, 
                         default_channel_config, capabilities)
                        VALUES (%s, %s, %s, %s, %s, %s, %s)
                        """
                        cur.execute(insert_sql, (
                            channel_data['channel_key'],
                            channel_data['channel_name'],
                            channel_data['base_url'],
                            channel_data['docs_url'],
                            channel_data['channel_logo_url'],
                            json.dumps(channel_data['default_channel_config']),
                            json.dumps(channel_data['capabilities'])
                        ))
                        inserted_count += 1
                    
                    conn.commit()
                    
                except Exception as e:
                    logger.error(f"Error updating {integration.name}: {e}")
                    conn.rollback()
                    continue
            
            cur.close()
            conn.close()
            
            logger.info(f"Database update complete: {inserted_count} inserted, {updated_count} updated")
            return True
            
        except Exception as e:
            logger.error(f"Database update failed: {e}")
            return False

def main():
    parser = argparse.ArgumentParser(description='N8N Integration Scraper with Enhanced Icons')
    parser.add_argument('--scrape-and-update', action='store_true', help='Scrape and update database')
    parser.add_argument('--scrape-only', action='store_true', help='Scrape only, save to JSON')
    parser.add_argument('--update-icons-only', action='store_true', help='Update only icon URLs')
    parser.add_argument('--db-host', default='127.0.0.1', help='Database host')
    parser.add_argument('--db-user', default='postgres', help='Database user')
    parser.add_argument('--db-password', default='saasdbforwindmill2023', help='Database password')
    parser.add_argument('--db-name', default='catalog-edge-db', help='Database name')
    parser.add_argument('--output-file', help='Output JSON file name')
    
    args = parser.parse_args()
    
    # Database configuration
    db_config = {
        'host': args.db_host,
        'user': args.db_user,
        'password': args.db_password,
        'database': args.db_name,
        'port': 5432
    }
    
    async def run_scraper():
        async with N8NIntegrationScraper(db_config) as scraper:
            integrations = await scraper.scrape_integrations_with_playwright()
            
            if args.scrape_only or not args.update_icons_only:
                # Save to JSON
                json_file = scraper.save_scraped_data(integrations, args.output_file)
                logger.info(f"Scraped data saved to: {json_file}")
            
            if args.scrape_and_update or args.update_icons_only:
                # Update database
                success = scraper.update_channel_master_db(integrations)
                if success:
                    logger.info("Successfully updated channel master database!")
                else:
                    logger.error("Failed to update database")
    
    # Run the async scraper
    asyncio.run(run_scraper())

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
Simple N8N Integration Scraper with High-Quality Icons
======================================================

This script creates a curated list of N8N integrations with high-quality colored icons
and updates the saas_channel_master table.

Usage:
    python n8n_simple_scraper.py --update-db
    python n8n_simple_scraper.py --generate-sql
"""

import json
import logging
import argparse
import re
import os
import uuid
from datetime import datetime
from typing import Dict, List, Optional, Any
import psycopg2
from psycopg2.extras import RealDictCursor

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class N8NSimpleScraper:
    """Simple N8N integration scraper with curated high-quality data"""
    
    def __init__(self, db_config: Optional[Dict] = None):
        self.db_config = db_config
        
    def get_curated_integrations(self) -> List[Dict[str, Any]]:
        """Get curated list of N8N integrations with high-quality icons"""
        integrations = [
            # Communication & Social Media
            {
                "name": "Slack",
                "key": "SLACK",
                "description": "Slack is a powerful collaboration tool for businesses of all sizes. Hangs bring everyone together to work effectively and solve problems.",
                "category": "Communication",
                "subcategory": "Team Chat",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/slack.svg",
                "base_url": "https://slack.com/api",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.slack/",
                "features": ["messaging", "notifications", "channels", "webhooks"],
                "auth_methods": ["oauth2", "webhook"],
                "is_popular": True
            },
            {
                "name": "Discord",
                "key": "DISCORD", 
                "description": "Discord integration for Communication",
                "category": "Communication",
                "subcategory": "Team Chat",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/discord.svg",
                "base_url": "https://discord.com/api",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.discord/",
                "features": ["messaging", "notifications"],
                "auth_methods": ["webhook", "bot_token"],
                "is_popular": True
            },
            {
                "name": "Microsoft Teams",
                "key": "MICROSOFT_TEAMS",
                "description": "Microsoft Teams integration for Communication",
                "category": "Communication", 
                "subcategory": "Team Chat",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/microsoftteams.svg",
                "base_url": "https://graph.microsoft.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.microsoftteams/",
                "features": ["messaging", "meetings"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },
            {
                "name": "Gmail",
                "key": "GMAIL",
                "description": "Gmail is a free of charge email service offered as part of Google Workspace. It is used by individuals and organizations to send and receive emails and communicate internally and externally.",
                "category": "Communication",
                "subcategory": "Email", 
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/gmail.svg",
                "base_url": "https://gmail.googleapis.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.gmail/",
                "features": ["email", "attachments"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },
            {
                "name": "Telegram",
                "key": "TELEGRAM",
                "description": "Telegram is one of the fastest and most secured messaging apps on the market.",
                "category": "Communication",
                "subcategory": "Messaging",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/telegram.svg",
                "base_url": "https://api.telegram.org",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.telegram/",
                "features": ["messaging", "bots"],
                "auth_methods": ["bot_token"],
                "is_popular": True
            },
            {
                "name": "WhatsApp",
                "key": "WHATSAPP",
                "description": "WhatsApp integration for messaging",
                "category": "Communication",
                "subcategory": "Messaging",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/whatsapp.svg",
                "base_url": "https://developers.facebook.com/docs/whatsapp",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.whatsapp/",
                "features": ["messaging"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },
            {
                "name": "Facebook",
                "key": "FACEBOOK",
                "description": "Facebook integration for Social Media",
                "category": "Communication",
                "subcategory": "Social Media",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/facebook.svg",
                "base_url": "https://graph.facebook.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.facebook/",
                "features": ["posting", "pages"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },
            {
                "name": "Twitter",
                "key": "TWITTER",
                "description": "Twitter integration for Social Media",
                "category": "Communication",
                "subcategory": "Social Media", 
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/x.svg",
                "base_url": "https://api.twitter.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.twitter/",
                "features": ["tweets", "mentions"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },
            {
                "name": "LinkedIn",
                "key": "LINKEDIN", 
                "description": "LinkedIn integration for Social Media",
                "category": "Communication",
                "subcategory": "Social Media",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/linkedin.svg",
                "base_url": "https://api.linkedin.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.linkedin/",
                "features": ["posting", "connections"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },

            # AI & Machine Learning
            {
                "name": "OpenAI",
                "key": "OPENAI",
                "description": "OpenAI, the creator of ChatGPT, offers a range of powerful models including GPT-3, DALL·E, and Whisper. Leverage these models to build AI-powered workflows.",
                "category": "AI",
                "subcategory": "Language Models",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/openai.svg",
                "base_url": "https://api.openai.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.openai/",
                "features": ["chat", "completions", "images"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },
            {
                "name": "Anthropic",
                "key": "ANTHROPIC",
                "description": "The Anthropic app, built by the creators of Claude, is an AI chat app that lets you talk to Claude on the go.",
                "category": "AI",
                "subcategory": "Language Models",
                "icon_url": "https://docs.anthropic.com/claude/reference/claude_logo_icon.svg",
                "base_url": "https://api.anthropic.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.anthropic/",
                "features": ["chat", "text_generation"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },
            {
                "name": "Google Gemini",
                "key": "GOOGLE_GEMINI",
                "description": "Google Gemini is an AI assistant app that answers questions, summarizes information, and helps you dive deeper into topics you care about.",
                "category": "AI",
                "subcategory": "Language Models",
                "icon_url": "https://www.gstatic.com/lamda/images/gemini_sparkle_v002_d4735304ff6292a690345.svg",
                "base_url": "https://generativelanguage.googleapis.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlegemini/",
                "features": ["chat", "multimodal"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },

            # Google Workspace
            {
                "name": "Google Sheets",
                "key": "GOOGLE_SHEETS",
                "description": "Google Sheets is a web-based spreadsheet program offered by Google for free. It similar to Microsoft Excel, and can be accessed anywhere on any device, you only need a Google account.",
                "category": "Productivity",
                "subcategory": "Spreadsheets",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/googlesheets.svg",
                "base_url": "https://sheets.googleapis.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlesheets/",
                "features": ["data_manipulation", "automation"],
                "auth_methods": ["oauth2", "service_account"],
                "is_popular": True
            },
            {
                "name": "Google Drive",
                "key": "GOOGLE_DRIVE",
                "description": "Google Drive is a storage and synchronization service offered by Google.",
                "category": "Productivity",
                "subcategory": "File Storage",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/googledrive.svg",
                "base_url": "https://www.googleapis.com/drive/v3",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googledrive/",
                "features": ["file_management", "sharing"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },
            {
                "name": "Google Calendar",
                "key": "GOOGLE_CALENDAR",
                "description": "Google Calendar integration for scheduling",
                "category": "Productivity",
                "subcategory": "Calendar",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/googlecalendar.svg",
                "base_url": "https://www.googleapis.com/calendar/v3",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googlecalendar/",
                "features": ["events", "scheduling"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },

            # Development Tools
            {
                "name": "GitHub",
                "key": "GITHUB",
                "description": "GitHub integration for Development",
                "category": "Development",
                "subcategory": "Version Control",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/github.svg",
                "base_url": "https://api.github.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.github/",
                "features": ["repositories", "issues", "pull_requests"],
                "auth_methods": ["oauth2", "token"],
                "is_popular": True
            },
            {
                "name": "GitLab",
                "key": "GITLAB",
                "description": "GitLab integration for Development",
                "category": "Development",
                "subcategory": "Version Control",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/gitlab.svg",
                "base_url": "https://gitlab.com/api/v4",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.gitlab/",
                "features": ["repositories", "pipelines"],
                "auth_methods": ["token"],
                "is_popular": True
            },
            {
                "name": "Docker",
                "key": "DOCKER",
                "description": "Docker integration for Development",
                "category": "Development",
                "subcategory": "DevOps",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/docker.svg",
                "base_url": "https://docs.docker.com/engine/api",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.docker/",
                "features": ["containers", "images"],
                "auth_methods": ["api_key"],
                "is_popular": False
            },

            # E-commerce & Payment
            {
                "name": "Shopify",
                "key": "SHOPIFY", 
                "description": "Shopify integration for E-commerce",
                "category": "E-commerce",
                "subcategory": "Platform",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/shopify.svg",
                "base_url": "https://shopify.dev/api",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.shopify/",
                "features": ["orders", "products", "customers"],
                "auth_methods": ["oauth2", "api_key"],
                "is_popular": True
            },
            {
                "name": "Stripe",
                "key": "STRIPE",
                "description": "Stripe integration for Payments",
                "category": "E-commerce", 
                "subcategory": "Payment",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/stripe.svg",
                "base_url": "https://api.stripe.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.stripe/",
                "features": ["payments", "subscriptions"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },
            {
                "name": "PayPal",
                "key": "PAYPAL",
                "description": "PayPal integration for Payments",
                "category": "E-commerce",
                "subcategory": "Payment", 
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/paypal.svg",
                "base_url": "https://api.paypal.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.paypal/",
                "features": ["payments", "invoices"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },
            {
                "name": "WooCommerce",
                "key": "WOOCOMMERCE",
                "description": "WooCommerce integration for E-commerce",
                "category": "E-commerce",
                "subcategory": "Platform",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/woocommerce.svg",
                "base_url": "https://woocommerce.github.io/woocommerce-rest-api-docs",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.woocommerce/",
                "features": ["orders", "products"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },

            # Marketing & CRM
            {
                "name": "HubSpot",
                "key": "HUBSPOT",
                "description": "HubSpot integration for Marketing",
                "category": "Marketing",
                "subcategory": "CRM",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/hubspot.svg",
                "base_url": "https://api.hubapi.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.hubspot/",
                "features": ["contacts", "deals", "campaigns"],
                "auth_methods": ["oauth2", "api_key"],
                "is_popular": True
            },
            {
                "name": "Salesforce",
                "key": "SALESFORCE",
                "description": "Salesforce integration for CRM", 
                "category": "Marketing",
                "subcategory": "CRM",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/salesforce.svg",
                "base_url": "https://developer.salesforce.com/docs/api-explorer",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.salesforce/",
                "features": ["leads", "opportunities"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },
            {
                "name": "Mailchimp",
                "key": "MAILCHIMP",
                "description": "Mailchimp integration for Email Marketing",
                "category": "Marketing",
                "subcategory": "Email Marketing",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mailchimp.svg",
                "base_url": "https://mailchimp.com/developer/marketing/api/",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mailchimp/",
                "features": ["campaigns", "lists"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },
            {
                "name": "SendGrid",
                "key": "SENDGRID",
                "description": "SendGrid integration for Email",
                "category": "Marketing", 
                "subcategory": "Email Marketing",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/sendgrid.svg",
                "base_url": "https://sendgrid.com/docs/api/",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.sendgrid/",
                "features": ["email_delivery"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },

            # Productivity & Project Management  
            {
                "name": "Notion",
                "key": "NOTION",
                "description": "Notion integration for Productivity",
                "category": "Productivity",
                "subcategory": "Note Taking",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/notion.svg",
                "base_url": "https://api.notion.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.notion/",
                "features": ["pages", "databases"],
                "auth_methods": ["oauth2", "integration_token"],
                "is_popular": True
            },
            {
                "name": "Trello",
                "key": "TRELLO",
                "description": "Trello integration for Project Management",
                "category": "Productivity",
                "subcategory": "Project Management",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/trello.svg",
                "base_url": "https://api.trello.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.trello/",
                "features": ["boards", "cards", "lists"],
                "auth_methods": ["oauth2", "api_key"],
                "is_popular": True
            },
            {
                "name": "Asana",
                "key": "ASANA",
                "description": "Asana integration for Project Management",
                "category": "Productivity",
                "subcategory": "Project Management",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/asana.svg",
                "base_url": "https://app.asana.com/api/1.0",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.asana/",
                "features": ["tasks", "projects"],
                "auth_methods": ["oauth2", "token"],
                "is_popular": True
            },
            {
                "name": "Monday.com",
                "key": "MONDAY_COM", 
                "description": "Monday.com integration for Project Management",
                "category": "Productivity",
                "subcategory": "Project Management",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/mondaydotcom.svg",
                "base_url": "https://api.monday.com/v2",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.mondaycom/",
                "features": ["boards", "items"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },
            {
                "name": "Jira",
                "key": "JIRA",
                "description": "Jira integration for Issue Tracking",
                "category": "Productivity",
                "subcategory": "Project Management",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/jira.svg",
                "base_url": "https://developer.atlassian.com/cloud/jira/platform/rest/v2/",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.jira/",
                "features": ["issues", "projects"],
                "auth_methods": ["oauth2", "api_token"],
                "is_popular": True
            },
            {
                "name": "ClickUp",
                "key": "CLICKUP",
                "description": "ClickUp integration for Productivity",
                "category": "Productivity",
                "subcategory": "Project Management",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/clickup.svg",
                "base_url": "https://api.clickup.com/api/v2",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.clickup/",
                "features": ["tasks", "automation"],
                "auth_methods": ["api_key"],
                "is_popular": True
            },

            # Database & Analytics
            {
                "name": "Airtable",
                "key": "AIRTABLE",
                "description": "Airtable is the best tool to develop your business. It helps you connect your data, your business processes, and your teams.",
                "category": "Database",
                "subcategory": "Cloud Database",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/airtable.svg",
                "base_url": "https://api.airtable.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.airtable/",
                "features": ["records", "views", "automation"],
                "auth_methods": ["api_key", "oauth2"],
                "is_popular": True
            },
            {
                "name": "Google Analytics",
                "key": "GOOGLE_ANALYTICS",
                "description": "Google Analytics integration for Analytics",
                "category": "Analytics",
                "subcategory": "Web Analytics",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/googleanalytics.svg",
                "base_url": "https://analyticsreporting.googleapis.com",
                "docs_url": "https://docs.n8n.io/integrations/builtin/app-nodes/n8n-nodes-base.googleanalytics/",
                "features": ["reports", "dimensions"],
                "auth_methods": ["oauth2"],
                "is_popular": True
            },

            # Core/Utility Nodes
            {
                "name": "HTTP Request",
                "key": "HTTP_REQUEST",
                "description": "HTTP Request integration for making API calls",
                "category": "Utility",
                "subcategory": "Core",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/http.svg",
                "base_url": None,
                "docs_url": "https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.httprequest/",
                "features": ["api_calls", "webhooks"],
                "auth_methods": ["none", "basic", "oauth2", "api_key"],
                "is_popular": True,
                "is_core": True
            },
            {
                "name": "Webhook",
                "key": "WEBHOOK", 
                "description": "Webhooks are automatic notifications that are sent when something important happens in an app.",
                "category": "Utility",
                "subcategory": "Core",
                "icon_url": "https://docs.n8n.io/assets/images/webhook-5b6a6cb99e19b48e1ce2de9c2e9ad2b5.svg",
                "base_url": None,
                "docs_url": "https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/",
                "features": ["triggers", "automation"],
                "auth_methods": ["none"],
                "is_popular": True,
                "is_core": True
            },
            {
                "name": "Schedule Trigger",
                "key": "SCHEDULE_TRIGGER",
                "description": "Schedule Trigger integration for automated workflows",
                "category": "Utility",
                "subcategory": "Core",
                "icon_url": "https://cdn.jsdelivr.net/npm/simple-icons@v9/icons/clockwise.svg",
                "base_url": None,
                "docs_url": "https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.cron/",
                "features": ["scheduling", "automation"],
                "auth_methods": ["none"],
                "is_popular": True,
                "is_core": True
            }
        ]
        
        return integrations
    
    def convert_to_channel_master_format(self, integration: Dict[str, Any]) -> Dict[str, Any]:
        """Convert integration data to saas_channel_master format"""
        return {
            'channel_key': integration['key'],
            'channel_name': integration['name'],
            'base_url': integration.get('base_url'),
            'docs_url': integration.get('docs_url'),
            'channel_logo_url': integration['icon_url'],
            'default_channel_config': {
                'category': integration['category'],
                'subcategory': integration.get('subcategory'),
                'description': integration['description'],
                'features': integration.get('features', []),
                'is_popular': integration.get('is_popular', False),
                'is_core': integration.get('is_core', False)
            },
            'capabilities': {
                'category': integration['category'],
                'subcategory': integration.get('subcategory'),
                'supported_operations': integration.get('features', []),
                'auth_methods': integration.get('auth_methods', []),
                'is_popular': integration.get('is_popular', False)
            }
        }
    
    def generate_sql_inserts(self, output_file: str = None) -> str:
        """Generate SQL INSERT statements"""
        if not output_file:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_file = f"n8n_curated_integrations_{timestamp}.sql"
        
        integrations = self.get_curated_integrations()
        
        sql_lines = [
            "-- N8N Curated Integrations with High-Quality Icons",
            "-- Generated: " + datetime.now().isoformat(),
            "-- Total integrations: " + str(len(integrations)),
            "",
            "BEGIN;",
            "",
            "-- Enable UUID extension",
            "CREATE EXTENSION IF NOT EXISTS pgcrypto;",
            ""
        ]
        
        for integration in integrations:
            channel_data = self.convert_to_channel_master_format(integration)
            
            # Generate INSERT with ON CONFLICT UPDATE
            insert_sql = f"""-- Insert {channel_data['channel_name']}
INSERT INTO saas_channel_master (
    channel_key,
    channel_name,
    base_url,
    docs_url,
    channel_logo_url,
    default_channel_config,
    capabilities
) VALUES (
    '{channel_data['channel_key']}',
    '{channel_data['channel_name']}',
    {f"'{channel_data['base_url']}'" if channel_data['base_url'] else 'NULL'},
    {f"'{channel_data['docs_url']}'" if channel_data['docs_url'] else 'NULL'},
    '{channel_data['channel_logo_url']}',
    '{json.dumps(channel_data['default_channel_config']).replace("'", "''")}'::jsonb,
    '{json.dumps(channel_data['capabilities']).replace("'", "''")}'::jsonb
) ON CONFLICT (channel_key) DO UPDATE SET
    channel_name = EXCLUDED.channel_name,
    base_url = EXCLUDED.base_url,
    docs_url = EXCLUDED.docs_url,
    channel_logo_url = EXCLUDED.channel_logo_url,
    default_channel_config = EXCLUDED.default_channel_config,
    capabilities = EXCLUDED.capabilities,
    updated_at = NOW();
"""
            sql_lines.append(insert_sql)
        
        sql_lines.extend([
            "",
            "COMMIT;",
            "",
            "-- Verification",
            "SELECT COUNT(*) as total_channels FROM saas_channel_master;",
            "SELECT channel_key, channel_name, channel_logo_url FROM saas_channel_master WHERE channel_key IN (" + ', '.join([f"'{i['key']}'" for i in integrations]) + ") ORDER BY channel_name;"
        ])
        
        sql_content = "\n".join(sql_lines)
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(sql_content)
        
        logger.info(f"Generated SQL file: {output_file}")
        return output_file
    
    def update_database(self) -> bool:
        """Update saas_channel_master table directly"""
        if not self.db_config:
            logger.error("No database configuration provided")
            return False
        
        try:
            conn = psycopg2.connect(**self.db_config)
            cur = conn.cursor(cursor_factory=RealDictCursor)
            
            integrations = self.get_curated_integrations()
            updated_count = 0
            inserted_count = 0
            
            for integration in integrations:
                try:
                    channel_data = self.convert_to_channel_master_format(integration)
                    
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
                    logger.info(f"Processed: {integration['name']}")
                    
                except Exception as e:
                    logger.error(f"Error processing {integration['name']}: {e}")
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
    parser = argparse.ArgumentParser(description='N8N Simple Scraper with High-Quality Icons')
    parser.add_argument('--update-db', action='store_true', help='Update database directly')
    parser.add_argument('--generate-sql', action='store_true', help='Generate SQL file')
    parser.add_argument('--db-host', default='127.0.0.1', help='Database host')
    parser.add_argument('--db-user', default='postgres', help='Database user')  
    parser.add_argument('--db-password', default='saasdbforwindmill2023', help='Database password')
    parser.add_argument('--db-name', default='catalog-edge-db', help='Database name')
    parser.add_argument('--output-file', help='Output SQL file name')
    
    args = parser.parse_args()
    
    # Database configuration
    db_config = {
        'host': args.db_host,
        'user': args.db_user,
        'password': args.db_password,
        'database': args.db_name,
        'port': 5432
    }
    
    scraper = N8NSimpleScraper(db_config)
    
    if args.generate_sql:
        sql_file = scraper.generate_sql_inserts(args.output_file)
        logger.info(f"SQL file generated: {sql_file}")
    
    if args.update_db:
        success = scraper.update_database()
        if success:
            logger.info("Successfully updated channel master database!")
        else:
            logger.error("Failed to update database")

if __name__ == "__main__":
    main()

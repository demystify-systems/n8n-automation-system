# Next.js Integration Setup Guide

## 🚀 Setting up N8N Channel Integrations in Your Next.js Project

This guide walks you through integrating the N8N channel management system with your Next.js application, enabling dynamic multi-tenant SaaS integrations.

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Database Setup](#database-setup)
3. [Environment Configuration](#environment-configuration)
4. [Next.js Project Structure](#nextjs-project-structure)
5. [API Routes Setup](#api-routes-setup)
6. [Frontend Components](#frontend-components)
7. [Integration Flows](#integration-flows)
8. [Authentication & Security](#authentication--security)
9. [Testing & Deployment](#testing--deployment)

---

## 🔧 Prerequisites

### Required Technologies
- **Next.js 14+** (App Router)
- **TypeScript** (recommended)
- **PostgreSQL** (catalog-edge-db)
- **N8N Instance** (https://spinner.saastify.ai)
- **Docker** (for Cloud SQL proxy)

### Database Requirements
- Access to `catalog-edge-db` with 200+ channels in `saas_channel_master`
- Tables: `saas_channel_installations`, `saas_channel_credentials`, `saas_edge_jobs`

---

## 🗄️ Database Setup

### 1. Verify Channel Master Data
```sql
-- Check available channels
SELECT channel_key, channel_name, COUNT(*) 
FROM saas_channel_master 
GROUP BY channel_key, channel_name 
ORDER BY channel_name;

-- Verify table structure
\d saas_channel_master
```

### 2. Required Database Functions
```sql
-- Function to get tenant credentials
CREATE OR REPLACE FUNCTION get_tenant_credential(
    p_saas_edge_id UUID,
    p_channel_key TEXT,
    p_credential_key TEXT
) RETURNS JSONB AS $$
BEGIN
    RETURN (
        SELECT installation_config->>p_credential_key
        FROM saas_channel_installations sci
        JOIN saas_channel_master scm ON sci.channel_id = scm.channel_id
        WHERE sci.saas_edge_id = p_saas_edge_id 
        AND scm.channel_key = p_channel_key
        AND sci.is_active = true
    )::jsonb;
END;
$$ LANGUAGE plpgsql;
```

---

## ⚙️ Environment Configuration

### `.env.local`
```bash
# Database Connection
DATABASE_URL="postgresql://postgres:saasdbforwindmill2023@localhost:5432/catalog-edge-db"
DB_HOST=127.0.0.1
DB_USER=postgres
DB_PASSWORD=saasdbforwindmill2023
DB_NAME=catalog-edge-db

# N8N Configuration
N8N_BASE_URL=https://spinner.saastify.ai
N8N_API_KEY=your-n8n-api-key
N8N_WEBHOOK_BASE_URL=https://spinner.saastify.ai/webhook

# Application Settings
NEXTAUTH_SECRET=your-nextauth-secret
NEXTAUTH_URL=http://localhost:3000

# GCP Settings (if needed)
GOOGLE_CLOUD_PROJECT=saastify-base-wm
GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json
```

### `docker-compose.yml` (for SQL proxy)
```yaml
version: '3.8'
services:
  cloud-sql-proxy:
    image: gcr.io/cloudsql-docker/gce-proxy:1.33.7
    command:
      - "/cloud_sql_proxy"
      - "-instances=saastify-base-wm:us-central1:saastify-pgdb-us=tcp:0.0.0.0:5432"
      - "-credential_file=/config/key.json"
    ports:
      - "5432:5432"
    volumes:
      - /path/to/service-account.json:/config/key.json:ro
    restart: unless-stopped
```

---

## 🏗️ Next.js Project Structure

```
src/
├── app/
│   ├── api/
│   │   ├── channels/
│   │   │   ├── route.ts                 # Get available channels
│   │   │   └── [channelKey]/
│   │   │       ├── install/route.ts     # Install channel
│   │   │       ├── configure/route.ts   # Configure credentials
│   │   │       └── webhook/route.ts     # Webhook handler
│   │   ├── integrations/
│   │   │   ├── route.ts                 # List installations
│   │   │   └── [id]/
│   │   │       ├── route.ts             # Get/Update/Delete
│   │   │       └── test/route.ts        # Test connection
│   │   └── n8n/
│   │       ├── workflows/route.ts       # Manage workflows
│   │       └── execute/route.ts         # Execute workflows
│   ├── dashboard/
│   │   ├── integrations/
│   │   │   ├── page.tsx                 # Integration dashboard
│   │   │   ├── marketplace/page.tsx     # Channel marketplace
│   │   │   └── [id]/
│   │   │       ├── page.tsx             # Integration details
│   │   │       └── configure/page.tsx   # Configuration page
│   └── globals.css
├── components/
│   ├── integrations/
│   │   ├── ChannelCard.tsx              # Individual channel display
│   │   ├── ChannelMarketplace.tsx       # Browse available channels
│   │   ├── InstallationWizard.tsx       # Step-by-step installation
│   │   ├── CredentialForm.tsx           # Dynamic credential forms
│   │   └── IntegrationStatus.tsx        # Connection status
│   └── ui/
│       ├── Button.tsx
│       ├── Card.tsx
│       └── Form.tsx
├── lib/
│   ├── database.ts                      # Database connection
│   ├── n8n-client.ts                    # N8N API client
│   ├── integration-service.ts           # Integration business logic
│   └── types.ts                         # TypeScript definitions
└── hooks/
    ├── useChannels.ts                   # Fetch available channels
    ├── useInstallations.ts              # Manage installations
    └── useN8nWorkflows.ts               # N8N workflow management
```

---

## 🛠️ API Routes Setup

### 1. Database Connection (`lib/database.ts`)
```typescript
import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

export { pool };

// Helper function for database queries
export async function query(text: string, params?: any[]) {
  const client = await pool.connect();
  try {
    const result = await client.query(text, params);
    return result;
  } finally {
    client.release();
  }
}
```

### 2. Channel Types (`lib/types.ts`)
```typescript
export interface Channel {
  channel_id: string;
  channel_key: string;
  channel_name: string;
  base_url?: string;
  docs_url?: string;
  channel_logo_url?: string;
  default_channel_config: Record<string, any>;
  capabilities: Record<string, any>;
  credential_schema?: Record<string, any>;
  auth_methods?: string[];
  created_at: string;
  updated_at: string;
}

export interface ChannelInstallation {
  installation_id: string;
  saas_edge_id: string;
  channel_id: string;
  installation_config: Record<string, any>;
  is_active: boolean;
  installed_at: string;
  channel?: Channel;
}

export interface InstallationRequest {
  channelKey: string;
  credentials: Record<string, any>;
  config?: Record<string, any>;
}
```

### 3. Get Available Channels (`app/api/channels/route.ts`)
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/database';
import { Channel } from '@/lib/types';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const category = searchParams.get('category');
    const search = searchParams.get('search');

    let sql = `
      SELECT channel_id, channel_key, channel_name, base_url, docs_url, 
             channel_logo_url, default_channel_config, capabilities
      FROM saas_channel_master 
      WHERE 1=1
    `;
    const params: any[] = [];

    if (category) {
      sql += ` AND capabilities->>'category' = $${params.length + 1}`;
      params.push(category);
    }

    if (search) {
      sql += ` AND (channel_name ILIKE $${params.length + 1} OR channel_key ILIKE $${params.length + 1})`;
      params.push(`%${search}%`);
    }

    sql += ` ORDER BY channel_name`;

    const result = await query(sql, params);
    const channels: Channel[] = result.rows;

    return NextResponse.json({
      success: true,
      data: channels,
      total: channels.length,
    });

  } catch (error) {
    console.error('Error fetching channels:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch channels' },
      { status: 500 }
    );
  }
}
```

### 4. Install Channel (`app/api/channels/[channelKey]/install/route.ts`)
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/database';
import { InstallationRequest } from '@/lib/types';

export async function POST(
  request: NextRequest,
  { params }: { params: { channelKey: string } }
) {
  try {
    const body: InstallationRequest = await request.json();
    const { channelKey } = params;
    const { credentials, config = {} } = body;

    // Get user's saas_edge_id from session/auth
    const saasEdgeId = request.headers.get('x-saas-edge-id') || 'demo-tenant';

    // Get channel info
    const channelResult = await query(
      'SELECT channel_id FROM saas_channel_master WHERE channel_key = $1',
      [channelKey]
    );

    if (channelResult.rows.length === 0) {
      return NextResponse.json(
        { success: false, error: 'Channel not found' },
        { status: 404 }
      );
    }

    const channelId = channelResult.rows[0].channel_id;

    // Check if already installed
    const existingResult = await query(
      'SELECT installation_id FROM saas_channel_installations WHERE saas_edge_id = $1 AND channel_id = $2',
      [saasEdgeId, channelId]
    );

    const installationConfig = {
      credentials,
      config,
      installed_by: 'user', // Get from auth
      installation_date: new Date().toISOString(),
    };

    let result;
    if (existingResult.rows.length > 0) {
      // Update existing installation
      result = await query(
        `UPDATE saas_channel_installations 
         SET installation_config = $1, is_active = true, updated_at = NOW()
         WHERE saas_edge_id = $2 AND channel_id = $3
         RETURNING installation_id`,
        [JSON.stringify(installationConfig), saasEdgeId, channelId]
      );
    } else {
      // Create new installation
      result = await query(
        `INSERT INTO saas_channel_installations 
         (saas_edge_id, channel_id, installation_config, is_active)
         VALUES ($1, $2, $3, true)
         RETURNING installation_id`,
        [saasEdgeId, channelId, JSON.stringify(installationConfig)]
      );
    }

    return NextResponse.json({
      success: true,
      data: {
        installation_id: result.rows[0].installation_id,
        channel_key: channelKey,
        status: 'installed',
      },
    });

  } catch (error) {
    console.error('Error installing channel:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to install channel' },
      { status: 500 }
    );
  }
}
```

### 5. Get User Installations (`app/api/integrations/route.ts`)
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/database';

export async function GET(request: NextRequest) {
  try {
    const saasEdgeId = request.headers.get('x-saas-edge-id') || 'demo-tenant';

    const sql = `
      SELECT 
        sci.installation_id,
        sci.saas_edge_id,
        sci.channel_id,
        sci.installation_config,
        sci.is_active,
        sci.installed_at,
        sci.updated_at,
        scm.channel_key,
        scm.channel_name,
        scm.channel_logo_url,
        scm.capabilities
      FROM saas_channel_installations sci
      JOIN saas_channel_master scm ON sci.channel_id = scm.channel_id
      WHERE sci.saas_edge_id = $1
      ORDER BY sci.installed_at DESC
    `;

    const result = await query(sql, [saasEdgeId]);

    return NextResponse.json({
      success: true,
      data: result.rows,
      total: result.rows.length,
    });

  } catch (error) {
    console.error('Error fetching installations:', error);
    return NextResponse.json(
      { success: false, error: 'Failed to fetch installations' },
      { status: 500 }
    );
  }
}
```

---

## 🎨 Frontend Components

### 1. Channel Marketplace (`components/integrations/ChannelMarketplace.tsx`)
```tsx
'use client';

import { useState, useEffect } from 'react';
import { Channel } from '@/lib/types';
import ChannelCard from './ChannelCard';

interface ChannelMarketplaceProps {
  onInstall: (channel: Channel) => void;
}

export default function ChannelMarketplace({ onInstall }: ChannelMarketplaceProps) {
  const [channels, setChannels] = useState<Channel[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [category, setCategory] = useState('');

  useEffect(() => {
    fetchChannels();
  }, [search, category]);

  const fetchChannels = async () => {
    try {
      const params = new URLSearchParams();
      if (search) params.append('search', search);
      if (category) params.append('category', category);

      const response = await fetch(`/api/channels?${params}`);
      const data = await response.json();

      if (data.success) {
        setChannels(data.data);
      }
    } catch (error) {
      console.error('Error fetching channels:', error);
    } finally {
      setLoading(false);
    }
  };

  const categories = [
    'Communication',
    'E-commerce',
    'Marketing',
    'Productivity',
    'Finance',
    'Analytics',
    'Developer Tools',
  ];

  if (loading) {
    return <div className="flex justify-center py-8">Loading channels...</div>;
  }

  return (
    <div className="space-y-6">
      {/* Search & Filters */}
      <div className="flex flex-col sm:flex-row gap-4">
        <input
          type="text"
          placeholder="Search integrations..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
        />
        
        <select
          value={category}
          onChange={(e) => setCategory(e.target.value)}
          className="px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
        >
          <option value="">All Categories</option>
          {categories.map((cat) => (
            <option key={cat} value={cat}>{cat}</option>
          ))}
        </select>
      </div>

      {/* Channel Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {channels.map((channel) => (
          <ChannelCard
            key={channel.channel_id}
            channel={channel}
            onInstall={() => onInstall(channel)}
          />
        ))}
      </div>

      {channels.length === 0 && (
        <div className="text-center py-8 text-gray-500">
          No channels found matching your criteria.
        </div>
      )}
    </div>
  );
}
```

### 2. Channel Card (`components/integrations/ChannelCard.tsx`)
```tsx
import { Channel } from '@/lib/types';
import Image from 'next/image';

interface ChannelCardProps {
  channel: Channel;
  onInstall: () => void;
}

export default function ChannelCard({ channel, onInstall }: ChannelCardProps) {
  const category = channel.capabilities?.category || 'Other';
  const description = channel.default_channel_config?.description || 
    `Connect with ${channel.channel_name} to automate your workflows.`;

  return (
    <div className="bg-white rounded-lg border border-gray-200 p-6 hover:shadow-lg transition-shadow">
      {/* Header */}
      <div className="flex items-center gap-4 mb-4">
        {channel.channel_logo_url && (
          <div className="w-12 h-12 relative">
            <Image
              src={channel.channel_logo_url}
              alt={`${channel.channel_name} logo`}
              fill
              className="object-contain rounded-lg"
            />
          </div>
        )}
        <div>
          <h3 className="text-lg font-semibold text-gray-900">
            {channel.channel_name}
          </h3>
          <p className="text-sm text-gray-500">{category}</p>
        </div>
      </div>

      {/* Description */}
      <p className="text-gray-600 text-sm mb-4 line-clamp-3">
        {description}
      </p>

      {/* Features */}
      <div className="flex flex-wrap gap-2 mb-4">
        {channel.capabilities?.features?.slice(0, 3).map((feature: string) => (
          <span
            key={feature}
            className="px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full"
          >
            {feature}
          </span>
        ))}
      </div>

      {/* Actions */}
      <div className="flex justify-between items-center">
        {channel.docs_url && (
          <a
            href={channel.docs_url}
            target="_blank"
            rel="noopener noreferrer"
            className="text-blue-600 hover:text-blue-800 text-sm"
          >
            View Docs
          </a>
        )}
        
        <button
          onClick={onInstall}
          className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors"
        >
          Install
        </button>
      </div>
    </div>
  );
}
```

### 3. Installation Wizard (`components/integrations/InstallationWizard.tsx`)
```tsx
'use client';

import { useState } from 'react';
import { Channel } from '@/lib/types';
import CredentialForm from './CredentialForm';

interface InstallationWizardProps {
  channel: Channel;
  onComplete: () => void;
  onCancel: () => void;
}

export default function InstallationWizard({ 
  channel, 
  onComplete, 
  onCancel 
}: InstallationWizardProps) {
  const [step, setStep] = useState(1);
  const [credentials, setCredentials] = useState<Record<string, any>>({});
  const [loading, setLoading] = useState(false);

  const handleInstall = async () => {
    setLoading(true);
    try {
      const response = await fetch(`/api/channels/${channel.channel_key}/install`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-saas-edge-id': 'demo-tenant', // Get from auth
        },
        body: JSON.stringify({
          channelKey: channel.channel_key,
          credentials,
        }),
      });

      const data = await response.json();
      if (data.success) {
        onComplete();
      } else {
        alert('Installation failed: ' + data.error);
      }
    } catch (error) {
      console.error('Installation error:', error);
      alert('Installation failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-lg max-w-md w-full p-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-semibold">
            Install {channel.channel_name}
          </h2>
          <button
            onClick={onCancel}
            className="text-gray-400 hover:text-gray-600"
          >
            ✕
          </button>
        </div>

        {/* Steps */}
        <div className="mb-6">
          <div className="flex items-center">
            <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium ${
              step >= 1 ? 'bg-blue-600 text-white' : 'bg-gray-200 text-gray-600'
            }`}>
              1
            </div>
            <div className="flex-1 ml-2">
              <p className="text-sm font-medium">Configure Credentials</p>
            </div>
          </div>
        </div>

        {/* Content */}
        {step === 1 && (
          <div className="space-y-4">
            <CredentialForm
              channel={channel}
              values={credentials}
              onChange={setCredentials}
            />
            
            <div className="flex gap-3">
              <button
                onClick={onCancel}
                className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                onClick={handleInstall}
                disabled={loading}
                className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50"
              >
                {loading ? 'Installing...' : 'Install'}
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
```

---

## 🔗 Integration Flows

### 1. N8N Webhook Execution
```typescript
// app/api/channels/[channelKey]/webhook/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { query } from '@/lib/database';

export async function POST(
  request: NextRequest,
  { params }: { params: { channelKey: string } }
) {
  try {
    const { channelKey } = params;
    const payload = await request.json();
    
    // Get webhook URL from channel config
    const channelResult = await query(
      'SELECT capabilities FROM saas_channel_master WHERE channel_key = $1',
      [channelKey]
    );

    const webhookUrl = channelResult.rows[0]?.capabilities?.webhook_url;
    
    if (webhookUrl) {
      // Forward to N8N webhook
      const n8nResponse = await fetch(webhookUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      const result = await n8nResponse.json();
      
      // Log execution
      await query(
        `INSERT INTO saas_edge_jobs (channel_key, execution_data, status)
         VALUES ($1, $2, $3)`,
        [channelKey, JSON.stringify(result), 'completed']
      );

      return NextResponse.json(result);
    }

    return NextResponse.json(
      { error: 'Webhook not configured' },
      { status: 400 }
    );

  } catch (error) {
    console.error('Webhook error:', error);
    return NextResponse.json(
      { error: 'Webhook execution failed' },
      { status: 500 }
    );
  }
}
```

### 2. Dynamic Credential Injection for N8N
```typescript
// lib/n8n-client.ts
export class N8nClient {
  private baseUrl: string;
  private apiKey: string;

  constructor(baseUrl: string, apiKey: string) {
    this.baseUrl = baseUrl;
    this.apiKey = apiKey;
  }

  async executeWorkflow(workflowId: string, data: any, tenantId: string) {
    // Inject tenant-specific credentials into workflow
    const enrichedData = await this.injectCredentials(data, tenantId);

    const response = await fetch(`${this.baseUrl}/api/v1/workflows/${workflowId}/execute`, {
      method: 'POST',
      headers: {
        'X-N8N-API-KEY': this.apiKey,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        data: enrichedData,
        // Add tenant context for credential resolution
        additionalData: {
          tenant_id: tenantId,
        },
      }),
    });

    return response.json();
  }

  private async injectCredentials(data: any, tenantId: string) {
    // This would integrate with your credential management system
    // to dynamically inject credentials based on tenant
    return data;
  }
}
```

---

## 🔐 Authentication & Security

### 1. Tenant Isolation
```typescript
// middleware.ts
import { NextRequest, NextResponse } from 'next/server';

export function middleware(request: NextRequest) {
  // Extract tenant from subdomain or header
  const host = request.headers.get('host') || '';
  const subdomain = host.split('.')[0];
  
  // Set tenant context
  const requestHeaders = new Headers(request.headers);
  requestHeaders.set('x-saas-edge-id', subdomain);
  
  return NextResponse.next({
    request: {
      headers: requestHeaders,
    },
  });
}

export const config = {
  matcher: ['/api/((?!auth).*)'],
};
```

### 2. API Key Management
```typescript
// lib/auth.ts
import { query } from './database';

export async function validateApiKey(apiKey: string) {
  const result = await query(
    'SELECT saas_edge_id FROM api_keys WHERE key_hash = $1 AND is_active = true',
    [hashApiKey(apiKey)]
  );
  
  return result.rows[0]?.saas_edge_id || null;
}

export function hashApiKey(key: string): string {
  // Use bcrypt or similar for production
  return Buffer.from(key).toString('base64');
}
```

---

## 🧪 Testing & Deployment

### 1. Integration Tests
```typescript
// __tests__/api/channels.test.ts
import { GET } from '@/app/api/channels/route';
import { NextRequest } from 'next/server';

describe('/api/channels', () => {
  it('should return available channels', async () => {
    const request = new NextRequest('http://localhost:3000/api/channels');
    const response = await GET(request);
    const data = await response.json();
    
    expect(data.success).toBe(true);
    expect(Array.isArray(data.data)).toBe(true);
  });
});
```

### 2. Environment Setup Script
```bash
#!/bin/bash
# scripts/setup.sh

echo "🚀 Setting up Next.js Integration Environment"

# Start Cloud SQL Proxy
echo "Starting Cloud SQL Proxy..."
docker-compose up -d cloud-sql-proxy

# Wait for proxy to be ready
echo "Waiting for database connection..."
sleep 5

# Test database connection
npm run db:test

# Install dependencies
echo "Installing dependencies..."
npm install

# Run database migrations
echo "Running migrations..."
npm run db:migrate

# Start development server
echo "Starting development server..."
npm run dev
```

### 3. Deployment Configuration
```yaml
# docker-compose.production.yml
version: '3.8'
services:
  nextjs-app:
    build: .
    environment:
      - NODE_ENV=production
      - DATABASE_URL=${DATABASE_URL}
      - N8N_BASE_URL=${N8N_BASE_URL}
      - N8N_API_KEY=${N8N_API_KEY}
    ports:
      - "3000:3000"
    depends_on:
      - cloud-sql-proxy
  
  cloud-sql-proxy:
    image: gcr.io/cloudsql-docker/gce-proxy:1.33.7
    command:
      - "/cloud_sql_proxy"
      - "-instances=${GCP_SQL_CONNECTION_NAME}=tcp:0.0.0.0:5432"
    environment:
      - GOOGLE_APPLICATION_CREDENTIALS=/config/key.json
    volumes:
      - ./service-account.json:/config/key.json:ro
```

---

## 📋 Quick Start Checklist

- [ ] **Database Setup**
  - [ ] Cloud SQL proxy running
  - [ ] 200+ channels loaded in `saas_channel_master`
  - [ ] Required database functions created

- [ ] **Next.js Project**
  - [ ] Dependencies installed (`npm install`)
  - [ ] Environment variables configured
  - [ ] Database connection tested

- [ ] **API Routes**
  - [ ] `/api/channels` - Get available channels
  - [ ] `/api/channels/[channelKey]/install` - Install channel  
  - [ ] `/api/integrations` - List user installations

- [ ] **Frontend Components**
  - [ ] Channel marketplace page
  - [ ] Installation wizard
  - [ ] Integration dashboard

- [ ] **Security**
  - [ ] Tenant isolation middleware
  - [ ] API authentication
  - [ ] Credential encryption

- [ ] **Testing**
  - [ ] Database connection test
  - [ ] API endpoint tests
  - [ ] Integration flow tests

---

## 🎯 Next Steps

1. **Implement Authentication**: Add NextAuth.js or similar
2. **Add Webhook Handlers**: Create endpoints for N8N webhooks
3. **Build Admin Panel**: Manage channels and monitor usage  
4. **Add Analytics**: Track integration usage and performance
5. **Deploy to Production**: Use Docker + GCP Cloud Run

---

**🚀 Ready to build your SaaS integration platform!**

For questions or support, refer to the [N8N Integration Sync Guide](./N8N_INTEGRATION_SYNC_GUIDE.md) or check the main [WARP.md](./docs/WARP.md) documentation.

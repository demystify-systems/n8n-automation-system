#!/usr/bin/env python3
"""
N8N Credential Expression System
================================

This module provides utilities to create n8n expressions that dynamically
pull credentials from your catalog-edge-db database at runtime.

Features:
- Database credential lookup expressions
- Multi-tenant credential isolation
- Secure credential handling
- Dynamic configuration injection
"""

import os
import json
import psycopg2
import psycopg2.extras
from typing import Dict, List, Optional, Any
import logging
from datetime import datetime

logger = logging.getLogger(__name__)

class N8NCredentialExpressions:
    """Generates n8n expressions for dynamic credential retrieval"""
    
    def __init__(self, db_config: Dict[str, str]):
        self.db_config = db_config
    
    def create_credential_lookup_expression(
        self, 
        saas_edge_id: str, 
        channel_key: str, 
        credential_field: str,
        fallback_value: Optional[str] = None
    ) -> str:
        """
        Create an n8n expression to lookup credentials from database
        
        Args:
            saas_edge_id: Tenant identifier
            channel_key: Channel key (e.g., 'SHOPIFY', 'EBAY')
            credential_field: Specific credential field name
            fallback_value: Optional fallback if credential not found
        
        Returns:
            N8N expression string for dynamic credential lookup
        """
        expression = f"""
        {{{{
          $json.getCredential(
            '{saas_edge_id}',
            '{channel_key}', 
            '{credential_field}',
            '{fallback_value or ""}'
          )
        }}}}
        """.strip()
        
        return expression
    
    def create_database_function_for_n8n(self) -> str:
        """
        Create a PostgreSQL function that n8n can call to get credentials
        This function should be deployed to your database
        """
        return """
        CREATE OR REPLACE FUNCTION get_tenant_credential(
            p_saas_edge_id UUID,
            p_channel_key TEXT,
            p_credential_field TEXT,
            p_fallback_value TEXT DEFAULT NULL
        )
        RETURNS TEXT
        LANGUAGE plpgsql
        SECURITY DEFINER
        AS $$
        DECLARE
            credential_value TEXT;
            installation_config JSONB;
        BEGIN
            -- Get credential from channel installations
            SELECT 
                installation_config->>p_credential_field INTO credential_value
            FROM saas_channel_installations sci
            JOIN saas_channel_master scm ON sci.channel_id = scm.channel_id
            WHERE sci.saas_edge_id = p_saas_edge_id 
            AND scm.channel_key = p_channel_key
            AND sci.installation_status = 'active'
            LIMIT 1;
            
            -- If not found in installations, check global defaults
            IF credential_value IS NULL THEN
                SELECT 
                    default_channel_config->>p_credential_field INTO credential_value
                FROM saas_channel_master
                WHERE channel_key = p_channel_key;
            END IF;
            
            -- Return credential or fallback
            RETURN COALESCE(credential_value, p_fallback_value);
            
        EXCEPTION WHEN OTHERS THEN
            -- Log error and return fallback
            INSERT INTO credential_lookup_errors (
                saas_edge_id, channel_key, credential_field, 
                error_message, created_at
            ) VALUES (
                p_saas_edge_id, p_channel_key, p_credential_field,
                SQLERRM, NOW()
            );
            
            RETURN p_fallback_value;
        END;
        $$;
        
        -- Create error logging table if it doesn't exist
        CREATE TABLE IF NOT EXISTS credential_lookup_errors (
            error_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
            saas_edge_id UUID,
            channel_key TEXT,
            credential_field TEXT,
            error_message TEXT,
            created_at TIMESTAMPTZ DEFAULT NOW()
        );
        
        -- Create index for performance
        CREATE INDEX IF NOT EXISTS idx_credential_errors_edge_channel 
        ON credential_lookup_errors (saas_edge_id, channel_key, created_at);
        """
    
    def create_n8n_custom_function(self) -> str:
        """
        Create a custom JavaScript function for n8n to call the database function
        This goes in your n8n Code node or as a custom function
        """
        return """
        // N8N Custom Function: Database Credential Lookup
        // Add this to a Code node in your n8n workflows
        
        const { Client } = require('pg');
        
        // Database connection configuration
        const dbConfig = {
            host: '${{$env.DB_HOST}}',
            port: parseInt('${{$env.DB_PORT}}'),
            database: '${{$env.DB_NAME}}',
            user: '${{$env.DB_USER}}',
            password: '${{$env.DB_PASSWORD}}'
        };
        
        async function getCredential(saasEdgeId, channelKey, credentialField, fallbackValue = null) {
            const client = new Client(dbConfig);
            
            try {
                await client.connect();
                
                const result = await client.query(
                    'SELECT get_tenant_credential($1, $2, $3, $4) as credential_value',
                    [saasEdgeId, channelKey, credentialField, fallbackValue]
                );
                
                return result.rows[0]?.credential_value || fallbackValue;
                
            } catch (error) {
                console.error('Credential lookup failed:', error);
                return fallbackValue;
            } finally {
                await client.end();
            }
        }
        
        // Usage in n8n expressions:
        // {{ $getCredential('tenant-uuid', 'SHOPIFY', 'api_key', 'default-key') }}
        
        // Make function available globally
        global.getCredential = getCredential;
        
        // For the current workflow execution
        return {
            getCredential: getCredential
        };
        """
    
    def create_workflow_template_with_dynamic_credentials(
        self, 
        node_type: str,
        channel_key: str,
        operation: str,
        required_credentials: List[str]
    ) -> Dict[str, Any]:
        """
        Create an n8n workflow template that uses dynamic credentials
        """
        
        # Create credential expressions for each required field
        credential_expressions = {}
        for cred_field in required_credentials:
            credential_expressions[cred_field] = (
                f"={{{{ $getCredential($json.saas_edge_id, '{channel_key}', '{cred_field}') }}}}"
            )
        
        workflow = {
            "meta": {
                "instanceId": "dynamic-credential-workflow"
            },
            "nodes": [
                {
                    "parameters": {
                        "httpMethod": "POST",
                        "path": f"/{channel_key.lower()}/{operation}",
                        "responseMode": "onReceived",
                        "options": {}
                    },
                    "id": "webhook-trigger",
                    "name": "Webhook Trigger",
                    "type": "n8n-nodes-base.webhook",
                    "typeVersion": 1,
                    "position": [300, 300],
                    "webhookId": f"{channel_key.lower()}-{operation}-webhook"
                },
                {
                    "parameters": {
                        "jsCode": self.create_n8n_custom_function()
                    },
                    "id": "credential-loader",
                    "name": "Load Credentials",
                    "type": "n8n-nodes-base.code",
                    "typeVersion": 2,
                    "position": [500, 300]
                },
                {
                    "parameters": {
                        "operation": operation,
                        **credential_expressions,
                        "additionalFields": {
                            "timeout": 30000,
                            "retryAttempts": 3
                        }
                    },
                    "id": f"{node_type}-node",
                    "name": f"{channel_key} {operation.title()}",
                    "type": node_type,
                    "typeVersion": 1,
                    "position": [700, 300]
                },
                {
                    "parameters": {
                        "conditions": {
                            "options": {
                                "caseSensitive": True,
                                "leftValue": "",
                                "typeValidation": "strict"
                            },
                            "conditions": [
                                {
                                    "id": "success-condition",
                                    "leftValue": "={{ $json.success }}",
                                    "rightValue": True,
                                    "operator": {
                                        "type": "boolean",
                                        "operation": "equal"
                                    }
                                }
                            ],
                            "combinator": "and"
                        }
                    },
                    "id": "success-check",
                    "name": "Success Check",
                    "type": "n8n-nodes-base.if",
                    "typeVersion": 2,
                    "position": [900, 300]
                },
                {
                    "parameters": {
                        "resource": "entry",
                        "operation": "create",
                        "table": "saas_edge_jobs",
                        "columns": {
                            "mappingMode": "defineBelow",
                            "value": {
                                "saas_edge_id": "={{ $('Webhook Trigger').item.json.saas_edge_id }}",
                                "job_type": "n8n_workflow",
                                "job_status": "success",
                                "trigger_source": "webhook",
                                "output_summary": "={{ JSON.stringify($json) }}",
                                "metrics": "={{ JSON.stringify({execution_time: $workflow.executionTime, nodes_executed: $workflow.nodesExecuted}) }}"
                            }
                        }
                    },
                    "id": "log-success",
                    "name": "Log Success",
                    "type": "n8n-nodes-base.postgres",
                    "typeVersion": 2.5,
                    "position": [1100, 200]
                },
                {
                    "parameters": {
                        "resource": "entry",
                        "operation": "create",
                        "table": "saas_edge_jobs",
                        "columns": {
                            "mappingMode": "defineBelow",
                            "value": {
                                "saas_edge_id": "={{ $('Webhook Trigger').item.json.saas_edge_id }}",
                                "job_type": "n8n_workflow",
                                "job_status": "error",
                                "trigger_source": "webhook",
                                "error_detail": "={{ JSON.stringify($json.error) }}",
                                "metrics": "={{ JSON.stringify({execution_time: $workflow.executionTime, nodes_executed: $workflow.nodesExecuted}) }}"
                            }
                        }
                    },
                    "id": "log-error",
                    "name": "Log Error",
                    "type": "n8n-nodes-base.postgres",
                    "typeVersion": 2.5,
                    "position": [1100, 400]
                }
            ],
            "connections": {
                "Webhook Trigger": {
                    "main": [
                        [
                            {
                                "node": "Load Credentials",
                                "type": "main",
                                "index": 0
                            }
                        ]
                    ]
                },
                "Load Credentials": {
                    "main": [
                        [
                            {
                                "node": f"{channel_key} {operation.title()}",
                                "type": "main",
                                "index": 0
                            }
                        ]
                    ]
                },
                f"{channel_key} {operation.title()}": {
                    "main": [
                        [
                            {
                                "node": "Success Check",
                                "type": "main",
                                "index": 0
                            }
                        ]
                    ]
                },
                "Success Check": {
                    "main": [
                        [
                            {
                                "node": "Log Success",
                                "type": "main",
                                "index": 0
                            }
                        ],
                        [
                            {
                                "node": "Log Error",
                                "type": "main",
                                "index": 0
                            }
                        ]
                    ]
                }
            },
            "pinData": {},
            "settings": {
                "executionOrder": "v1"
            },
            "staticData": {},
            "tags": [
                {
                    "createdAt": datetime.now().isoformat(),
                    "updatedAt": datetime.now().isoformat(),
                    "id": f"tag-{channel_key.lower()}",
                    "name": channel_key
                }
            ],
            "triggerCount": 1,
            "updatedAt": datetime.now().isoformat(),
            "versionId": "1"
        }
        
        return workflow
    
    def create_credential_management_api(self) -> str:
        """
        Create API endpoints for credential management
        This integrates with your admin portal
        """
        return '''
        # Credential Management API
        # Add to your FastAPI/Flask application
        
        from fastapi import APIRouter, HTTPException, Depends
        from sqlalchemy.orm import Session
        from typing import Dict, Any, Optional
        import json
        
        router = APIRouter(prefix="/api/credentials", tags=["credentials"])
        
        @router.post("/tenant/{saas_edge_id}/channel/{channel_key}")
        async def set_tenant_credentials(
            saas_edge_id: str,
            channel_key: str,
            credentials: Dict[str, Any],
            db: Session = Depends(get_db)
        ):
            """Set credentials for a tenant's channel installation"""
            
            # Find the installation
            installation = db.query(SaasChannelInstallations).join(
                SaasChannelMaster
            ).filter(
                SaasChannelInstallations.saas_edge_id == saas_edge_id,
                SaasChannelMaster.channel_key == channel_key
            ).first()
            
            if not installation:
                raise HTTPException(404, "Installation not found")
            
            # Encrypt sensitive credentials
            encrypted_credentials = {}
            for key, value in credentials.items():
                if any(sensitive in key.lower() for sensitive in ['password', 'secret', 'key', 'token']):
                    encrypted_credentials[key] = encrypt_credential(value)
                else:
                    encrypted_credentials[key] = value
            
            # Update installation config
            config = installation.installation_config or {}
            config.update(encrypted_credentials)
            installation.installation_config = config
            
            db.commit()
            
            return {"message": "Credentials updated successfully"}
        
        @router.get("/tenant/{saas_edge_id}/channel/{channel_key}")
        async def get_tenant_credentials(
            saas_edge_id: str,
            channel_key: str,
            db: Session = Depends(get_db)
        ):
            """Get credential fields (not values) for a tenant's channel"""
            
            # Get channel master info
            channel = db.query(SaasChannelMaster).filter(
                SaasChannelMaster.channel_key == channel_key
            ).first()
            
            if not channel:
                raise HTTPException(404, "Channel not found")
            
            # Get required credentials from capabilities
            capabilities = channel.capabilities or {}
            credential_schema = capabilities.get('credential_schema', {})
            
            return {
                "channel_key": channel_key,
                "required_credentials": credential_schema.get('properties', {}),
                "configured": True  # TODO: Check if credentials are configured
            }
        
        @router.delete("/tenant/{saas_edge_id}/channel/{channel_key}")
        async def delete_tenant_credentials(
            saas_edge_id: str,
            channel_key: str,
            db: Session = Depends(get_db)
        ):
            """Delete tenant credentials"""
            
            # Implementation to remove credentials
            # This should maintain audit trail
            pass
        
        def encrypt_credential(value: str) -> str:
            """Encrypt credential value"""
            # Implement your encryption logic here
            # Use something like Fernet or AWS KMS
            pass
        '''
    
    def generate_installation_webhook_paths(self, saas_edge_id: str, channel_key: str) -> Dict[str, str]:
        """Generate webhook paths for a tenant installation"""
        base_path = f"/webhook/{saas_edge_id.replace('-', '')[:8]}/{channel_key.lower()}"
        
        return {
            "products_import": f"{base_path}/products/import",
            "products_export": f"{base_path}/products/export", 
            "orders_import": f"{base_path}/orders/import",
            "orders_export": f"{base_path}/orders/export",
            "inventory_sync": f"{base_path}/inventory/sync",
            "customer_sync": f"{base_path}/customers/sync"
        }

def main():
    """Example usage"""
    
    db_config = {
        'host': 'your-db-host',
        'port': 5432,
        'database': 'catalog-edge-db',
        'user': 'your-user',
        'password': 'your-password'
    }
    
    credential_system = N8NCredentialExpressions(db_config)
    
    # Example: Create expressions for Shopify credentials
    expressions = {
        'api_key': credential_system.create_credential_lookup_expression(
            'tenant-123', 'SHOPIFY', 'api_key', 'fallback-key'
        ),
        'api_secret': credential_system.create_credential_lookup_expression(
            'tenant-123', 'SHOPIFY', 'api_secret'
        ),
        'shop_domain': credential_system.create_credential_lookup_expression(
            'tenant-123', 'SHOPIFY', 'shop_domain'
        )
    }
    
    print("Generated N8N Credential Expressions:")
    for field, expr in expressions.items():
        print(f"{field}: {expr}")

if __name__ == "__main__":
    main()
        '''.strip()

        return credential_system.create_installation_webhook_paths('test-tenant', 'SHOPIFY')

if __name__ == "__main__":
    main()

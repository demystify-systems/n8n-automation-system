#!/usr/bin/env python3
"""
Test script to verify n8n database connection and schema
"""

import psycopg2
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def test_db_connection():
    db_config = {
        'host': os.getenv('DB_POSTGRESDB_HOST'),
        'port': int(os.getenv('DB_POSTGRESDB_PORT', 5432)),
        'database': os.getenv('DB_POSTGRESDB_DATABASE'),
        'user': os.getenv('DB_POSTGRESDB_USER'),
        'password': os.getenv('DB_POSTGRESDB_PASSWORD')
    }
    
    print("Database configuration:")
    print(f"Host: {db_config['host']}")
    print(f"Database: {db_config['database']}")
    print(f"User: {db_config['user']}")
    print()
    
    try:
        conn = psycopg2.connect(**db_config)
        print("✅ Database connection successful!")
        
        with conn.cursor() as cursor:
            # Check if workflow_entity table exists
            cursor.execute("""
                SELECT table_name, column_name, data_type 
                FROM information_schema.columns 
                WHERE table_name IN ('workflow_entity', 'execution_entity')
                ORDER BY table_name, ordinal_position;
            """)
            
            print("\n📋 Available tables and columns:")
            current_table = None
            for row in cursor.fetchall():
                table_name, column_name, data_type = row
                if table_name != current_table:
                    print(f"\n🔸 {table_name}:")
                    current_table = table_name
                print(f"  - {column_name} ({data_type})")
            
            # Check if there's any data
            cursor.execute("SELECT COUNT(*) FROM workflow_entity;")
            workflow_count = cursor.fetchone()[0]
            print(f"\n📊 Total workflows: {workflow_count}")
            
            cursor.execute("SELECT COUNT(*) FROM execution_entity;")
            execution_count = cursor.fetchone()[0]
            print(f"📊 Total executions: {execution_count}")
            
            # Sample a few workflow records to see structure
            if workflow_count > 0:
                print("\n🔍 Sample workflow records:")
                cursor.execute("SELECT id, name, meta, settings FROM workflow_entity LIMIT 3;")
                for row in cursor.fetchall():
                    print(f"ID: {row[0]}, Name: {row[1]}")
                    if row[2]:  # meta
                        print(f"  Meta: {row[2]}")
                    if row[3]:  # settings
                        print(f"  Settings: {row[3]}")
        
        conn.close()
        print("\n✅ Schema check completed!")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        return False
    
    return True

if __name__ == "__main__":
    test_db_connection()

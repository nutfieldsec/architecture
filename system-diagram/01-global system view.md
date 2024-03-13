# Global System View

Nutfield Security delivers personalized engagement by identifying, capturing,
and helping to resolve security gaps that may not otherwise be found to help
businesses overcome barriers to security. Nutfield Security’s services allows
customers to build security programs, record progress against goals, capture
relevant notes about interventions and escalations, and track time for purposes
of billing and reimbursement.

The solution is a multi-tenant web-based application hosted in Amazon Web Services.
The solution is offered as a software only package where customers use the
application to facilitate their own patient outreach calls and/or as a
full-service solution where the Nutfield Security Team performs outreach calls on
the customer’s behalf. Nutfield Security customers and internal employees all access
the platform through secure TLS bindings and MFA on the web application.
Integrations to customer EHR systems are configured as needed for the specific
customer, but typically leverage some sort of TLS, SFTP, or VPN encapsulation
of the traffic to provide a secure channel for transmission.

The following global system view presents the holistic The solution cloud application
by Nutfield Security. This view of the system aims to describe all of the
internal and external connections of the individual components and is shown in
@fig:global-system-view.

```mermaid {#fig:global-system-view}
%%| caption: "Global System View"
%%| name: "global-system-view"
%%| alt: "Global system view"
%%{init: {"theme": "default" ,"flowchart" : { "curve" : "basis" } } }%%

flowchart LR
    web_users["Web Users"]
    admins["Admins"]
    sftp_customers["SFTP Customers"]
    cloud_systems["Cloud Systems"]
    vpn_customers["VPN Customers"]
    external_api_partners["API External Partners"]

    subgraph "External Logging Service"
        logging_service["External Logging Service"]
    end

    subgraph "AWS"
        subgraph "Production AWS Account"
            subgraph "AWS Region"
                subgraph "Regional AWS Services"
                    dns["Route53 DNS"]
                    www_cloudfront["Cloudfront\n\nhttps://app.nutfieldsecurity.com/"]
                    cloudfront_s3_backend["Cloudfront S3 Backend"]
                    cloudwatch["Cloudwatch"]
                    guardduty["GuardDuty"]
                    cloudtrail["Cloudtrail"]
                    ssm["Systems Manager"]
                    waf["WAF"]
                    cognito["Cognito"]
                    s3["S3"]
                    backup["Backup"]
                    ecr["Elastic Container Registry"]
                    secrets_manager["Secrets Manager"]
                    sqs["SQS"]
                end

                subgraph "Integration VPC"
                    prod_customer_vpn["Customer VPN Gateway"]

                    subgraph "Public Subnet"
                        integration_api["Integration API Gateway"]
                        integration_server["Integration Server"]
                    end

                    subgraph "Private Subnet"
                        integration_rds["Integration Database (RDS PostgreSQL)"]
                        integration_cache["Integration Cache (Elasticache Redis)"]
                        customer_database_ec2["Customer Specific MSSQL Database on EC2"]
                    end
                end

                subgraph "Production VPC"
                    subgraph "Public Subnet"
                        app_api["Production ALB\n\nhttps://api.nutfieldsecurity.com\nhttps://mbapp.nutfieldsecurity.com\nhttps://sso.nutfieldsecurity.com"]
                    end

                    subgraph "Private Subnet"
                        app_rds["The solution Database (RDS MySQL)"]
                        mbapp_rds["Metabase Database (RDS PostgreSQL)"]
                        sso_rds["SSO Database (RDS PostgreSQL)"]
                        warehouse["The solution Data Warehouse (Redshift)"]
                        etl["ETL"]

                        subgraph "ECS Cluster"
                            mbapp["Metabase"]
                            sso["Keycloak SSO"]
                            crud["CRUD REST API"]
                            backend_service["Backend Services"]
                        end
                    end

                    prod_admin_vpc_peer["VPC Peering Connection"]
                end
            end
        end

        subgraph "Operations AWS account"
            subgraph "Operations Regional AWS Services"
                ops_ecr["Elastic Container Registry"]
                ops_s3["S3"]
            end

            subgraph "Production VPN VPC"
                subgraph "Public Subnet"
                    prod_admin_vpn["Production Admin VPN"]
                end

                ops_admin_vpc_peer["VPC Peering Connection"]
            end
        end
    end

    admins -->|"openvpn TLS 1.2+"|prod_admin_vpn
    prod_admin_vpn -->|"AWS VPC Transmission Encryption"|ops_admin_vpc_peer
    ops_admin_vpc_peer -->|"AWS VPC Transmission Encryption"|prod_admin_vpc_peer
    web_users -->|"DNS"|dns
    web_users -->|"HTTPS TLS 1.2+"|www_cloudfront
    www_cloudfront -->|"HTTPS TLS 1.2+"|cloudfront_s3_backend
    web_users -->|"HTTPS TLS 1.2+"|app_api
    app_api -->|"AWS VPC Transmission Encryption"|mbapp
    app_api -->|"AWS VPC Transmission Encryption"|sso
    app_api -->|"AWS VPC Transmission Encryption"|crud
    app_api -->|"AWS VPC Transmission Encryption"|backend_service
    crud -->|"MySQL TLS 1.2+"|app_rds
    backend_service -->|"MySQL TLS 1.2+"|app_rds
    mbapp -->|"MySQL TLS 1.2+"|app_rds
    etl -->|"MySQL TLS 1.2+"|app_rds
    etl -->|"PostgreSQL TLS 1.2+"|warehouse
    mbapp -->|"PostgreSQL TLS 1.2+"|mbapp_rds
    sso -->|"PostgreSQL TLS 1.2+"|sso_rds

    integration_server -->|"PostgreSQL TLS 1.2+"|integration_rds
    integration_server -->|"MSSQL TLS 1.2+"|customer_database_ec2
    integration_server -->|"HTTPS TLS 1.2+"|integration_cache
    vpn_customers -->|"IPSEC VPN (IKEV2)"|prod_customer_vpn
    prod_customer_vpn -->|"HTTPS TLS 1.2+"|integration_server
    sftp_customers -->|"SFTP"|integration_server
    external_api_partners -->|"HTTPS TLS 1.2+"|integration_api
    integration_api -->|"HTTPS TLS 1.2+"|integration_server
    integration_server -->|"HTTPS TLS 1.2+"|sqs
    crud -->|"HTTPS TLS 1.2+"|sqs
    backend_service -->|"HTTPS TLS 1.2+"|sqs
    integration_server -->|"HTTPS TLS 1.2+"|cloud_systems

    cloudtrail -->|"HTTPS TLS 1.2+"|cloudwatch
    guardduty -->|"HTTPS TLS 1.2+"|cloudwatch
    cloudwatch -->|"HTTPS TLS 1.2+"|logging_service

    subgraph "Metadata"
        about["Date: February 13, 2024\nAuthor: James Orlando\nApproved By: James Orlando"]
    end
```

# AWS Application

The following diagram is a global system view of an application hosted in AWS. This view of the system aims to describe all of the internal and external connections of the individual components. Downstream threat models are expected to reference the global system view and all connections between components.

```mermaid
%%| caption: "Global System View"
%%| name: "global-system-view"
%%| alt: "Global system view"

flowchart LR
    user["Web Users"]
    admin["Administrators"]

    subgraph "Customer Systems"
        customer_system["Customer Systems"]
        customer_vpn_endpoint["Customer VPN Endpoint"]
    end

    subgraph "External Logging Service"
        logging_service["External Logging Service"]
    end

    subgraph "AWS"
        subgraph "Main AWS account"
            subgraph "Regional AWS Services"
                dns["Route53"]
                www_cloudfront["Application Static Assets via Cloudfront"]
                cloudfront_s3_backend["Application Static Assets S3 Backend"]
                cloudwatch["CloudWatch"]
                guardduty["GuardDuty"]
                cloudtrail["CloudTrail"]
                ssm["SSM"]
                backup["Backup"]
                secrets_manager["Secrets Manager"]
            end

            subgraph "VPC"
                vpc_peer["VPC Peer"]
                customer_vpn_gateway["Customer VPN Gateway"]

                subgraph "Admin VPN Subnet"
                    admin_vpn["Admin VPN"]
                end

                subgraph "Public Subnet"
                    alb["Application Load Balancer"]
                end

                subgraph "Private Subnet"
                    rds["MySQL Database"]
                    web["Web Node"]
                    cluster_master["Cluster Master Node"]
                    cluster_workers["Cluster Worker Nodes"]
                    nfs["NFS"]

                    subgraph "ECS Cluster"
                        mbapp["Metabase"]
                    end
                end
            end
        end

        subgraph "Operations AWS account"
            subgraph "Operations Regional AWS Services"
                ecr["ECR"]
                ses["SES"]
            end

            subgraph "Shared Services VPC"
                subgraph "Private Subnet"
                    shared_vpc_peer["Shared VPC Peer"]
                end
            end
        end
    end

    admin -->|"openvpn TLS 1.2+"|admin_vpn
    user <-->|"DNS"|dns
    user <-->|"HTTPS TLS 1.2+"|www_cloudfront
    www_cloudfront <-->|"HTTPS TLS 1.2+"|cloudfront_s3_backend
    user <-->|"HTTPS & WSS TLS 1.2+"|alb
    alb <-->|"HTTPS TLS 1.2+"|web
    web <-->|"MySQL TLS 1.2+"|rds
    web <-->|"HTTPS TLS 1.2+"|cluster_master
    cluster_master <-->|"HTTPS TLS 1.2+"|cluster_workers
    cluster_workers <-->|"MySQL TLS 1.2+"|rds
    alb <-->|"HTTPS TLS 1.2+"|mbapp
    mbapp <-->|"MySQL TLS 1.2+"|rds
    web <-->|"HTTPS TLS 1.2+ through IPSEC VPN"|customer_vpn_gateway
    customer_vpn_gateway <-->|"IPSEC"|customer_vpn_endpoint
    customer_vpn_endpoint <-->|"HTTPS TLS 1.2+ through IPSEC VPN"|customer_system
    shared_vpc_peer <-->|"IPSEC VPN"|vpc_peer
    web <-->|"HTTPS TLS 1.2+"|vpc_peer
    cloudtrail -->|"HTTPS TLS 1.2+"|cloudwatch
    guardduty -->|"HTTPS TLS 1.2+"|cloudwatch
    cloudwatch -->|"HTTPS TLS 1.2+"|logging_service
    web <-->|"HTTPS TLS 1.2+"|nfs
    cluster_workers <-->|"HTTPS TLS 1.2+"|nfs
    cluster_master <-->|"HTTPS TLS 1.2+"|nfs
```

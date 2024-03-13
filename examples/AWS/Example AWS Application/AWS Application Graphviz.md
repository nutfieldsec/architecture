# Global System View

The following global system view presents the holistic Nutfield Security application. This view of the system aims to describe all of the internal and external connections of the individual components and is shown in @fig:global-system-view. Subsequent views are informed by this global system view and are intended to provide more detail of the specific process under inspection. Downstream threat models are also expected to reference the global system view and all connections between components.

The primary data exchanged between the Nutfield Security and partner institutions are PNG images. PNG images are preferably transfered between Nutfield Security and an institution through the PNG Hub Cloud. Nutfield Security maintains a local PNG Hub Gateway that uses strong authentication and HTTPS and TLS 1.2 to securely connect to the PNG Hub Cloud. In addition to providing secure PNG transfer, use of the PNG Hub Cloud adds a layer of reliability and high availability to the PNG transfer process by allowing the institution to send the file when requesting an analysis and Nutfield Security to pull the file when ready to process and vice versa. In the event an institution cannot work with PNG Hub Cloud, Nutfield Security maintains a PNG protocol compliant endpoint and plans to leverage AWS Site to Site VPN tunnels using IPSEC to facilitate secure communications with the Customer's own PACS system.

The primary roles of the application users are Web Users, Quality Control Managers, Physicians, Institutional Admins, and Nutfield Security Administrators. Web Users are users who process and analyze the PNG images. Quality Control Managers review the cases worked on by Web Users. Physicians are the physician ordering an analysis. Institutional Admins are responsible for managing the access control and other tenant administration responsibilities for the institution tenant. Lastly, Nutfield Security Administrators are responsible for the operational health and performance of the Nutfield Security application.

External users such as Physicians and Institution Admins have limited access to only their tenant data in the application. Web Users and Quality Control Managers may be assigned multiple institutions to perform analysis for. Nutfield Security administrators have system level access and may confer additional rights onto other users. Access to the Admin VPN is restricted to Nutfield Security Infrastructure Administrators and requires MFA to connect.

```{.dot #fig:global-system-view}
//| caption: "Global System View"
//| name: "global-system-view"
//| alt: "Global system view"

digraph GlobalSystemView {
  graph [compound=true]
  edge [dir=both]
  rankdir = "LR"

  user [label="Web Users"]
  admin [label="Nutfield Security Administrators"]

  png_hub_cloud [label="PNG Hub Cloud"]

  logging_service [label="External Logging Service"]

  subgraph cluster_all_aws {
    label="AWS"
    margin=8

    subgraph cluster_main_aws {
      label="Main AWS account"
      margin=8

      subgraph cluster_regional_services {
        label="Regional AWS Services"

        dns [shape=none,label="\n\nNutfield Security.com DNS",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Networking-Content-Delivery/16/Arch_Amazon-Route-53_16.png",imagepos="tc",labelloc="b"]
        www_cloudfront [shape=none,label="\n\nApplication static assets",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Networking-Content-Delivery/16/Arch_Amazon-CloudFront_16.png",imagepos="tc",labelloc="b"]
        cloudfront_s3_backend [shape=none,label="\nApplication static assets s3 backend",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Storage/16/Arch_Amazon-Simple-Storage-Service_16.png",imagepos="tc",labelloc="b"]
        cloudwatch [shape=none,label="\nCloudwatch",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Management-Governance/16/Arch_Amazon-CloudWatch_16.png",imagepos="tc",labelloc="b"]
        guardduty [shape=none,label="\n\nGuardDuty",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Security-Identity-Compliance/16/Arch_Amazon-GuardDuty_16.png",imagepos="tc",labelloc="b"]
        cloudtrail [shape=none,label="\n\nCloudtrail",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Management-Governance/16/Arch_AWS-CloudTrail_16.png",imagepos="tc",labelloc="b"]
        ssm [shape=none,label="\n\nSSM",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Management-Governance/16/Arch_AWS-Systems-Manager_16.png",imagepos="tc",labelloc="b"]
        backup [shape=none,label="\n\nBackup",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Storage/16/Arch_AWS-Backup_16.png",imagepos="tc",labelloc="b"]
        secrets_manager [shape=none,label="\n\nSecrets Manager",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Security-Identity-Compliance/16/Arch_AWS-Secrets-Manager_16.png",imagepos="tc",labelloc="b"]
      }

      subgraph cluster_vpc {
        label="VPC"
        margin=8

        subgraph cluster_admin_vpn {
          label="Admin VPN Subnet"
          margin=8

          admin_vpn [shape=none,label="\n\nVPC Client VPN",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Networking-Content-Delivery/16/Arch_AWS-Client-VPN_16.png",imagepos="tc",labelloc="b"]
        }

        subgraph cluster_public_subnet {
          label="Public Subnet"
          margin=8

          api [shape=none,label="\n\napp-api.Nutfield Security.com ALB",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Networking-Content-Delivery/16/Arch_Elastic-Load-Balancing_16.png",imagepos="tc",labelloc="b"]
          png_hub_cloud_gateway [shape=none,label="\n\nPNG Hub Gateway",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Compute/16/Arch_Amazon-EC2_16.png",imagepos="tc",labelloc="b"]
        }

        subgraph cluster_private_subnet {
          label="Private Subnet"
          margin=8

          app_rds [shape=none,label="\n\nMySQL 8 RDS",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Database/16/Arch_Amazon-RDS_16.png",imagepos="tc",labelloc="b"]
          app_web [shape=none,label="\n\nWeb Node",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Compute/16/Arch_Amazon-EC2_16.png",imagepos="tc",labelloc="b"]
          app_controller [shape=none,label="\nController Node",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Compute/16/Arch_Amazon-EC2_16.png",imagepos="tc",labelloc="b"]
          app_worker [shape=none,label="\n\nWorker Node",image="resources/icons/aws/Architecture-Group-Icons_10232023/Auto-Scaling-group_32.png",imagepos="tc",labelloc="b"]
          app_efs [shape=none,label="\n\nNFS Volume\n\nEncrypted at rest with AES-256",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Storage/16/Arch_Amazon-EFS_16.png",imagepos="tc",labelloc="b"]

          subgraph cluster_ecs {
            label="ECS Cluster"
            margin=8

            mbapp [shape=none,label="\n\nMetabase",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Containers/16/Arch_Amazon-Elastic-Container-Service_16.png",imagepos="tc",labelloc="b"]
            sftpgo [shape=none,label="\n\n\n\nSFTPgo",image="resources/icons/other/SFTPgo-logo.png",imagepos="tc",labelloc="b"]
          }
        }
      }
    }

    subgraph cluster_shared_services_aws {
      rankdir = "TB"
      label="Operations AWS account"
      margin=8

      subgraph cluster_operations_regional_services {
        label="Operations Regional AWS Services"
        ecr [shape=none,label="\n\nECR",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Containers/16/Arch_Amazon-Elastic-Container-Registry_16.png",imagepos="tc",labelloc="b"]
        ses [shape=none,label="\n\nSES",image="resources/icons/aws/Architecture-Service-Icons_10232023/Arch_Business-Applications/16/Arch_Amazon-Simple-Email-Service_16.png",imagepos="tc",labelloc="b"]
      }
    }
  }

  // Admin vpn traffic
  admin -> admin_vpn [label="openvpn TLS 1.2+"]

  // User workflows
  user -> dns [label="DNS"]

  user -> www_cloudfront [label="HTTPS TLS 1.2+"]
  www_cloudfront -> cloudfront_s3_backend [label="HTTPS TLS 1.2+"]

  user -> api [label="HTTPS & WSS TLS 1.2+"]
  api -> app_web [label="HTTPS TLS 1.2+"]
  app_web -> app_rds [label="MySQL TLS 1.2+"]
  app_web -> app_controller [label="AWS VPC Transmission Encryption"]
  app_controller -> app_worker [label="AWS VPC Transmission Encryption"]
  app_worker -> app_rds [label="MySQL TLS 1.2+"]

  // Metabase
  api -> mbapp [label="HTTPS TLS 1.2+"]
  mbapp -> app_rds [label="MySQL TLS 1.2+"]

  // SFTPgo
  api -> sftpgo [label="\n\nHTTPS TLS 1.2+"]
  sftpgo -> app_efs [label="HTTPS TLS 1.2+"]

  // PNG Hub Cloud
  png_hub_cloud_gateway -> app_web [label="HTTPS TLS 1.2+"]
  png_hub_cloud_gateway -> png_hub_cloud [label="\n\n\nHTTPS TLS 1.2+"]

  // Logging
  cloudtrail -> cloudwatch [dir=forward, label="HTTPS TLS 1.2+"]
  guardduty -> cloudwatch [dir=forward, label="HTTPS TLS 1.2+"]
  cloudwatch -> logging_service [label="\n\n\n\nHTTPS TLS 1.2+"]

  // NFS
  app_web -> app_efs [label="HTTPS TLS 1.2+"]
  app_worker -> app_efs [label="HTTPS TLS 1.2+"]
  app_controller -> app_efs [label="HTTPS TLS 1.2+"]

  // Invisible constraints for style
  // see https://stackoverflow.com/a/7029368
  sftpgo -> app_worker [style=invis]
  // dns -> backup [style=invis]
  // cloudtrail -> secrets_manager [style=invis]
  // ecr -> shared_vpc_peer [style=invis]
  // admin_vpn -> ecr [style=invis]
}
```

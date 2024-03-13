# AWS VPN Peering

In order to provide channels for secure administration of backend AWS services,
Nutfield Security maintains instances of the OPNSense open source firewall which run an
OpenVPN service allowing a secure connection into AWS. Each AWS VPC containing
a VPN connection is then peered to other AWS VPCs as desired. The current
VPN and VPC Peering configurations are shown in @fig:aws-vpn-peering-view.

Access to Nutfield Security VPNs require multiple forms of authentication. To connect to
the service, a user needs to have a valid configuration file with an embedded
client side certificate. Once connected to the service, the user also needs to
provide valid okta credentials in the form of firstname.lastname@nutfieldsecurity.com
when prompted for password authorization. The two factors then are something
you have (client side cert) and something you know (okta credentials).

```mermaid {#fig:aws-vpn-peering-view}
%%| caption: "AWS VPN Peering View"
%%| name: "aws-vpn-peering-view"
%%| alt: "AWS VPN Peering View"
%%{init: {"theme": "default" ,"flowchart" : { "curve" : "basis" } } }%%

flowchart LR
    admins["Admins"]
    developers["Developers"]
    service_team_members["Service Team Members"]

    subgraph "AWS"
        subgraph "Operations AWS Account"
            subgraph "AWS Region"
                subgraph "Prod VPN VPC"
                    prod_vpn_vpc_peer["Prod VPN VPC Peer (10.60.0.0/16)"]
                    subgraph "Public Subnet"
                        subgraph "Prod VPN (prod.vpn.ops.nutfieldsecurity.com)"
                            prod_vpn["prod-vpn (10.60.8.0/24)"]
                            care_navigation_vpn["service-member-vpn (10.60.100.0/22)"]
                        end
                    end
                end

                subgraph "Non-Prod VPN VPC"
                    non_prod_vpn_vpc_peer["Non-Prod VPN VPC Peer (10.50.0.0/16)"]
                    subgraph "Public Subnet"
                        subgraph "Non-Prod VPN (non-prod.vpn.ops.nutfieldsecurity.com)"
                            non_prod_vpn["non-prod-vpn (10.50.8.0/24)"]
                        end
                    end
                end
            end
        end
        subgraph "Production AWS Account"
            subgraph "AWS Region"
                subgraph "Production VPC"
                    prod_vpc_peer["Production VPC Peer (10.252.0.0/20)"]
                end

                subgraph "Integration VPC"
                    integration_vpc_peer["Integration VPC Peer (172.31.0.0/16)"]
                end
            end
        end
        subgraph "Development AWS Account"
            subgraph "AWS Region"
                subgraph "Development VPC"
                    dev_vpc_peer["Development VPC Peer (172.31.0.0/16)"]
                end
            end
        end
    end

    subgraph "Various Customer Networks"
        customer_vpn_endpoint["Customer VPN Endpoint"]
    end

    admins -->|"openvpn TLS 1.2+"|prod_vpn
    prod_vpn -->|"AWS VPC Transmission Encryption"|prod_vpn_vpc_peer
    prod_vpn_vpc_peer -->|"AWS VPC Transmission Encryption"|prod_vpc_peer
    prod_vpn_vpc_peer -->|"AWS VPC Transmission Encryption"|integration_vpc_peer

    service_team_members -->|"openvpn TLS 1.2+"|care_navigation_vpn
    care_navigation_vpn -->|"IPSEC (IKEV2)"|customer_vpn_endpoint

    developers -->|"openvpn TLS 1.2+"|non_prod_vpn
    non_prod_vpn -->|"AWS VPC Transmission Encryption"|non_prod_vpn_vpc_peer
    non_prod_vpn_vpc_peer -->|"AWS VPC Transmission Encryption"|dev_vpc_peer

    subgraph "Metadata"
        about["Date: February 13, 2024\nAuthor: James Orlando\nApproved By: James Orlando"]
    end
```

# OpenTofu MikroTik Configuration

This repository contains the [OpenTofu](https://opentofu.org/) code I've developed to configure my [MikroTik router](https://mikrotik.com/). The purpose of this repository is to provide a structured and repeatable way to manage and automate the setup of MikroTik routers using [Infrastructure as Code (IaC)](https://en.m.wikipedia.org/wiki/Infrastructure_as_code) principles.

My initial idea was to use this project as a backup, start with a new router and run `tofu apply`, the router would magically be ready with everything I needed. But in the end I realised that this was not feasible due to the complexity of the configuration, which required intermediate steps in OpenTofu and could not be applied in one step.

## Why OpenTofu

I decided to configure my MikroTik router with [OpenTofu](https://opentofu.org/) for several reasons:

1. **Love for Automation**: as a DevOps guy, automation is at the heart of what I do. By automating the configuration of my router, I can ensure consistency, reduce manual errors and save time on repetitive tasks.

1. **Infrastructure as Code (IaC)**: I believe in the principles of [Infrastructure as Code](https://en.m.wikipedia.org/wiki/Infrastructure_as_code). Managing my network infrastructure through code allows for better version control and repeatability.

1. **Skill Improvement**: working on this project is also a great way for me to improve my [OpenTofu](https://opentofu.org/) skills. It provides a practical, hands-on opportunity to explore advanced features.

1. **Configuration Tracking**: I can easily track changes to my router's configuration. In addition to reading changelogs, I can discover every single setting that is altered after an upgrade process, ensuring that I maintain full control and visibility over my router settings.

1. ~~**Backup**: provides a creative alternative to traditional backup methods for my router. By storing my router's configuration as code, I can quickly and reliably restore my settings if needed, leveraging the benefits of version control and automation.~~

## Getting Started

To get started with this repository, you'll need to have the following tools installed:

### Requirements

1. **OpenTofu**: Ensure you have OpenTofu installed. You can download it from the [official OpenTofu website](https://opentofu.org).

2. **Vault**: You'll need HashiCorp Vault for managing secrets. Install it from the [official Vault website](https://www.vaultproject.io/downloads).

3. **terraform-routeros**: This is the OpenTofu provider for MikroTik. You can find it on the [Terraform Registry](https://registry.terraform.io/providers/terraform-routeros/routeros/latest).

### Default Settings

Restore the Router to the default settings but keep the **Default Cofiguration**.

### Default Admin

MikroTik uses **Admin** as a default admin user, is a good security practice to change replace it with something not easy to predict. Currently those steps are performed manually:

1. Login to the router
1. Create a new user in the **full** group:

    ```sh
    /user add name=<username> group=full
    ```

1. Logout and login with the new user
1. Detele the default **admin** user:

    ```sh
    /user remove admin
    ```

### Vault Integration

I use [HashiCorp Vault](https://www.hashicorp.com/en/products/vault) to securely store sensitive information such as the password to connect to the MikroTik API and the passwords for my WiFi networks. This ensures that the credentials are not hardcoded into the OpenTofu files, reducing the risk of accidental exposure.

I have built my own [OpenTofu-modules](https://github.com/Schwitzd/terraform-modules) collection to streamline the deployment of a dedicated vault to store my router's secrets.

I structure the Vault different sections:

1. **mikrotik**: username and password of the router
1. **wifi**: my WiFi passwords, where the SSID is the key and the password is the value
1. **container_lego_envs**: environment variables for [LEGO container](https://github.com/Schwitzd/docker-routeros-letsencrypt)
1. **container_ddns_envs**: environment variables for [Cloudfrare DDNS container](https://github.com/favonia/cloudflare-ddns)

### OpenTofu Environment

1. Clone the repository:

    ```sh
    git clone https://github.com/Schwitzd/IaC-HomeRouter.git
    cd IaC-HomeRouter
    ```

1. Create files excluded by `.gitignore`

    ```sh
    touch _fw_addr_lists.yaml
    touch _fw_roles_v6.yaml
    touch _fw_roles.yaml
    touch _static_hosts.yaml
    touch _wireguard.yaml
    ```

1. Initialize OpenTofu in your project directory:

    ```sh
    tofu init
    ```

1. Create the Vault space:

    ```sh
      cd iac_vault
      tofu init
      tofu apply --var-file=variables.tfvars
    ```

1. The configuration became too complex and interconnected. I never tried to apply everything from a clean RouterOS installation, but the command would be:

    ```sh
      tofu apply --var-file=variables.tfvars --var-file=variables_private.tfvars
    ```

#### Variables

I created the variable file `variables_private.tfvars` because there are variables that I don't want to publicly expose. This file is excluded from this repository.

## Network Topology

My home network is divided into four VLANs:

1. **VLAN 100: Home** - For all general household devices.
1. **VLAN 200: IoT** - Dedicated to [Internet of Things](https://en.wikipedia.org/wiki/Internet_of_things) devices like TV and smart plugs.
1. **VLAN 300: Server** - For home servers.
1. **VLAN N/A: VPN**: - Dedicated to VPN.

### Static Hosts

I have a file called `_static_hosts.yaml` which contains all my static DNS records and DHCP leases. This file contains a local variable with a list of hostnames, IP addresses, DNS types and mac addresses. Here is an example of what it looks like:

```yaml
static_hosts:
  - hostname: "device1.home"
    ip: "192.168.1.10"
    type: "A"
  - hostname: "device2.home"
    ip: "192.168.1.11"
    type: "A"
    mac: "01:2A:4B:CC:1E:2A"
```

The `_static_hosts.yaml` file is excluded in the `.gitignore` to avoid exposing too much of my network (refer to the Risks section). This is the reason why is manually created after cloning the repository.

### WiFi

I have two WiFi networks set up:

1. **Home WiFi**: Dedicated to the Home VLAN, operating at 5GHz.
2. **IoT WiFi**: Dedicated to the IoT VLAN, operating at 2.4GHz.

The decision to use different frequencies is based on the typical use cases and requirements of the devices connecting to these networks. The 5GHz frequency for the Home WiFi provides higher data rates and less interference, which is ideal for devices that require more bandwidth, such as smartphones, laptops, and streaming devices. On the other hand, the 2.4GHz frequency for the IoT WiFi offers better range and penetration through walls, which is suitable for IoT devices that may be spread throughout the house and do not need high data rates. Additionally, most IoT devices nowadays only offer a 2.4GHz frequency, making this choice essential for compatibility.

A small curiosity you will discover by reading the code is that the SSIDs are suffixed with `_optout_nomap`. You can understand why by reading about this decision [here](https://infosec.exchange/@Schwitzd/112519726734631681).

## Containers

I have enabled the container feature to take advantage of the ability to run containers inside my router, I will only run network/router related containers and not other types of home containers. As stated in the official RouterOS documentation this brings security risks, I suggest you to read the red made [disclaimer](https://help.mikrotik.com/docs/display/ROS/Container#Container-Disclaimer) and understand really carefully what you are doing.

MikroTik has implemented a security mechanism that prevents the container feature from being enabled remotely or with automation, requiring you to press a physical button to acknowledge, so run this command on the terminal and restart the router:

```sh
system/device-mode/update mode=enterprise container=yes
```

The `container` package will be installed with OpenTofu, but an additional manual reboot is needed.

### Images

The Mikrotik container feature has no way of keeping images up to date, so I wrote my own script [mikrotik-updatecontainerimage](https://gist.github.com/Schwitzd/517b5ba2add1bcad9528dd5f37e0fdaf#file-mikrotik-updatecontainerimage) and scheduled it to run once a week. What it does:

1. Read container patameters
1. Stop and delete existing container
1. Create a new container with the same parameters
1. Restart the container

Useless to tell you why it is important to keep images up to date!

## Security

As you may have guessed, I've decided to split my home network into different virtual LANs, primarily for security reasons, so that I can isolate devices I don't trust or can't protect as I'd like from devices I believe to be more trustworthy.

### HTTPS admin page

To enable the router interface in HTTPS, you can follow the video on the Mikrotik [official documentation](https://help.mikrotik.com/docs/display/ROS/Certificates#Certificates-Let'sEncryptcertificates). But be aware that the router's management interface is exposed to the Internet (even if it's only accessible from Let's Encrypt IPs).

To avoid this, I took advantage of the domain I use for my [website](https://schwitzd.me) and leveraged the container functionality:

1. Create a static DNS entry on RouterOS to `router.domain.tld`
1. Enable the container feature
1. Use [routeros-letsencrypt-docker](https://github.com/Schwitzd/routeros-letsencrypt-docker) to obtain a Let's Encrypt certificate using [DNS challenge](https://letsencrypt.org/docs/challenge-types/).

For a reason I have not yet understood Alpine Linux is not able to resolve `router.domain.tld` even having set the router as DNS resolver. So in the `ROUTEROS_HOST` environment variable I used the IP.

### Firewall

I'm using the built-in MikroTik firewall to protect each VLAN, ensuring that only authorized traffic flows through the network. By default, the firewall is configured with a rule that blocks all traffic between VLANs, creating an isolated environment for each VLAN. This setup ensures that no cross-VLAN communication occurs unless explicitly permitted by additional rules.

To manage traffic more efficiently, I'm leveraging the **Address Lists** feature in MikroTik. This allows me to dynamically add IP addresses to my firewall rules, making the rules more flexible and easier to manage. For example, I maintain a YAML file named `_fw_addr_lists.yaml` that contains all the IP addresses needed to build the rules. This file allows me to organize and update my firewall rules without modifying the main configuration directly. Here's an example of how this file is structured:

```yaml
fw_addr_lists:
  - list: "example-list"
    address: "192.168.88.1"
```

In addition to address lists, I manage all my firewall rules in another YAML file, `_fw_rules.yaml` & `_fw_rules_v6.yaml`. This file contains the definitions for all the rules applied to the firewall, specifying which traffic is allowed or denied across the network. By keeping these rules in a YAML file, I can easily adjust the firewall settings in a centralized manner, ensuring consistency and simplicity in my network configuration.

Here's an example of how a rule might look in the `_fw_rules.yaml` file:

```yaml
  role14:
    action: "drop"
    chain: "forward"
    comment: "Block all traffics between VLANs"
    in_interface_list: "VLANs"
    out_interface_list: "VLANs"
```

### VPN

Regarding the VPN, the situation is currently under investigation because, at the time of writing, my ISP is only offering IPv4 behind [CGNAT](https://en.wikipedia.org/wiki/Carrier-grade_NAT) for mobile devices. My router connects to the internet via LTE. Sadly, IPv6 is only available for residential [xDSL](https://en.wikipedia.org/wiki/Digital_subscriber_line#DSL_technologies)/[FTTH](https://en.wikipedia.org/wiki/Fiber_to_the_x)

I'm bypassing [CGNAT](https://en.wikipedia.org/wiki/Carrier-grade_NAT) with the help of [Route64](https://route64.org) that is offering a free [tunnel broker](https://en.wikipedia.org/wiki/Tunnel_broker) service.

- My MikroTik router establishes a [WireGuard](https://www.wireguard.com/) tunnel to the nearest [Route64](https://route64.org) [PoP](https://en.wikipedia.org/wiki/Point_of_presence).  
- Through this tunnel, the router is assigned a [Global Unicast IPv6 address (GUA)](https://ipcisco.com/lesson/ipv6-global-unicast-address/).  
- This public [IPv6 address](https://en.wikipedia.org/wiki/IPv6_address) is fully routable on the Internet, allowing my client devices to access my home cluster from abroad.  

```mermaid
graph LR
    LAN[Home<br/>Cluster] --> Mikrotik["<b>MikroTik<br/>Router</b>"]

    subgraph Route64Box["Get IPv6 from <b>Route64<b>"]
        direction LR
        WGup["<b>WireGuard tunnel</b><br/>to Route64"]
        Route64["Route64<br/>PoP"]
        WGup --- Route64
    end

    Mikrotik --- WGup

    Client["<b>VPN</b><br/>WireGuard client"] --> Tunnel2["<b>VPN (IPv6)</b><br />Home Remote Access"] --- Mikrotik
  ```

As I said at the beginning, this configuration is still a work in progress, and I'm evaluating different scenarios. The major limitation is that the home VPN tunnel is only accessible via [IPv6](https://en.wikipedia.org/wiki/IPv6_address), but my mobile carrier (it seems none in Switzerland) does not provide [IPv6](https://en.wikipedia.org/wiki/IPv6_address) on the [cellular network](https://en.m.wikipedia.org/wiki/Cellular_network). This means that I cannot access my home cluster from my mobile phone. I'm stuck in a chicken-egg loop because, as soon as the ISP/carrier provides [IPv6](https://en.wikipedia.org/wiki/IPv6_address) on [cellular network](https://en.m.wikipedia.org/wiki/Cellular_network), I won't need [Route64](https://route64.org) anymore.

### Backup

I will set up automated, weekly backups using [docker-routeros-backup](https://github.com/Schwitzd/docker-routeros-backup), a container image I've developed. This process is orchestrated using [Kubernetes CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) for scheduled execution. The container performs the following tasks:

1. Connects to the MikroTik router via SSH  
2. Executes an encrypted backup and saves it on the router as a binary file  
3. Retrieves the backup file from the router using SCP  
4. Uploads the backup to my local [Garage](https://garagehq.deuxfleurs.fr/) instance, which is S3-compatible  

Additionally, I will implement backup retention by keeping only the five most recent backup files.

## Risks

By publishing this repository, I'm accepting the risk of exposing my home network topology. While I've taken steps to ensure sensitive information is managed securely, sharing this code inherently comes with certain risks, such as potential exposure to network vulnerabilities.

## Why Share?

I decided to share this repository because I believe that sharing knowledge is incredibly important. By open-sourcing my configuration, I hope to help others in the community who want to use OpenTofu to automate their MikroTik router setup and apply good security practices to their home network. Collaborating and learning from each other is a key aspect of the tech community.

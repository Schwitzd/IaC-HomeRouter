# Terraform MikroTik Configuration

This repository contains the Terraform code I've developed to configure my MikroTik router. The purpose of this repository is to provide a structured and repeatable way to manage and automate the setup of MikroTik routers using Infrastructure as Code (IaC) principles.

## Why Terraform

I decided to configure my MikroTik router with Terraform for several reasons:

1. **Love for Automation**: As a DevOps guy, automation is at the heart of what I do. By automating the configuration of my router, I can ensure consistency, reduce manual errors and save time on repetitive tasks.

2. **Infrastructure as Code (IaC)**: I believe in the principles of Infrastructure as Code. Managing my network infrastructure through code allows for better version control and repeatability.

3. **Skill Improvement**: Working on this project is also a great way for me to improve my Terraform skills. It provides a practical, hands-on opportunity to explore advanced features.

4. **Configuration Tracking**: With Terraform, I can easily track changes to my router's configuration. In addition to reading changelogs, I can discover every single setting that is altered after an upgrade process, ensuring that I maintain full control and visibility over my router settings.

5. **Backup**: Using Terraform provides a creative alternative to traditional backup methods for my router. By storing my router's configuration as code, I can quickly and reliably restore my settings if needed, leveraging the benefits of version control and automation.

## Getting Started

To get started with this repository, you'll need to have the following tools installed:

### Requirements

1. **Terraform**: Ensure you have Terraform installed. You can download it from the [official Terraform website](https://www.terraform.io/downloads.html).

2. **Vault**: You'll need HashiCorp Vault for managing secrets. Install it from the [official Vault website](https://www.vaultproject.io/downloads).

3. **terraform-routeros**: This is the Terraform provider for MikroTik. You can find it on the [Terraform Registry](https://registry.terraform.io/providers/terraform-routeros/routeros/).

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

I use Vault to securely store sensitive information such as the password to connect to the MikroTik API and the passwords for my WiFi networks. This ensures that the credentials are not hardcoded into the Terraform files, reducing the risk of accidental exposure.

I have built my own [terraform-modules](https://github.com/Schwitzd/terraform-modules) collection to streamline the deployment of a dedicated vault to store my router's secrets.

I structure the Vault in two sections:

1. **mikrotik**: username and password of the router
1. **wifi**: my WiFi passwords, where the SSID is the key and the password is the value

### Installation

1. Clone the repository:

    ```sh
    git clone https://github.com/Schwitzd/IaC-HomeRouter.git
    cd IaC-HomeRouter
    ```

1. Initialize Terraform in your project directory:

    ```sh
    terraform init
    ```

1. Create the file `dns_records.yaml`:

    ```sh
    touch dns_records.yaml
    ```

1. Create the Vault space:

    ```sh
      cd iac_vault
      terraform init
      terraform apply -var-file=variables.tfvars
      ```

## Network Topology

My home network is divided into four VLANs:

1. **VLAN 100: Home** - For all general household devices.
2. **VLAN 200: IoT** - Dedicated to Internet of Things devices like TV and smart plugs.
3. **VLAN 300: Server** - For home servers.
4. **VLAN 400: Lab** - Used inside my lab for experiment technologies.

### DNS

I have a file named `dns_records.yaml` where all my static DNS entries are stored. This file contains a local variable with a list of hostnames, IP addresses, and DNS types. Here is an example of what it looks like:

```yaml
dns_records:
  - hostname: "device1.home"
    ip: "192.168.1.10"
    type: "A"
  - hostname: "device2.home"
    ip: "192.168.1.11"
    type: "A" 
```

The `dns_records.yaml` file is excluded in the .gitignore to avoid exposing too much of my network (refer to the Risks section).
This is the reason why is manually created after cloning the repository.

### WiFi

I have two WiFi networks set up:

1. **Home WiFi**: Dedicated to the Home VLAN, operating at 5GHz.
2. **IoT WiFi**: Dedicated to the IoT VLAN, operating at 2.4GHz.

The decision to use different frequencies is based on the typical use cases and requirements of the devices connecting to these networks. The 5GHz frequency for the Home WiFi provides higher data rates and less interference, which is ideal for devices that require more bandwidth, such as smartphones, laptops, and streaming devices. On the other hand, the 2.4GHz frequency for the IoT WiFi offers better range and penetration through walls, which is suitable for IoT devices that may be spread throughout the house and do not need high data rates. Additionally, most IoT devices nowadays only offer a 2.4GHz frequency, making this choice essential for compatibility.

A small curiosity you will discover by reading the code is that the SSIDs are suffixed with `_optout_nomap`. You can understand why by reading about this decision [here](https://infosec.exchange/@Schwitzd/112519726734631681).

## Containers

I have enabled the container feature to take advantage of the ability to run containers inside my router, I will only run network/router related containers and not other types of home containers. As stated in the official RouterOS documentation this brings security risks, I suggest you to read the red made [disclaimer](https://help.mikrotik.com/docs/display/ROS/Container#Container-Disclaimer) and understand really carefully what you are doing.

At the time of writing, I haven't found a Terraform resource to enable the container feature, as a manual interraction is also required to enable it, so run this command on the terminal and restart the router:

```sh
system/device-mode/update mode=home container=yes
```

The `container` package will be installed with Terraform, but an additional manual reboot is needed.

## Security

As you may have guessed, I've decided to split my home network into different virtual LANs, primarily for security reasons, so that I can isolate devices I don't trust or can't protect as I'd like from devices I believe to be more trustworthy.

### Firewall

I'm leveraging the built-in MikroTik firewall to protect each VLAN. By default, there is a rule that blocks all traffic between VLANs. Only explicitly allowed traffic is permitted to pass through the firewall.

## Risks

By publishing this repository, I'm accepting the risk of exposing my home network topology. While I've taken steps to ensure sensitive information is managed securely, sharing this code inherently comes with certain risks, such as potential exposure to network vulnerabilities.

## Why Share?

I decided to share this repository because I believe that sharing knowledge is incredibly important. By open-sourcing my configuration, I hope to help others in the community who want to use Terraform to automate their MikroTik router setup and apply good security practices to their home network. Collaborating and learning from each other is a key aspect of the tech community.

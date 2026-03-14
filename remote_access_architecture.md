
---

# Rustin Systems: Automated Virtual Desktop Infrastructure (VDI)

**Project:** CPUT Engineering Remote Lab Deployment

**Author:** Shahied Rustin
**Date:** 01/02/2026

## 1. System Architecture Overview

This repository contains the Infrastructure-as-Code (IaC) required to provision a bare-metal Ubuntu server into a multi-user Virtual Desktop Infrastructure (VDI). The system is designed to allow concurrent engineering students to run a fully functional and controlled Linux workstation environment. Readily optimised for heavy virtualization workloads such as VirtualBox and KVM remotely via lightweight client machines.

**Key Engineering Features:**

* **Automated Provisioning:** Idempotent Ansible playbook (`setup_node.yml`) configures the host from a baseline Ubuntu Server install to a fully optimized XFCE desktop environment in under 10 minutes.
* **Kernel Management:** Automatically purges incompatible bleeding-edge kernels and locks the GRUB bootloader to the stable 6.8 baseline to ensure hypervisor compatibility.
* **Default Student Image Cloning:** Uses Linux skeleton directories (`/etc/skel`) to automatically generate standardized, restricted desktop environments (pre-pinned apps, shared directories, custom wallpaper) upon user creation.
* **Security Hardening:** Implements UFW (Uncomplicated Firewall) locked to ports 22 and 3389, backed by Fail2ban to automatically block SSH brute-force attempts.

---

## 2. Local Testing & Deployment Guide

**Prerequisites:**

1. A physical machine or VM running a fresh installation of Ubuntu Server 24.04.
2. An active internet connection on the server.
3. An Admin account created during OS installation (e.g., `server1`) with OpenSSH installed.

**Step-by-Step Deployment:**

1. Boot the server on your local test network (or portable router) and find its IP address by running `ip a`.
2. On your control machine (your laptop), open the `hosts.ini` file.
3. Update the IP address and admin username to match your test server:
```ini
[lab_servers]
node1 ansible_host=192.168.X.X ansible_user=your_admin_username

```


4. Run the Ansible playbook:
```bash
ansible-playbook -i hosts.ini setup_node.yml -K

```


*(The `-K` flag will prompt you for the server's sudo password).*
5. Once Ansible finishes, reboot the server. The VDI is now ready for users.

---

## 3. Daily Operations: Lab User Management

Once the server is deployed, faculty can manage student access using the custom CLI tool, which automates user creation, virtualization permissions, and directory linking.

To launch the tool, log into the server and run:

```bash
sudo manage_lab_users

```

**Menu Options:**

* **1. Add a new student:** Prompts for a username (e.g., `student1`). It creates the account, assigns them strictly to the `vboxusers` group, and clones the Default Student Image desktop. The default password will be set to `CputLab2026!`. *Note: Instruct students to open the terminal and type `passwd` to change this upon first login.*
* **2. Remove a student:** Instantly deletes the student account and completely wipes their isolated home directory to free up disk space.
* **3. List current students:** Displays all active student accounts currently provisioned on the machine.

**Shared Lab Files:**
Admins can place course materials, ISOs, or PDFs into `/opt/shared_lab_files/`. Students have a shortcut to this folder on their desktop with Read-Only access.

---

## 4. Remote Connection Options

To allow students to connect to this server from off-campus, the university IT department can utilize one of the following ingress architectures, listed in order of preference:

### Option A: Internal VLAN + Existing Student VPN (Recommended)

* **How it works:** The server is placed on an internal campus VLAN. Students log into the existing university VPN from home, then open their standard Remote Desktop (RDP) client and connect to the server's internal IP.
* **Pros:** Zero new edge-security risks; utilizes existing IT authentication protocols.

### Option B: Edge Port Forwarding (NAT)

* **How it works:** IT assigns the server a static internal IP and creates a firewall rule translating an external public IP/Port to the internal server on TCP Port 3389 (XRDP).
* **Pros:** Students do not need a VPN client.
* **Security Note:** The server is already hardened with UFW and Fail2ban, but port-forwarding RDP directly to the internet is generally discouraged without IP whitelisting.

### Option C: Cloudflare Zero Trust (SD-WAN / Overlay Network)

* **How it works:** If campus firewalls cannot be modified, a lightweight daemon (`cloudflared`) is installed on the server. It makes a secure, outbound connection to Cloudflare on TCP 443 (HTTPS), bypassing inbound NAT restrictions. Students use the Cloudflare WARP client to access the private routing tunnel.
* **Pros:** Does not require university firewall changes; provides Zero-Trust logging and modern identity verification (SSO/Email OTP).

---

*System engineered by Shahied Rustin | Rustin Systems | www.rustinsystems.com

---
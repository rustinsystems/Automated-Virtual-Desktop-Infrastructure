
---

# Quick Start Guide: CPUT Remote Lab VDI

**Prepared by:** Rustin Systems

This guide covers how to operate the already fully provisioned Virtual Desktop Infrastructure (VDI) server on a local test network. The server is already pre-configured with XRDP, XFCE desktop environments, and all necessary virtualization tools.

### **Phase 1: Network Verification**

To test the environment, both the Ubuntu server and your client laptop (Windows/Linux) must be connected to the same local network (e.g., A test router or VLAN).

**1. Find the Server's IP Address**
Plug a monitor and keyboard into the Ubuntu server (or open its local terminal) and type:

```bash
hostname -I

```

*Write down the first IP address that appears (e.g., `192.168.8.100`).*

**2. Test the Network Connection**
On your Windows laptop, open the **Command Prompt** and ping the server to ensure they can "see" each other:

```cmd
ping 192.168.8.100

```

*(If you get replies, the network is working).*

**3. Test the RDP Port (Optional but Recommended)**
To verify that the server's firewall is correctly allowing Remote Desktop traffic, open **PowerShell** on your Windows laptop and run:

```powershell
Test-NetConnection -ComputerName 192.168.8.100 -Port 3389

```

*(Look for `TcpTestSucceeded : True` at the bottom of the output).*

---

### **Phase 2: Create a Test Student**

Before you can log in remotely, you need to generate a student account using the custom management tool.

1. On the Ubuntu server terminal, launch the manager:
```bash
sudo manage_lab_users

```


2. Select **Option 1** to add a new student.
3. Enter a test username (e.g., `student1`).
4. The system will automatically build their isolated environment and clone the Golden Image desktop.
* *Note: The system automatically assigns the default password: **`CputLab2026!`**



---

### **Phase 3: Connect to the Virtual Desktop**

Now that the network is verified and the user exists, you can connect from your client machine.

**If you are using Windows:**

1. Open the Start Menu and search for **Remote Desktop Connection**.
2. In the "Computer" field, type the server's IP address (e.g., `192.168.8.100`) and click **Connect**.
3. A security warning about a certificate will pop up. Check the box that says "Don't ask me again" and click **Yes**.

**If you are using Linux (Remmina):**

1. Open **Remmina**.
2. Ensure the protocol dropdown in the top left is set to **RDP**.
3. Type the server's IP address into the address bar and hit **Enter**.
4. Accept the certificate prompt.

### **Phase 4: The Login Screen**

You will now see the blue-green XRDP login screen.

1. Leave the Session type as **Xorg**.
2. Enter the username you created (`student1`).
3. Enter the default password (`CputLab2026!`).
4. Click **OK**.

You will be dropped directly into the CPUT configured desktop environment. VirtualBox and the Brave browser are pinned to the desktop, alongside the read-only Shared Lab Files folder.

---
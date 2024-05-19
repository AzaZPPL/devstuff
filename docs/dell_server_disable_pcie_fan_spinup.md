# Documentation: Disabling Fans Going to 100% When Something is Installed in the PCIE Slot

## Overview
When a device is installed in the PCIE slot on your server, the system fans might spin up to 100%. This behavior can be altered via Dell's iDRAC (Integrated Dell Remote Access Controller). This document provides two methods to disable the fans from going to 100% when a device is installed in the PCIE slot: using SSH with `racadm` and using `ipmitool`.

## Method 1: Using SSH and RACADM

### Prerequisites
- Access the iDRAC IP address.
- Ensure you have the same credentials for logging into iDRAC.

### Steps

1. **Connect to iDRAC via SSH:**

   ```sh
   ssh <iDRAC_username>@<iDRAC_IP>
   ```

2. **Check the current value of `ThirdPartyPCIFanResponse`:**

   ```sh
   racadm get system.thermalsettings.ThirdPartyPCIFanResponse
   ```

3. **Disable `ThirdPartyPCIFanResponse` if it is enabled:**

   ```sh
   racadm set system.thermalsettings.ThirdPartyPCIFanResponse 0
   ```

## Method 2: Using IPMI

### Prerequisites
- Access the iDRAC web interface.
- Administrative privileges on iDRAC.
- Install `ipmitool` on your local machine (`apt` command is for Debian-based systems):

  ```sh
  apt -y install ipmitool
  ```

### Steps

1. **Enable IPMI Over LAN:**

   - Log in to the iDRAC web interface.
   - Navigate to **iDRAC Settings** > **Network**.
   - Scroll to the bottom and enable **IPMI Over LAN**.
   - Set **Channel Privilege Level Limit** to **Administrator**.

2. **Check System SDR and Connectivity:**

   ```sh
   ipmitool -I lanplus -H <iDRAC_IP> -U <iDRAC_username> -P <iDRAC_password> sdr elist all
   ```

3. **Check the current value using IPMI raw command (to check the value):**

   ```sh
   ipmitool -I lanplus -H <iDRAC_IP> -U <iDRAC_username> -P <iDRAC_password> raw 0x30 0xce 0x01 0x16 0x05 0x00 0x00 0x00
   ```

   - If the result is `16 05 00 00 00 05 00 01 00 00`, the setting is disabled.
   - If the result is `16 05 00 00 00 05 00 00 00 00`, the setting is enabled.

4. **Disable the option using the IPMI raw command:**

   ```sh
   ipmitool -I lanplus -H <iDRAC_IP> -U <iDRAC_username> -P <iDRAC_password> raw 0x30 0xce 0x00 0x16 0x05 0x00 0x00 0x00 0x05 0x00 0x01 0x00 0x00
   ```

5. **(Optional) Enable the option using the IPMI raw command:**

   ```sh
   ipmitool -I lanplus -H <iDRAC_IP> -U <iDRAC_username> -P <iDRAC_password> raw 0x30 0xce 0x00 0x16 0x05 0x00 0x00 0x00 0x05 0x00 0x00 0x00 0x00
   ```

## Summary
You can manage the behavior of the fans when a device is installed in the PCIE slot via the iDRAC interface using SSH with `racadm` or by enabling IPMI and using the `ipmitool`. Both methods allow you to check the current setting and disable it if needed to prevent fans from spinning up to 100%.
---
title: "Automatically power back on servers after a power outage with a Raspberry Pi and Wake On Lan"
date: 2023-10-22T18:35:13+02:00
draft: false
---

## Context

I recently woke up with a non-working network connection in my house, both internet and LAN accesses were down.  
I immediately checked on my internet provider, but my router seemed running just fine and no breakages were reported on their side in my region.

I then decided to check on my own infrastructure and realised that both of my physical servers were down. Those servers host my DNS and DHCP services, which explains why I had a faulty network connection.  
After a quick thought, I understood that a power outage occurred during the night (which wasn't so obvious at first as the power was back when I woke up), causing my servers to go down. While my router automatically switched back on when the power came back, my servers didn't. Indeed, *without extra configuration,* you physically need to press down the power button to power them on.

During my reflexion about how to prevent that for the future, I obviously thought of buying a [UPS](https://en.wikipedia.org/wiki/Uninterruptible_power_supply) to get a fault tolerance in case of short power outage or at least have the servers shutdown properly in case of long ones. But the low frequency of power cuts in my current place and the low impact of an eventual downtime of my services/infrastructure when those happen isn't worth the (high) cost.  
So I ended up thinking about a cheap, modular and easy solution to add a sort of power outage "tolerance" to my servers thanks to a simple [Raspberry Pi](https://en.wikipedia.org/wiki/Raspberry_Pi).

## The hardware

You need hardware that automatically powers on when the power comes in, like it's the case for most small single board computers.

I personally used a Raspberry Pi (3B+) that was sleeping in my drawer.  
There's no specific requirements in terms of performance, as long as it is capable of running a simple Linux server.

Raspberry Pis are cheap, have a low power consumption and run Linux pretty well, so they are a great fit for this, but any other hardware that matches the above requirements will do.

## The solution

The solution consist of a simple script running on the Raspberry Pi that monitors my servers health and make use of the ["Wake On Lan" network standard](https://en.wikipedia.org/wiki/Wake-on-LAN) to power them back on remotely after a (configurable) period of downtime.  
Indeed, thanks to the way Raspberry Pis are automatically powered on when power comes in, the Raspberry Pi will automatically power back on when the power is restored after a power outage, allowing it to check my other physical servers health / responsiveness, and power them back on if needed.

But before writing such a script on the Raspberry Pi, we have to make the monitored servers compatible with Wake On Lan so they can properly handle the related network packet sent by the script.

### Enabling Wake On Lan support on the monitored servers

If your hardware/motherboard is fairly recent, it should be compatible with Wake On Lan but you may have to enable the associated parameter in your UEFI/BIOS settings.  
It is usually located under the "power management" or "network" section.

If you can't find such a parameter, it might be named differently or it may be already enabled by default.  
Check instructions from your motherboard vendor.

Once enabled on the hardware side, the Wake On Lan support has to be enabled on the software side:  
To enable Wake On Lan support on your network adapter, install the [ethtool package](https://repology.org/project/ethtool/versions) (if not installed already) and run the following command to enable Wake On Lan support for the current boot:

```bash
sudo ethtool -s eth0 wol g # Replace "eth0" by the name of your network adapter
```

Then, to enable it persistently, follow the instructions related to the network manager you use:

- [Debian Wiki](https://wiki.debian.org/WakeOnLan#Enabling_WOL) (contains instructions for `ifupdown`, specific to Debian)
- [Arch Wiki](https://wiki.archlinux.org/title/Wake-on-LAN#Make_it_persistent)

### Configuring the Raspberry Pi

The first thing we need is a Wake On Lan application/utility capable of sending the network packet needed to power on the servers.  
I personally use [this one](https://github.com/jpoliv/wakeonlan/) which is [packaged by most Linux distributions](https://repology.org/project/wakeonlan-jpoliv/versions).

We then need a script to monitor servers and send a Wake On Lan packet if needed.  
[Here is](https://github.com/Antiz96/Commands-Scripts/blob/main/monitor-servers-wakeonlan.sh) the one I wrote:

It sends a ping to the given list of servers and increment a "fail counter" per server each time a ping doesn't get a response.  
By default, a Wake On Lan packet is sent after 6 consecutive fails and there's a wait period of 5 minutes between each try, so that's a total of 30 minutes of downtime.  
I chose to use those not too "aggressive" values by default so I can still shutdown my servers for maintenance purposes (for instance) without the script being triggered instantly and sending Wake On Lan packets right away. But you can, of course, modify those values to your liking!

See the comments in the script to adapt it to your needs and environment.  

```bash
#!/bin/bash

# Replace "Server1/Server2" by the DNS name or IP address of your servers.
# If you use DNS names and your DNS server is running on the monitored servers (like it's the case for me), remember to fill in `/etc/hosts` accordingly.
#
# Then replace "MAC_address_of_the_network_adapter" by the MAC address of the network adapter of the corresponding server.
# You can find it in the `link/ether` field when running `ip link` on your server.
#
# You can declare as many servers as you want.
declare -A servers
servers["Server1"]="MAC_address_of_the_network_adapter"
servers["Server2"]="MAC_address_of_the_network_adapter"

declare -A fail_counter

# This log file is used to collect logs for sent Wake On Lan packets.
logfile="/var/log/monitor-servers-wakeonlan/wol_packet.log"

while true; do
        for server in "${!servers[@]}"; do
                if ping -c1 "${server}" &>/dev/null; then
                        fail_counter["${server}"]=0
                        echo "${server} fail counter: ${fail_counter["${server}"]}"
                else
                        fail_counter["${server}"]=$((fail_counter["${server}"] + 1))
                        echo "${server} fail counter: ${fail_counter["${server}"]}"

                        # Here is defined the number of consecutive fails needed to send a Wake On Lan packet.
                        # You can adapt it if needed.
                        if [ "${fail_counter["${server}"]}" -eq 6 ]; then
                                wakeonlan "${servers["${server}"]}" && echo "$(date) - Wake On Lan packet sent to ${server}" >> "${logfile}" || echo "$(date) - Error sending a Wake On Lan packet to ${server}" >> "${logfile}"
                                fail_counter["${server}"]=$((fail_counter["${server}"] - 1))
                        fi
                fi
        done

        # Here is defined the wait time period between each try (in seconds).
        # You can adapt it if needed.
        sleep 300
done
```

Finally, we can create a systemd service to launch the script automatically at boot (given that your Linux distribution uses systemd as its init system. If not, check your init system's documentation).

Here's the one I wrote, under `/usr/local/lib/systemd/system/monitor-servers-wakeonlan.service`:

```text
[Unit]
Description=Monitor physical servers responsiveness and power them back on if needed
After=network-online.target

[Service]
Type=oneshot
ExecStart=/path/to/the/script # Adapt this line to the path of your script

[Install]
WantedBy=default.target
```

Then start the service and enable it at boot:

```bash
sudo systemctl enable --now monitor-servers-wakeonlan.service
```

Since the script is launched via a systemd service, you can see the output in real time with `journalctl`/`systemctl status`:

```bash
$ sudo systemctl status monitor-servers-wakeonlan.service

● monitor-servers-wakeonlan.service - Run the script that monitors physical servers' responsiveness and power them back on if needed
     Loaded: loaded (/usr/local/lib/systemd/system/monitor-servers-wakeonlan.service; enabled; preset: enabled)
     Active: activating (start) since Wed 2023-09-20 14:15:24 CEST; 1 month 6 days ago
   Main PID: 492 (monitor-servers)
      Tasks: 2 (limit: 963)
     Memory: 2.7M
        CPU: 11.972s
     CGroup: /system.slice/monitor-servers-wakeonlan.service
             ├─  492 /bin/bash /usr/local/bin/monitor-servers-wakeonlan
             └─20701 sleep 300

Oct 27 12:46:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx02.rc fail counter: 0
Oct 27 12:46:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx01.rc fail counter: 0
Oct 27 12:51:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx02.rc fail counter: 0
Oct 27 12:51:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx01.rc fail counter: 0
Oct 27 12:56:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx02.rc fail counter: 0
Oct 27 12:56:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx01.rc fail counter: 0
Oct 27 13:01:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx02.rc fail counter: 0
Oct 27 13:01:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx01.rc fail counter: 0
Oct 27 13:06:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx02.rc fail counter: 0
Oct 27 13:06:23 rasp01.rc monitor-servers-wakeonlan[492]: pmx01.rc fail counter: 0
```

You can also stop the script's execution if needed by simply stopping the associated service:

```bash
sudo systemctl stop monitor-servers-wakeonlan.service
```

## Conclusion

So this is it! A simple, easy and cheap solution to monitor your servers' responsiveness and power them back on automatically if needed.

However, while this solution works to power servers back on after a power outage, it does not prevent them to be brutally shut down when the power loss occurs.  
For a proper tolerance to short power outage and a proper shutdown for your servers in case of a long one, yous should buy a UPS.

Note that this "Wake On Lan" solution can totally co-exist with a UPS, so your servers are properly shutdown in case of a long power outage and automatically powered back on when the power's back! :slightly_smiling_face:

---
title: "Power Outage Tolerance With a Raspberry Pi"
date: 2023-10-22T18:35:13+02:00
draft: false
---

## A little bit of context

I recently woke up with a non working network connection in my house, both internet and LAN accesses were down.  
I immediately checked on my internet provider but my router seemed running just fine and no breakages were reported on their side in my region.

I then decided to check on my own infrastructure and realised that both of my physical servers were down. Those servers host my DNS and DHCP services, which explains why I had a faulty network connection.  
After a quick thought, I understood that a power outage occurred during the night (which wasn't so obvious at first as the power was back when I woke up), causing my servers to go down. While my router automatically switched back on when the power came back, my servers didn't. Indeed, *without extra configuration,* you physically need to press down the power button to power them on.

During my reflexion about how to prevent that for the future, I obviously thought of buying a [UPS](https://en.wikipedia.org/wiki/Uninterruptible_power_supply) but the low frequency of power cuts in my current place and the low impact of an eventual small downtime of my services/infrastructure when those happen simply doesn't worth the cost.  
So I ended up thinking about a cheap, modular and easy solution to add a sort of power outage "tolerance" to my servers thanks to a simple [Raspberry PI](https://en.wikipedia.org/wiki/Raspberry_Pi) that I'll present to you through this article.

## The Hardware

I personally used the Raspberry PI (3B+) that was sleeping in my drawer, but any model would do.  
There's no specific requirements in terms of performance, as long as it is capable of running a simple Linux server you're good.

The only prerequisite is to get hardware that automatically powers on when the power comes in, like it's the case for Raspberry PIs (and for most other small single board computer that do not have a power button).

Raspberry PIs are cheap, have a low power consumption and run Linux pretty well, hence why I recommend them. But if you have another hardware that respect the above prerequisites (automatic power on and runs Linux), that's perfect!

## The solution

The solution consist of a script running on the Raspberry PI that monitors my servers health and make use of the ["Wake On Lan" network standard](https://en.wikipedia.org/wiki/Wake-on-LAN) to power them back on remotely after a (configurable) period of downtime.  
Indeed, thanks to the way Raspberry PIs are automatically powered on when power comes in, the Raspberry PI will automatically powers back on when the power is restored after a power outage, allowing it to check and power on my other physical servers in such cases.

But before creating the script on the Raspberry PI, we have to make the monitored servers compatible with Wake On Lan in order for them to be able to handle the network packet sent by the script to power them on properly.

### Enabling Wake On Lan support on the monitored servers

If your hardware/motherboard is fairly recent, it should be compatible with Wake On Lan but you may have to enable the related parameter in your UEFI/BIOS settings.  
It is usually located under the "power management" or "network" section.

If you can't find such parameter, it might be named differently or already enabled by default.  
Check instructions from your motheroard vendor.

Once enabled on the hardware side, the Wake On Lan support has to be enabled on the software side:  
To enable Wake On Lan support on your network adapter **for the current session**, install the [ethtool package](https://fr.wikipedia.org/wiki/Ethtool) (if not done already) and run the following command:

```bash
sudo ethtool -s eth0 wol g #Replace "eth0" by the name of your network card
```

Then, to enable it **permanently**, follow the instructions related to the network manager you use:

- [Debian Wiki](https://wiki.debian.org/WakeOnLan#Enabling_WOL) (contains instructions for `ifupdown` specific to Debian)
- [Arch Wiki](https://wiki.archlinux.org/title/Wake-on-LAN#Make_it_persistent)

### Configuring the Raspberry PI




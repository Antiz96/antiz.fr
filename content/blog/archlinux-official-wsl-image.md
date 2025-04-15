---
title: "Arch Linux now has an official WSL image"
date: 2025-04-15T15:40:00+02:00
draft: false
---

*...and it is officially (re)distributed by Microsoft!*

A few months ago, the eventuality of building and providing an official Arch Linux [WSL](https://learn.microsoft.com/en-us/windows/wsl/about) image (Windows Subsystem for Linux - a Microsoft solution allowing to run Linux environments within Windows) was brought to the table within the Arch Linux staff.

This subject was actually explored a few years back but got turned down due to multiple concerns and lack of interest at the time. But `WSL` have come a long way since then and minds evolved to the point where people were generally willing to reconsider it.

## WSL? For what, for who?

Despite being employed as a Linux system engineer, I personally never had the chance to work for a company that allowed me to run Linux on my workstation yet... The usage of Windows always was *hardly* required by their "internal policy" (whatever that means). It's unfortunately pretty safe to say that I'm not the only person in that situation.  
In such case, `WSL` acts as a pretty acceptable and reliable workaround (from my experience), allowing one to run a Linux environment in a fairly transparent way directly from a Windows system; providing a direct access to every Linux tools, *hopefully* without getting in the way of eventual companies requirements / restrictions.

More generally speaking, `WSL` provides an easy and straightforward way to get access to a full Linux environment, allowing to perform Linux development / testing or simply to try & run a Linux distribution directly from Windows; increasing its discoverability & accessibility.

However, the lack of official Arch Linux image for `WSL` *at the time* either suggested the use of a different distribution or implied users to rely on unofficial `WSL` images for Arch Linux, which quality may vary.

As I'm currently relying on `WSL` for my dayjob, when it appeared that we (Arch Linux) were willing to re-discuss the subject, I naturally expressed my interest and started exploring it.

## Writing specifications and submitting an official proposal

Coincidentally, [Fedora](https://fedoraproject.org/) also started exploring creating WSL images around the same time. Their [related change request](https://fedoraproject.org/wiki/Changes/FedoraWSL) was a huge inspiration for me to define specifications and act on some unresolved questions. So, thanks Fedora people! :blue_heart:

After listing *most* specifications, I shared them through a [mail thread in the Arch-Dev-Public mailing list](https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/73A4BK7YK4BJBVXGMN2I5CROQAWI53VZ/) to collect some thoughts and estimate the overall interest around an Arch Linux WSL image. To my *pleasant* surprise, this mail thread generated quite some attractions with a majority of positive feedback, both from users and staff!

I therefore proceeded to submit an official proposal for it, including every settled specifications, [through a formal RFC](https://gitlab.archlinux.org/archlinux/rfcs/-/merge_requests/50) (Request For Comments - the mechanism we use at Arch Linux to officially propose and discuss significant changes to our distribution). This RFC was later officially accepted and [published](https://rfc.archlinux.page/0050-arch-linux-wsl-image/).

## Implementation and collaboration with Microsoft for official redistribution

With the proposal officially accepted, it was time to start the implementation.

I'm not gonna detail the whole process here but, in a nutshell, we created [a dedicated repository on our GitLab instance](https://gitlab.archlinux.org/archlinux/archlinux-wsl) to which I added every files and scripts needed to build an Arch Linux `WSL` image from scratch. The build system is partly inspired by the way we build our [Docker image](https://hub.docker.com/_/archlinux/), as a `WSL` image basically consists of a `rootFS` with additional specific `WSL` related configurations / files.  
I then set up a scheduled [GitLab CI](https://gitlab.archlinux.org/archlinux/archlinux-wsl/-/blob/main/.gitlab-ci.yml?ref_type=heads) within the repo to automatically build an image, run a series of automated tests against it and publicly release it monthly *(which goes along the release schedule of our ISO)*.

We also "re-opened" the [Arch Wiki page dedicated to install on WSL](https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL), so everyone can share documentation, tips & tricks and troubleshooting steps about this official WSL image (this page was formerly "closed" back we initially claimed that Arch Linux on `WSL` wasn't officially supported on our side).

In parallel, I [established contact with Microsoft's WSL team](https://github.com/microsoft/WSL/issues/12551) to ask if they were eventually interested to reference our image in the list of WSL's officially supported Linux distributions, to which [they responded *very* positively](https://github.com/microsoft/WSL/issues/12551#issuecomment-2635150613)!  
In collaboration with the Microsoft's WSL team, we therefore [added the official Arch Linux WSL image to their official Linux distribution manifest](https://github.com/microsoft/WSL/pull/12818):

![alt text](images/archlinux-wsl-image/wsl-distributions-list.png "WSL official Linux distributions list")

This allows users to download and install the latest Arch Linux `WSL` image from a Windows system with WSL installed in a fully automated way via a single `PowerShell` command! 🥳🎉

```
wsl --install archlinux
```

## Final thoughts

I am *really* happy and proud that we managed to get this through! Not only on the Arch Linux side itself (as the subject raised much more resilience and concerns the first time it was raised a few years back) but also on the Microsoft who showed a very helpful and cooperative approach toward our effort!  
I hope that this official Arch Linux `WSL` image will be useful to some people and will be beneficial for Arch Linux's discoverability and accessibility.

I'd like to take this conclusion as an occasion to thank:

- Fedora for *coincidentally* studying those intricaties around the same time as I did (which helped a lot)! 😄
- Microsoft for showing interest in including our Arch Linux image in their official `WSL` distribution manifest.
- [klausenbusk](https://github.com/klausenbusk) for helping in [setting up the mirroring of the image](https://gitlab.archlinux.org/archlinux/infrastructure/-/merge_requests/924).
- [heftig](https://github.com/heftig) for accepting to add the [dzn / microsoft experimental driver to our mesa package](https://gitlab.archlinux.org/archlinux/packaging/packages/mesa/-/issues/25), allowing to improve the user experience.
- [nl6720](https://wiki.archlinux.org/title/User:Nl6720) for providing precious help and hint with the dedicated documentation on the Arch Wiki page.
- [mhegreberg](https://github.com/mhegreberg) for jumping in as an Arch Linux community member, offering his help to maintain this image.
- Everyone who shared thoughts & showed interest in the related mail thread & the related RFC as well as everyone that helped along the way regarding the implementation and the documentation in the Wiki.

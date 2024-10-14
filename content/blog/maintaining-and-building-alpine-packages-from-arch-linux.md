---
title: "Maintaining and building Alpine packages from Arch Linux"
date: 2024-10-14T10:42:00+02:00
draft: false
---

## Alpine packaging tooling are now available in the Arch Linux [extra] repository!

I recently added the [abuild](https://gitlab.alpinelinux.org/alpine/abuild) and [atools](https://gitlab.alpinelinux.org/Leo/atools) Alpine packaging tooling (including `abuild rootbld` to build Alpine packages in a clean chroot) to the Arch-Linux [extra] repository.

Thanks to that, these tooling can now be used from an Arch Linux system to maintain and build Alpine packages (in a clean chroot), without requiring to rely on a separate Alpine installation, such as a container or a VM. It enables the Alpine packaging workflow directly from an Arch Linux system, streamlining this process for Arch users that *also* contributes to Alpine Linux (like I do).

## Environment setup to perform Alpine packaging from Arch Linux

Install the [abuild](https://archlinux.org/packages/extra/x86_64/abuild/) and [atools](https://archlinux.org/packages/extra/x86_64/atools/) packages:

```bash
sudo pacman -S abuild atools
```

To be able to build Alpine packages in a clean chroot with `abuild rootbld`, you need to generate a public / private rsa key pair with the `abuild-keygen` tool and add your user to the `abuild` group (which is created when installing the [abuild package](which is created when installing the abuild package)):

```bash
abuild-keygen -a -i
sudo usermod -aG abuild "username" # Requires a logout / login to take effect
```

One can optionally edit the `/etc/abuild.conf` configuration file to their liking and requirements. For instance, the paths used to store downloaded sources (`/var/cache/distfiles` by default) and built packages (`~/packages` by default) can be customized by modifying the `SRCDEST` and `REPODEST` parameters respectively in that configuration file.

See the [Arch wiki abuild page](https://wiki.archlinux.org/title/Abuild) for more details.

## Basic Alpine packaging workflow from Arch Linux

With the above setup, I'm able to perform my basic and regular Alpine packaging workflow directly from my Arch Linux system:

```bash
newapkbuild "package_name" && cd "package_name" # Create a new port for a package and `cd` into it
vim APKBUILD # Edit the APKBUILD
apkbuild-lint APKBUILD # Run the apkbuild linter
apkbuild-fixer APKBUILD # Attempt to automatically fix potential warnings raised by `apkbuild-lint`
abuild checksum # Generate / upgrade checksum for the source(s) contained in the APKBUILD source array
abuild rootbld # Build the package in an Alpine clean chroot
```

Of course, due to technical differences between Alpine and Arch Linux (e.g. in terms of package manager, init system and C library implementation), building Alpine packages on an Arch system outside of an Alpine clean chroot is not possible. As such, when building Alpine packages on an Arch system, only `abuild rootbld` is relevant to use.

I was initially using an Alpine container to access the necessary tooling to perform my Alpine packaging workflow, but this method had some flaws. Indeed, apart from the fact that working inside a container is not as comfortable as working from my actual system; building packages in a clean chroot using `abuild rootbld` inside a Docker container eventually requires some [additional setup](https://wiki.alpinelinux.org/wiki/Build_with_abuild_rootbld_in_Docker_container), and `fakeroot` (used during the packages build process) currently has some issues when used inside containers which, for instance, cause it to be *extremely* slow (see [this](https://github.com/moby/moby/issues/45436) and [this](https://github.com/moby/moby/issues/38814) bug reports).

Being able to run such Alpine packaging tooling directly from my Arch Linux system streamlines the packaging workflow I use to maintain [my Alpine packages](https://pkgs.alpinelinux.org/packages?name=&branch=edge&repo=&arch=&maintainer=Robin+Candau) (and hopefully the one of other Arch users & Alpine contributors too :v:).

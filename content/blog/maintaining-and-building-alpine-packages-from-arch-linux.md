---
title: "Maintaining and building Alpine packages from Arch Linux"
date: 2024-10-14T10:42:00+02:00
draft: false
---

## Alpine packaging tooling are now available in the Arch Linux [extra] repository!

I recently added the [abuild](https://gitlab.alpinelinux.org/alpine/abuild) and [atools](https://gitlab.alpinelinux.org/Leo/atools) Alpine packaging tooling (including `abuild rootbld` to build Alpine packages in a clean chroot) to the Arch-Linux [extra] repository.

This enables the Alpine packaging workflow directly from Arch Linux, allowing Arch users that *also* contributes to Alpine Linux (like I do) to run some Alpine packaging commands / tools, such as `newapkbuild`, `apkbuild-lint`, `apkbuild-fixer`, `abuild checksum`, `abuild rootbld`, ..., without the necessity to rely on an separate Alpine installation (e.g. a container / chroot or a VM).

## Environment setup to perform Alpine packaging from Arch Linux

Install the [abuild](https://archlinux.org/packages/extra/x86_64/abuild/) and [atools](https://archlinux.org/packages/extra/x86_64/atools/) packages:

```bash
sudo pacman -S abuild atools
```

To be able to build packages in a clean chroot with `abuild rootbld`, you need to generate a public / private rsa key pair with `abuild-keygen`, install the `alpine-keyring` package (optional dependency for the [abuild package](https://archlinux.org/packages/extra/x86_64/abuild/)) and add your user to the `abuild` group:

```bash
abuild-keygen -a -i
sudo pacman -S --asdeps alpine-keyring
sudo usermod -aG abuild "your_user" # Requires a logout / login to take effect
```

Packages built in a clean chroot using `abuild rootbld` are located into `~/packages` by default, but that path can be customized with the `-P` option (e.g. `abuild -P /path/to/directory rootbld`) or with the `$REPODEST` environment variable.  
On my side, I've set it up in my `~/.bashrc`, like so:

```bash
export REPODEST="${HOME}/Documents/Alpine-Linux/Packages"
```

See the [Alpine wiki](https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package#Setup_your_system_and_account) for more details.

## Basic Alpine packaging workflow from Arch Linux

With the above setup, I'm able to perform my basic and regular Alpine packaging workflow directly from my Arch Linux system:

```bash
newapkbuild "package_name" && cd "package_name" # Create a new port for a package and `cd` into it
vim APKBUILD # Edit the APKUILD
apkbuild-lint APKBUILD # Run the apkbuild linter
apkbuild-fixer APKBUILD # Attempt to automatically fix potential warnings raised by `apkbuild-lint`
abuild checksum # Generate / upgrade checksum for the source(s) contained in the APKBUILD source array
abuild rootbld # Build the package in an Alpine clean chroot
```

That's it! I was initially using an Alpine container to access the necessary tooling to perform my Alpine packaging workflow, but it had some flaws. Indeed, apart from the fact that working inside a container is not as handy as working from my actual system, building packages in a clean chroot using `abuild rootbld` inside a Docker container eventually requires some [additional setup](https://wiki.alpinelinux.org/wiki/Build_with_abuild_rootbld_in_Docker_container), and `fakeroot` (used during packages build) has some issues when used inside containers which, for instance, cause it to be *extremely* slow (see [this](https://github.com/moby/moby/issues/45436) and [this](https://github.com/moby/moby/issues/38814) bug reports).

Being able to run such Alpine packaging tooling directly from my Arch Linux system streamlines the packaging workflow I use to maintain [my Alpine packages](https://pkgs.alpinelinux.org/packages?name=&branch=edge&repo=&arch=&maintainer=Robin+Candau) (and hopefully the one of other Arch users & Alpine contributors too :v:).

---
title: "Arch Linux now has a bit-for-bit reproducible Docker image"
date: 2026-04-21T22:30:00+02:00
draft: false
---

As a follow-up to the [similar milestone reached for our WSL image a few months ago](https://antiz.fr/blog/the-archlinux-wsl-image-is-now-reproducible/), I'm happy to share that Arch Linux now has a bit-for-bit reproducible Docker image!

This bit-for-bit reproducible image is distributed under a new ["repro" tag](https://hub.docker.com/layers/archlinux/archlinux/repro).  
The reason for this is due to one *noticeable* caveat: to ensure reproducibility, the pacman keys have to be stripped from the image, meaning that pacman is not usable *out of the box* in this image. While waiting to find a suitable solution to this technical constraint, we are therefore providing this reproducible image under a dedicated tag as a first milestone.

In practice, that means that users will need to (re)generate the pacman keyring in the container before being able to install and update packages via `pacman`, by running: `pacman-key --init && pacman-key --populate archlinux` (whether interactively at first start or from a `RUN` statement in a Dockerfile if using this image as base).  
Distrobox users can run this as a pre-init hook: `distrobox create -n arch-repro -i docker.io/archlinux/archlinux:repro --pre-init-hooks "pacman-key --init && pacman-key --populate archlinux"`

The bit-for-bit reproducibility of the image is confirmed by digest equality across builds (via `podman inspect --format '{{.Digest}}' <image>`) and by using [diffoci](https://github.com/reproducible-containers/diffoci) to compare builds.  
Documentation to reproduce this Docker image is available [here](https://gitlab.archlinux.org/archlinux/archlinux-docker/-/blob/master/REPRO.md).

Building the base rootFS for the Docker image in a deterministic way was the main challenge, but it reuses [the same process as for our WSL image](https://gitlab.archlinux.org/archlinux/archlinux-wsl/-/commit/7c0340e26358048f3f8ee03b3ab3aea666751712) (as both share the same rootFS build system).

The main Docker-specific adjustments include (see also the related `diffoci` reports):

- Set `SOURCE_DATE_EPOCH` and honor it in the `org.opencontainers.image.created` LABEL in the Dockerfile

```text
TYPE    NAME                  INPUT-0    INPUT-1
Cfg     ctx:/config/config    ?          ?
```

- Remove the ldconfig auxiliary cache file (which introduces non-determinism) from the built image in the Dockerfile:

```text
TYPE    NAME                            INPUT-0                                                             INPUT-1
File    var/cache/ldconfig/aux-cache    656b08db599dbbd9eb0ec663172392023285ed6598f74a55326a3d95cdd5f5d0    ffee92304701425a85c2aff3ade5668e64bf0cc381cfe0a5cd3c0f4935114195
```

- Normalize timestamps during `docker build` / `podman build` using the `--source-date-epoch=$SOURCE_DATE_EPOCH` and `--rewrite-timestamp` options:

```text
TYPE    NAME                 INPUT-0                          INPUT-1
File    etc/                 2026-03-31 07:57:46 +0000 UTC    2026-03-31 07:59:21 +0000 UTC
File    etc/ld.so.cache      2026-03-31 07:57:46 +0000 UTC    2026-03-31 07:59:21 +0000 UTC
File    etc/os-release       2026-03-31 07:57:46 +0000 UTC    2026-03-31 07:59:21 +0000 UTC
File    sys/                 2026-03-31 07:57:46 +0000 UTC    2026-03-31 07:59:21 +0000 UTC
File    var/cache/           2026-03-31 07:57:46 +0000 UTC    2026-03-31 07:59:21 +0000 UTC
File    var/cache/ldconfig/  2026-03-31 07:57:46 +0000 UTC    2026-03-31 07:59:21 +0000 UTC
File    proc/                2026-03-31 07:57:46 +0000 UTC    2026-03-31 07:59:21 +0000 UTC
File    dev/                 2026-03-31 07:57:46 +0000 UTC    2026-03-31 07:59:21 +0000 UTC
```

You can check [the related change set in our archlinux-docker repository](https://gitlab.archlinux.org/archlinux/archlinux-docker/-/merge_requests/96/diffs) for more details.  
Thanks to [Mark](https://hegreberg.io/) for his help on that front!

This represents yet another meaningful achievement regarding our general "reproducible builds" efforts and I'm already looking forward to the next step! :hugs:

For what it's worth, I'm eventually considering setting up a rebuilder for this Docker image (as well as for [the WSL image](https://gitlab.archlinux.org/archlinux/archlinux-wsl/-/blob/main/REPRO.md) and future eventual reproducible images) on my server in order to periodically / automatically rebuild the latest image available, verify it's reproducibility status and share build logs / results publicly somewhere.  
**EDIT:** Done! It's available at <https://archimgrepro.antiz.fr> :partying_face: :tada:

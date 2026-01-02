---
title: "FOSS Recap 2025"
date: 2025-01-02T15:40:00+02:00
draft: false
---

Hey everyone! :wave:

As done [last year](https://antiz.fr/blog/foss-recap-2024/), here is a recap of all the noticeable FOSS related stuff I had the chance to work on and achieve in 2025. :smile:

See also the awesome recap of my FOSS mates and good friends: [kpcyrd](https://vulns.xyz/2025/12/2025-wrapped/), [orhun](https://blog.orhun.dev/2025-wrapped/).

## Arch Linux

### Packaging

I pushed a total of 2277 packages to Arch Linux repositories, most of which being packages updates with the top five packages being [python-sentry_sdk](https://archlinux.org/packages/extra/any/python-sentry_sdk/) & [limine](https://archlinux.org/packages/extra/x86_64/limine/) (both 39), [python-fastapi](https://archlinux.org/packages/extra/any/python-fastapi/) (43), [hugo](https://archlinux.org/packages/extra/x86_64/hugo/) (50), [syd](https://archlinux.org/packages/extra/x86_64/syd/) (52) & [jenkins](https://archlinux.org/packages/extra/any/jenkins/) (53).

I also added some new packages to the repository, such as (but not limited to) [act_runner](https://archlinux.org/packages/extra/x86_64/act_runner/), [atools-go](https://archlinux.org/packages/extra/x86_64/atools-go), [sshs](https://archlinux.org/packages/extra/x86_64/sshs/) and [wlr-sunclock](https://archlinux.org/packages/extra/x86_64/wlr-sunclock/).

### Bumpbuddy

Together with [gromit](https://github.com/christian-heusel) and [klausenbusk](https://github.com/klausenbusk), we officially released & introduced [bumpbuddy](https://gitlab.archlinux.org/archlinux/bumpbuddy) (previously refered to as the "Nvchecker PoC").

Bumpbuddy is a daemon watching for new upstream releases for our packages. It automatically opens GitLab issues for out of date packages and manages them autonomously (e.g. opened issues are automatically updated to match newer upstream releases and are automatically closed once the matching version is being pushed to the repository).

Aside from offering a centralized and automated way for tracking and reporting new upstream releases for Arch Linux package maintainers, it also provides a public place for anyone to discuss the state of a pending update or expose eventual blocking points.  
This should hopefully allow for both more pro-active packages update and more transparency towards users eventually wondering about the progress of a specific update.

See bumpbuddy's [official announcement](https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/3QINI22ULKMDVXG75P7QATV3E5GVMZR3/) and [automated GitLab issue example](https://gitlab.archlinux.org/archlinux/packaging/packages/python-fastapi/-/issues/30) for more details.

Some future work and mid / long term goals around bumpbuddy are in progress, such as (but not limited to):

- [Providing a web report overview](https://gitlab.archlinux.org/archlinux/bumpbuddy/-/issues/10)
- Manage packages' out of date status in Archweb and get rid of / replace the "flag out of date" button (which is manual, error prone, may be used abusively and lacks transparency)
- Open merge requests rather than (or in addition of) GitLab issues, regarding our future goal of adopting a more gitops oriented packaging workflow

### Infrastructure

I officially [joined the Arch Linux DevOps team](https://lists.archlinux.org/archives/list/arch-devops@lists.archlinux.org/thread/NJWIMB5KNBOCTWVCGTQTO7OF6XHRKWHX/) and made several contributions to the Arch Linux infrastructure, such as (but not limited to):

- [Update package cache handling mechanism for Arch servers](https://gitlab.archlinux.org/archlinux/infrastructure/-/merge_requests/921)
- [Setup GoAccess on Nginx servers](https://gitlab.archlinux.org/archlinux/infrastructure/-/merge_requests/1006)
- [Add a dedicated server and IAC for bumpbuddy](https://gitlab.archlinux.org/archlinux/infrastructure/-/merge_requests/963)
- [Add a DevOps managed Fastly CDN mirror](https://gitlab.archlinux.org/archlinux/infrastructure/-/merge_requests/1031) (work done collaboratively with [gromit](https://github.com/christian-heusel) and [pitastrudl](https://github.com/pitastrudl), see the related [public announcement](https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/QRTTKZYECWFHKI5OFG6MVVLHKDPGQS5S/) for more details)
- [Add metrics about the new Fastly CDN mirror to prometheus / grafana](https://gitlab.archlinux.org/archlinux/infrastructure/-/merge_requests/1092)

### WSL Image

I worked on creating an [official Arch Linux WSL image](https://gitlab.archlinux.org/archlinux/archlinux-wsl) that has been [included in Microsoft's manifest of officially supported distributions for WSL](https://github.com/microsoft/WSL/pull/12818).

Huge thanks to [Mark](https://hegreberg.io/) who offered his help as an Arch Linux community member to maintain this WSL image with me and later joined the Arch Linux Staff as an additional official maintainer for it. :handshake:

For more details, see the [related Arch Linux RFC](https://rfc.archlinux.page/0050-arch-linux-wsl-image/), the [dedicated Arch Wiki page](https://wiki.archlinux.org/title/Install_Arch_Linux_on_WSL) and the [blog post I wrote earlier this year on the subject](https://antiz.fr/blog/archlinux-official-wsl-image/).

### Testing Team

Together with [gromit](https://github.com/christian-heusel), we created around 70 new [testing team accounts](https://wiki.archlinux.org/title/Arch_Testing_Team) this year.

Aside from the usual testing, I helped testing some kernel and systemd pre-releases (respectively packaged by [gromit](https://github.com/christian-heusel) and [eworm](https://github.com/eworm-de)).

### Tools / Tooling

#### BuildBTW

I joined the [BuildBTW](https://gitlab.archlinux.org/archlinux/buildbtw) (future centralized Arch Linux build service) proof of concept as a tester. Aside from showing my appreciation toward the amazing work done so far, I had the occasion to open a improvements suggestions, such as:

- [Handle `.SRCINFO` updates automatically](https://gitlab.archlinux.org/archlinux/buildbtw/-/issues/148)
- [Add additional info to the CLI and WebUI](https://gitlab.archlinux.org/archlinux/buildbtw/-/issues/149)

#### Devtools / pkgctl

I made some contributions to our packaging tooling, such as:

- [`pkgctl version`: Fail if the `cmd` source is used in `.nvchecker.toml`](https://gitlab.archlinux.org/archlinux/devtools/-/merge_requests/295)

#### Pacman-Contrib

I made some contributions to pacman-contrib, such as:

- [`paccache`: Add support for passing extra argument to the systemd service via a centralized configuration file](https://gitlab.archlinux.org/pacman/pacman-contrib/-/merge_requests/53)
- [`checkupdates`: Disable filesystem sandbox for compatibility with pacman v7.1.0](https://gitlab.archlinux.org/pacman/pacman-contrib/-/merge_requests/64)

#### Archlinux-Contrib

I made several contributions to archlinux-contrib, such as:

- [release: Update the release process](https://github.com/archlinux/contrib/pull/96)
- [`rebuild-todo`: Add support for importing OpenPGP keys for packages source verification into the user's keyring (including for offloaded builds)](https://github.com/archlinux/contrib/pull/87)
- [`rebuild-todo`: Add support for running builds with `--nocheck`](https://github.com/archlinux/contrib/pull/102)
- [Add `greposcope`: A script for downloading and searching patterns in diffoscope output of unreproducible Arch Linux packages](https://github.com/archlinux/contrib/pull/89)
- [`checkservices`: Update help message to be less confusing](https://github.com/archlinux/contrib/pull/93)
- [`checkservices`: Add support to run `pacdiff` with `--threeway`](https://github.com/archlinux/contrib/pull/100)

### Staff

Together with [felixonmars](https://github.com/felixonmars), we sponsored [integral](https://github.com/Integral-Tech)'s [application to become a Package Maintainer](https://lists.archlinux.org/archives/list/aur-general@lists.archlinux.org/thread/VUSAFZ2LKX6L6WA7OMFSYCIOLB3WMLEM/), which was [accepted](https://lists.archlinux.org/archives/list/aur-general@lists.archlinux.org/message/CEZNF7O7HVCU7UUWH6Z334BE7GJGH52K/).

As mentioned earlier, I also wrote a proposal to add [Mark](https://hegreberg.io/) to our staff as an additional maintainer for our WSL image, which was [accepted](https://archlinux.org/people/support-staff/#mark).

### RFCs

As mentioned earlier, I wrote an RFC about [providing an official WSL image for Arch Linux](https://rfc.archlinux.page/0050-arch-linux-wsl-image/).

### Ports

I (alongside with community and other staff members) collaborated on an *work in progress* [Arch Linux aarch64 community port](https://gitlab.archlinux.org/archlinux/ports/aarch64), which *eventually* aims to be officially supported *at some point*.

See the page for [Arch Linux Ports](https://ports.archlinux.page/) and the one [dedicated to aarch64](https://ports.archlinux.page/aarch64/) for more details.

### Arch Summit Organization

I was a part of the organization committee of the 2025 edition of the Arch Summit (a yearly event during which Arch staff meet, socialize and work on multiple subjects), which was held in Hamburg (Germany) with 37 attendees.

## Reproducible Builds

I dived deeper into the Reproducible Builds efforts and community this year, joining the [Reproducible Summit in Vienna](https://reproducible-builds.org/events/vienna2025/) and making numerous reproducible builds related work / contributions:

As mentioned earlier, I wrote the `greposcope` script (shipped in [archlinux-contrib](https://archlinux.org/packages/extra/any/archlinux-contrib/)), allowing to download `diffoscope` outputs of non-reproducible Arch Linux package and identify specific reproducible builds related issues.

I submitted several upstream and downstream patches in regards to Reproducible Builds, some of them being covered in `reproducible-builds.org`'s [monthly news](https://reproducible-builds.org/news/):

- [February 2025](https://reproducible-builds.org/reports/2025-02/#upstream-patches)
- [March 2025](https://reproducible-builds.org/reports/2025-03/#upstream-patches)
- [June 2025](https://reproducible-builds.org/reports/2025-06/#upstream-patches)
- [July 2025](https://reproducible-builds.org/reports/2025-07/#upstream-patches)
- [August 2025](https://reproducible-builds.org/reports/2025-08/#upstream-patches)
- [October 2025](https://reproducible-builds.org/reports/2025-10/#upstream-patches)

Together with [Mark](https://hegreberg.io/), we worked at making the Arch Linux WSL image bit-for-bit reproducible:

- [Merge request to add a dedicated CI stage to automatically test the WSL image reproducibility status](https://gitlab.archlinux.org/archlinux/archlinux-wsl/-/merge_requests/74)
- [Merge request to implement the required changes to make the WSL image fully reproducible](https://gitlab.archlinux.org/archlinux/archlinux-wsl/-/merge_requests/76)
- This was covered both in the [Arch Dev Public Mailing List](https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/XDF2IIWNCZZR6KABH2OGSN7AVL7BBX25/) and the [Reproducible Builds Mailing List](https://lists.reproducible-builds.org/pipermail/rb-general/2025-December/003975.html), as well as in the `reproducible-builds.org`'s [December 2025 monthly news](https://reproducible-builds.org/reports/2025-12/#distribution-work)
- I also wrote [a blog post on the subject](https://antiz.fr/blog/the-archlinux-wsl-image-is-now-reproducible/), including more details
- We intend to take advantage of our discoveries and achievement on that matter to work toward a bit-for-bit reproducible [Arch Linux Docker image](https://gitlab.archlinux.org/archlinux/archlinux-docker) in the near future

I joined a work group to move the git hosting for the Reproducible Builds website from [Debian's GitLab / Salsa instance](https://salsa.debian.org/reproducible-builds/reproducible-website) to [Codeberg](https://codeberg.org/reproducible-builds/reproducible-website) (note that, I'm the time I'm writing these lines, the migration is still a work in progress and hasn't fully been done yet).

## Alpine Linux

### Packaging

I pushed 47 commits to Alpine Linux [aports](https://gitlab.alpinelinux.org/alpine/aports), most of which being aports (packages) updates.

I also added a total of 8 new aports (packages) to Alpine Linux repositories:

- [sshs](https://pkgs.alpinelinux.org/packages?name=sshs)
- [typobuster](https://pkgs.alpinelinux.org/packages?name=typobuster)
- [nwg-look](https://pkgs.alpinelinux.org/packages?name=nwg-look)
- [prometheus-fastly-exporter](https://pkgs.alpinelinux.org/packages?name=prometheus-fastly-exporter)
- [wl-clip-persist](https://pkgs.alpinelinux.org/packages?name=wl-clip-persist)
- [syd-tui](https://pkgs.alpinelinux.org/packages?name=syd-tui)
- [pandora_box](https://pkgs.alpinelinux.org/packages?name=pandora_box)
- [wlr-sunclock](https://pkgs.alpinelinux.org/packages?name=wlr-sunclock)

### Tooling

I opened 3 merge request to `abuild` (Alpine Linux build tools) to submit some fixes and improvements to the `abump` script:

- [Fix a typo in the man page](https://gitlab.alpinelinux.org/alpine/abuild/-/merge_requests/479)
- [Add support to extend the resulted commit message](https://gitlab.alpinelinux.org/alpine/abuild/-/merge_requests/477)
- [Add support to push the resulted commit](https://gitlab.alpinelinux.org/alpine/abuild/-/merge_requests/478)
- [Add support to build in a clean chroot via `abuild rootbld`](https://gitlab.alpinelinux.org/alpine/abuild/-/merge_requests/476) (but I ended up closing it as a duplicated of [this merge request](https://gitlab.alpinelinux.org/alpine/abuild/-/merge_requests/468), which I somehow missed :face_with_peeking_eye:)

As mentioned earlier, I also added [atools-go](https://gitlab.alpinelinux.org/alpine/infra/atools-go) to the [Arch Linux repository](https://archlinux.org/packages/extra/x86_64/atools-go).

## Arch-Update

Arch-Update got 49 new [releases](https://github.com/Antiz96/arch-update/releases) in 2025, 19 new [contributors](https://github.com/Antiz96/arch-update/graphs/contributors) and a lot of new features, including (but not limited to):

- A new shiny icon set
- A dropdown submenu for each package sources (All, Package, AUR, Flatpak) in the systay applet right-click menu
- Support for disabling desktop notifications, AUR support and Flatpak support from the configuration file
- A new `-s / --services` option to check for services requiring a post upgrade restart at any time, outside of the main "system upgrade" function
- New click actions in desktop notifications allowing to directly run Arch-Update or dismiss the notification
- A new feature opening the upstream project URL of a package pending for update in a web browser when its entry is clicked from the systray applet right-click menu (allowing one to easily check release notes, for instance)
- Support for `sudo-rs` (in addition of `sudo`, `doas` & `run0`)
- Overall improvements regarding the Flatpak support / integration
- Ease translation maintenance and contributions
- New translations, including:
   - Chinese (simplified)
   - Chinese (traditional)
   - Hungarian
   - German
   - Brazilian
   - Spanish
   - Russian

Arch-Update was also forked & adopted by [CachyOS](https://cachyos.org/) as [Cachy-Update](https://github.com/CachyOS/cachy-update/tree/main)! :rocket:  
CachyOS users can enable it in the by checking the `Cachy Update enabled` check box under the `App/Tweaks` menu in the `CachyOS Hello` application. See the `Cachy-Update` entry in CachyOS's ["Updating The System" wiki page](https://wiki.cachyos.org/configuration/post_install_setup/#updating-the-system) for more details.

## Other

I attended to some FOSS related events:

- [FOSDEM](https://archive.fosdem.org/2025/)
- Arch Summit
- [Reproducible Build Summit](https://reproducible-builds.org/events/vienna2025/)

I wrote 2 blog posts:

- [FOSS Recap 2024](https://antiz.fr/blog/foss-recap-2024/)
- [Arch Linux Now Has an Official WSL Image](https://antiz.fr/blog/archlinux-official-wsl-image/)
- [The Arch Linux WSL Image Is Now Reproducible](https://antiz.fr/blog/the-archlinux-wsl-image-is-now-reproducible/)

I [submitted a talk](https://pretalx.fosdem.org/fosdem-2026/talk/review/DLVABWSFKHNWBF7NYCKMJ3UVSXHNLSQG) for [FOSDEM 2026](https://fosdem.org/2026/), which was accepted! :partying_face: :tada:

I installed [postmarketOS](https://postmarketos.org/) on a Samsung Galaxy S9+ and I also got 2 [pinetime](https://pine64.org/devices/pinetime/), can't wait to play around and hack on those! :sunglasses:

---

That's it!

2025 was a pretty busy year and I'm once again very happy & proud about everything I had the chance to work on & achieve this year! :smiley:

I'd like to conclude once again by thanking every awesome people I had the chance to meet, spend some time and work with this year. The above accomplishments probably wouldn't be a thing without them! :pray:
Also, happy new year everyone! :hugs:

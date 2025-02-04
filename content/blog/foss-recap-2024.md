---
title: "FOSS Recap 2024"
date: 2025-01-03T18:40:00+02:00
draft: false
---

Fellow Arch Linux mate [kpcyrd](https://github.com/kpcyrd) recently published a ["2024 recap" blog post](https://vulns.xyz/2024/12/2024-wrapped/) which (in addition of being a really cool, interesting and impressive read) inspired me to write my own.

So here is a recap of all the noticeable FOSS related stuff I had the chance to work on & achieve in 2024. :smile:

## Arch Linux

### Packaging

- I pushed a total of 1653 packages to Arch Linux repositories.

   - Most of which being packages updates (including some stack updates, like [XFCE 4.20](https://archlinux.org/todo/xfce-420-update/)).
   - The top five packages being [python-sentry_sdk](https://sentry.io/for/python/) (49), [jenkins](https://www.jenkins.io/) (53), [fastfetch](https://github.com/fastfetch-cli/fastfetch) (57), [hugo](https://gohugo.io/) (58) & [limine](https://limine-bootloader.org/) (63).

- I reworked / improved a few packages stacks, most notably the [Mate](https://archlinux.org/todo/general-mate-packages-rework/) & [XFCE](https://archlinux.org/todo/general-xfce-packages-rework/) ones.

- I added a few packages stacks to the [extra] repository, most notably some [XFCE related packages](https://fosstodon.org/@Antiz/113175508877546208) and the [nwg-shell packages](https://github.com/nwg-piotr/nwg-shell/discussions/375).

- I added Alpine Linux packaging tooling to the Arch Linux [extra] repository, [allowing to maintain Alpine packages directly from an Arch system](https://antiz.fr/blog/maintaining-and-building-alpine-packages-from-arch-linux/).

### Testing Team

- Together with [gromit](https://github.com/christian-heusel), we published a *successful* [call for participation](https://lists.archlinux.org/archives/list/arch-general@lists.archlinux.org/message/PHG5Z2PZHUYYZDAJG634L77N7A5TUTY4/) to the Arch Linux testing team.

- Together with [gromit](https://github.com/christian-heusel), we created around 120 new testing accounts.

- Aside from the usual Arch Linux testing, I helped testing some kernel and systemd pre-releases (respectively packaged by [gromit](https://github.com/christian-heusel) and [eworm](https://github.com/eworm-de)).

   - That helped discovering critical bugs upfront. For instance, I was able to [report a bug leading to an unbootable system in `mkinitcpio`](https://gitlab.archlinux.org/archlinux/mkinitcpio/mkinitcpio/-/issues/270) due to an incoming change in `systemd` v256 (which I discovered when testing `systemd` v256-rc2).

### Infrastructure

- I made a few contributions to the Arch Linux infrastructure:

   - [Switch to the `http2` directive in `nginx` configurations](https://gitlab.archlinux.org/archlinux/infrastructure/-/merge_requests/833).
   - [Fix some inconsistencies in ansible playbooks / roles](https://gitlab.archlinux.org/archlinux/infrastructure/-/merge_requests/899).

### Increasing the default vm.max_map_count value

- After being inspired by several other Linux distributions doing the same change, I wrote a proposal to [increase the default `vm.max_map_count` value in Arch Linux](https://lists.archlinux.org/archives/list/arch-dev-public@lists.archlinux.org/thread/5GU7ZUFI25T2IRXIQ62YYERQKIPE3U6E/). The change was accepted and [implemented within the `filesystem` package](https://gitlab.archlinux.org/archlinux/packaging/packages/filesystem/-/commit/ae65041b78700196e07c2b626b5c9b226014827c). A related [Arch News](https://archlinux.org/news/increasing-the-default-vmmax_map_count-value/) has been published.

### Devtools / pkgctl (Arch Linux packaging tooling)

- I got the following features merged and included in `pkgctl`:

   - [Make `pkgctl version upgrade` also upgrade checksum entries in PKGBUILDs](https://gitlab.archlinux.org/archlinux/devtools/-/merge_requests/236).
   - [Introduce the `pkgctl repo clean` command](https://gitlab.archlinux.org/archlinux/devtools/-/merge_requests/250).
   - [Add a warning in `pkgctl release` if the nvchecker integration is not set](https://gitlab.archlinux.org/archlinux/devtools/-/merge_requests/275).

- I got the following features proposition opened:

   - [Introduce the `--version-upgrade` argument to `pkgctl build`](https://gitlab.archlinux.org/archlinux/devtools/-/merge_requests/261).
   - [Add a visual diff & confirmation before applying changes when running `pkgctl version upgrade`](https://gitlab.archlinux.org/archlinux/devtools/-/merge_requests/274).
   - [Ship the 0BSD LICENSE file for packages sources within the `devtools` package and have `pkgctl release` fail if it isn't present in the repo when releasing new packages updates](https://gitlab.archlinux.org/archlinux/devtools/-/merge_requests/288).

### Pacman-Contrib

- I made [several contributions](https://gitlab.archlinux.org/pacman/pacman-contrib/-/merge_requests?author_username=antiz&scope=all&sort=merged_at_desc&state=merged) to pacman-contrib, most notably:

   - [Add the `-c / --change` option to `checkupdates` which only watch for new available updates since the last run](https://gitlab.archlinux.org/pacman/pacman-contrib/-/merge_requests/40).
   - [Preserve colored output when printing the list of pending updates with `checkupdates`](https://gitlab.archlinux.org/pacman/pacman-contrib/-/merge_requests/42).
   - [Add support for SPDX license identifier in PKGBUILD vim syntax highlighting](https://gitlab.archlinux.org/pacman/pacman-contrib/-/merge_requests/46).

### Archlinux-Contrib

- I made [several contributions](https://github.com/archlinux/contrib/commits?author=Antiz96) to the archlinux-contrib scripts, most notably:

   - [Various improvements to the `rebuild-todo` output and default behavior](https://github.com/archlinux/contrib/pull/74).
   - [Add support for offloaded builds in `rebuild-todo` (via `pkgctl --offload`)](https://github.com/archlinux/contrib/pull/75).
   - [Add a configurable list of ignored services to `checkservices`](https://github.com/archlinux/contrib/pull/78).

### Arch Summit Organization

- I was a part of the organization committee of the 2024 edition of the Arch Summit (a yearly event during which Arch staff meet, socialize and work on multiple subjects), which was held in Hamburg (Germany) with 32 attendees.

### Nvchecker PoC

- Together with [klausenbusk](https://github.com/klausenbusk) and [gromit](https://github.com/christian-heusel), we worked on a proof of concept that aims to streamline and automate new upstream releases tracking for Arch Linux package maintainers. This is still a work in progress, see the [presentation made during the Arch Summit](https://pkgbuild.com/~antiz/presentations/Nvchecker_PoC/) for more details.

### RFCs

- Together with [dvzrv](https://github.com/dvzrv/), we wrote an RFC about [streamlining the RFC writing process](https://rfc.archlinux.page/0043-streamline-the-rfc-writing-process/) which got accepted and implemented.

- Together with [dvzrv](https://github.com/dvzrv/), we wrote an RFC which aims to [establish some standards for our package sources and digital signatures](https://gitlab.archlinux.org/archlinux/rfcs/-/merge_requests/46). This RFC was shared to the [distribution mailing list](https://lore.kernel.org/distributions/04612379-9624-4284-a0cf-6242ceb2d20a@archlinux.org/T/#u) and is still in the "discussion" phase.

### Mediator role

- Together with [gromit](https://github.com/christian-heusel) and [serebit](https://github.com/serebit/), we were elected as [mediators](https://rfc.archlinux.page/0009-mediation-program/) for a period of two years.

### Staff

- Together with [rgacogne](https://github.com/rgacogne), we sponsored [mh4ckt3mh4ckt1c4s](https://github.com/mh4ckt3mh4ckt1c4s)'s [application to become a Package Maintainer](https://lists.archlinux.org/archives/list/aur-general@lists.archlinux.org/message/YBWSCOKHQ4OX64M7WQOUKXDHLROVH5WZ/) which was [accepted](https://lists.archlinux.org/archives/list/aur-general@lists.archlinux.org/message/PDYDEFMJEHAYEVZHLY2WA277LODRRED4/).

### AUR moderation

- I, more or less actively, participated to the [AUR](https://wiki.archlinux.org/title/Arch_User_Repository) moderation throughout the whole year.

## Alpine Linux

### Packaging

- I pushed 34 commits to Alpine's [aports](https://gitlab.alpinelinux.org/alpine/aports).

   - Most of which being aports (packages) updates.
   - Still a total of 7 new aports (packages) pushed to Alpine's repositories.

- I raised some [packaging related issues](https://gitlab.alpinelinux.org/alpine/aports/-/issues/16316).

## Arch-Update

- Arch-Update got 34 new [releases](https://github.com/Antiz96/arch-update/releases) in 2024 (including 2 major ones), 15 new [contributors](https://github.com/Antiz96/arch-update/graphs/contributors) and a lot of new features, most notably:

   - Add support for colored output.
   - Add support for an `arch-update.conf` configuration file (allowing to enable / disable and modify certain options).
   - Improvements to the way Arch news are fetched and displayed to users.
   - Add basic shell completions for `bash`, `zsh` and `fish`.
   - Add a clickable and dynamic systray applet allowing to quickly see the list of pending updates, run an update check and run `arch-update`.
   - Add support for identifying `systemd` services that need a post-upgrade restart and allow users to do so (in addition of checking pending kernel upgrade requiring a reboot).
   - Add support for `run0` (in addition of `sudo` & `doas`).
   - Add support for `pikaur` (in addition of `yay` & `paru`).
   - And a lot more...

## Other

- I attended to some FOSS related events:

   - FOSDEM.
   - Arch Summit.
   - Local event about DevOps & Infrastructure, during which I gave a talk about `pkgctl` *(no recording unfortunately)*.

- I wrote 2 [blog posts](https://antiz.fr/blog/).

- I donated a few bucks to [some people](https://github.com/Antiz96?tab=sponsoring) I value the work and have / had the privilege to collaborate with.

That's it!

Obviously, the point isn't to "show off" or anything, but writing this recap was actually quite fun and I'm personally very happy & proud about everything I had the chance to work on & achieve this year!  
I actually intend to write a similar retrospective for the years to come. I have a few objectives set for 2025 and some work started already. :smiley:

I'd like to conclude by thanking everybody who contributed one way or another to the above accomplishments and to my work in general!  
Also, happy new year everyone! :tada:

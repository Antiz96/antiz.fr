---
title: "The Arch Linux WSL image is now reproducible"
date: 2025-12-17T20:00:00+02:00
draft: false
---

I'm happy to share a great milestone I worked on and that we've been able to recently reach: The [Arch Linux WSL image](https://gitlab.archlinux.org/archlinux/archlinux-wsl) is now [bit-for-bit reproducible](https://reproducible-builds.org/)!

I attended this year's [Reproducible Builds Summit in Vienna](https://reproducible-builds.org/events/vienna2025/) during which I had the occasion to discuss with Holger Levsen *(a.k.a. h01ger - Debian member / contributor and part of the Reproducible Build Core team)* about reproducible `releng` images (like OCI images, ISOs, etc...). He shared really interesting insights and relevant advice to me on that front, and I decided to give it a try with [the Arch Linux WSL image I worked on earlier this year](https://antiz.fr/blog/archlinux-official-wsl-image/).

I therefore started working on this with [Mark Hegreberg](https://hegreberg.io/)'s assistance (who is the co-maintainer for the WSL image).  
Here are the issues we faced and the fixes we applied:

## Installing packages from an archived repo snapshot

To ensure that the same exact versions / releases of packages get installed in the image across builds, we defined an archived snapshot of our repositories (via our <https://archive.archlinux.org> - [Arch Linux Archive](https://wiki.archlinux.org/title/Arch_Linux_Archive) service) as the source to download packages during the build.  
The chosen date of the daily archived repo snapshot is based against the version of the built image (which is also date based). The same date is also used as the `[SOURCE_DATE_EPOCH](https://reproducible-builds.org/docs/source-date-epoch/)` (SDE) timestamp (see below points for usage).

## Normalize filesystem `mtime` with `SOURCE_DATE_EPOCH`

With SDE now set in our build script, we normalize files modification times (`mtime`) inside the built root filesystem (rootFS) used as the image base against it as a post-build operation:

```
find "$BUILDDIR" -exec touch --no-dereference --date="@$SOURCE_DATE_EPOCH" {} +
```

This avoids non-deterministic timestamps stored in the rootFS, such as:

```text
│ ├── file list
│ │ @@ -1,582 +1,582 @@
│ │ -drwxr-xr-x   0        0        0        0 2025-12-15 17:01:30.944371 ./var/
│ │ +drwxr-xr-x   0        0        0        0 2025-12-15 17:03:31.247635 ./var/
```

## Get rid of Pacman logs during build (because of timestamps recording)

Pacman records each operation with its associated timestamp in its log file (`/var/log/pacman.log`).  
Since we don't particularly need Pacman logs to be recorded during the image build, we simply redirected them to `/dev/null/`:

```bash
pacman \
    [...]
    --logfile /dev/null \
    [...]
```

This avoids non-deterministic timestamps stored in Pacman's log file, such as:

```text
│ ├── ./var/log/pacman.log
│ │ @@ -1,125 +1,125 @@
│ │ -[2025-12-14T00:11:43+0000] [ALPM] installed filesystem (2025.10.12-1)
│ │ +[2025-12-14T00:13:28+0000] [ALPM] installed filesystem (2025.10.12-1)
```

## Normalize packages' installation date in Pacman's local package DB 

Pacman records packages' installation date.  
Fortunately, [Jelle van der Waa](https://vdwaa.nl/) recently brought [support in Pacman for honoring SDE on that front](https://gitlab.archlinux.org/pacman/pacman/-/commit/f4bdb77470528019aaba4d8b). With the related commit being included in our latest pacman package release, simply exporting SDE in our build script was enough to normalize packages' installation date in Pacman's local package database.

This avoid non-deterministic timestamps in the metadata included in the local package database, such as:

```text
│ ├── ./var/lib/pacman/local/iana-etc-20251114-1/desc
│ │ @@ -16,15 +16,15 @@
│ │  %ARCH%
│ │  any
│ │
│ │  %BUILDDATE%
│ │  1763578803
│ │
│ │  %INSTALLDATE%
│ │ **-1765650975**
│ │ **+1765651076**
│ │
│ │  %PACKAGER%
│ │  Jelle van der Waa <jelle@archlinux.org>
│ │
│ │  %SIZE%
│ │  4198552
```

## Delete Pacman keyring

Pacman OpenPGP keys (generated with `pacman-key`) are obviously always different across builds.  
Fortunately, WSL has a built-in ["oobe" (Out Of the Box Experience) mechanism](https://learn.microsoft.com/en-us/windows/wsl/build-custom-distro#add-the-wsl-distribution-configuration-file) which allows to automatically run a script at the first boot of the image. We therefore took advantage of this mechanism to completely delete the Pacman's keyring as a post-build operation and automatically recreate it at the first boot of the image via the "oobe" script (by running `pacman-key --init && pacman-key --populate archlinux` from it).

This avoid non-deterministic data in the Pacman keyring, such as:

```text
│ ├── ./etc/pacman.d/gnupg/pubring.gpg
│ │┄ xxd not available in path. Falling back to Python hexlify.
│ │ @@ -1,45 +1,45 @@
│ │ -99020d0469408f04011000b9a3a76a44cdaaa630398dd297705ffb5b9906dca5
[...]
```

```text
│ ├── ./etc/pacman.d/gnupg/tofu.db
│ │ ├── sqlite3 {} .dump
│ │ │ @@ -7,13 +7,13 @@
│ │ │    fingerprint TEXT, email TEXT, user_id TEXT, time INTEGER,
│ │ │    policy INTEGER CHECK (policy in (1, 2, 3, 4, 5)),
│ │ │    conflict STRING, effective_policy INTEGER DEFAULT 0 CHECK (effective_policy in (0, 1, 2, 3, 4, 5)),
│ │ │    unique (fingerprint, email));
│ │ │  CREATE TABLE signatures  (binding INTEGER NOT NULL, sig_digest TEXT,  origin TEXT, sig_time INTEGER, time INTEGER,  primary key (binding, sig_digest, origin));
│ │ │  CREATE TABLE encryptions (binding INTEGER NOT NULL,  time INTEGER);
│ │ │  CREATE TABLE ultimately_trusted_keys (keyid);
│ │ │ -INSERT INTO ultimately_trusted_keys VALUES('0AE7DE748E9EC852');
│ │ │ +INSERT INTO ultimately_trusted_keys VALUES('3653096D0D4F06F3');
│ │ │  CREATE INDEX bindings_fingerprint_email
│ │ │   on bindings (fingerprint, email);
│ │ │  CREATE INDEX bindings_email on bindings (email);
│ │ │  CREATE INDEX encryptions_binding on encryptions (binding);
│ │ │  COMMIT;
```

```text
│ ├── ./etc/pacman.d/gnupg/trustdb.gpg
│ │┄ xxd not available in path. Falling back to Python hexlify.
│ │ @@ -1,46 +1,46 @@
│ │ -01677067030301050102000069408f07697c67e1000000000000000000000000
│ │ +01677067030301050102000069408f76697c67e1000000000000000000000000
[...]
```

## Normalize tar archives `mtime` (with `SOURCE_DATE_EPOCH`) and ordering

The rootFS for the WSL image is archived with `tar`, to which we added a few options to normalize modification times (against SDE) as well as ordering to avoid non-determinism on those fronts:

```bash
tar \
    [...]
    --mtime="@$SOURCE_DATE_EPOCH" \
    --clamp-mtime \
    --sort=name \
    [...]
```

## Delete tar archives `atime` & `ctime`

Finally, we got rid of tar's access times (`atime`) & creation times `ctime`:

```bash
tar \
    [...]
    --pax-option=delete=atime,delete=ctime \
    [...]
```

This avoids non-deterministic timestamps in the archive's metadata, such as:

```text
--- /builds/archlinux/archlinux-wsl/workdir/output/archlinux-2025.12.16.154822.wsl
+++ /builds/archlinux/archlinux-wsl/repro/output/archlinux-2025.12.16.154822.wsl
├── archlinux-2025.12.16.154822.wsl-content
│┄ xxd not available in path. Falling back to Python hexlify.
│ @@ -1,25 +1,25 @@
│  2e2f506178486561646572732f2e000000000000000000000000000000000000
│  0000000000000000000000000000000000000000000000000000000000000000
│  0000000000000000000000000000000000000000000000000000000000000000
│  0000000030303030363434003030303030303000303030303030300030303030
│ -3030303030363100313531323031323034303000303130333333002078000000
│ +3030303030363200313531323031323034303000303130333334002078000000
```

## Conclusion

If you want to see more details about the actual implementation of that work, you can take a look at the related merge requests:

- <https://gitlab.archlinux.org/archlinux/archlinux-wsl/-/merge_requests/74>: Addition of a dedicated CI stage to test the image reproducibility status
- <https://gitlab.archlinux.org/archlinux/archlinux-wsl/-/merge_requests/76>: Implementation of the above fixes to make the image reproducible

A follow up good news is that, since it's built in a similar way, most of those fixes should also apply to our [Docker image](https://gitlab.archlinux.org/archlinux/archlinux-docker) ; with the exception of the [Pacman keyring related issue](#delete-pacman-keyring) which will need to be dealt with differently, *somehow...* (since, as far as I know, OCIi / Docker images doesn't have any built-in / straightforward mechanism to run a script or commands automatically at first boot, similar to the WSL "oobe" mechanism).

In any case, I particularly happy about this achievement which represents a meaningful milestone regarding our global "reproducible builds" related efforts and is encouraging for future related work on our other releng images!

I once again would like to thank Holger for his precious tips & advice, and Mark for his valuable help with some of the issues we faced as well as testing.

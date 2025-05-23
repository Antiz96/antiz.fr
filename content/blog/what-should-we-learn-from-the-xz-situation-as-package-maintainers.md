---
title: "What should we learn from the XZ situation as Package Maintainers?"
date: 2024-04-03T14:56:04+02:00
draft: false
---

## Context

As you probably already know by now, a backdoor / security vulnerability has been [recently discovered in xz](https://www.openwall.com/lists/oss-security/2024/03/29/4). In this article, I won’t cover the technical aspect or the potential consequences of it (it has already been done by people way more knowledgeable than am I on that matter) but I will expose what I think we should learn from it, from a packaging stand point.

To sum up the situation briefly (as a context for the rest of this article), the xz (co-)maintainer himself introduced a [backdoor](https://en.wikipedia.org/wiki/Backdoor_(computing)) in the code, obfuscated by the fact that the malicious code (or at least parts of it) was only present in the *custom* made tarball (basically an archive) of the sources (but not present in the "raw" sources hosted in the git repo itself). The said tarball / archive was signed with his OpenPGP key and manually uploaded as an asset / artifact of the releases, which package maintainers used as a source for their package.

## Why relying on a custom made tarball of the sources over the sources themselves in the first place?

Firstly, depending on how a software is developed and what it relies / depends on, the *raw* sources might not be usable *as is*. It happens that some software’s sources require additional prerequisites in order to be properly compiled and packaged (for instance projects that relies on [autotools](https://en.wikipedia.org/wiki/GNU_Autotools) to "configure" sources or [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to pull required third party dependencies). As a matter of convenience, it is quite common for upstream developers to provide custom made tarballs of their software's sources with those pre-required additional steps already done, allowing package maintainers to get sources usable as is.

The other reason why package maintainers often rely on such custom made tarballs over “raw” sources is because it’s quite common for upstream developers to not ~~bother integrating~~ integrate [GPG signing](https://www.gnupg.org/gph/en/manual/x135.html) in their development and release workflows (basically sign their commits and tags) but only sign these custom made tarballs instead (probably as a way to “promote” them over raw sources regarding the previous point about convenience). A GPG signed source tarball represents an additional level of trust for package maintainers as it constitutes a way to proves the identity of the person that generated the said tarball (or rather the identity of the person that signed it actually, hoping that it means that they validate the tarball's content), but also that it hasn’t been tampered with after being signed.

## As package maintainers, should we prefer a more transparent source over a convenient one?

While these custom made tarballs are often more convenient for us package maintainers (as explained above), they are also less transparent by nature. Indeed, it's way harder (and more involved) to review and audit a custom made tarball compared to a publicly and easily accessible online git repo. And identifying differences in the content of the tarball compared to the content of the “raw” sources is not enough on its own, as this is often actually expected (since these custom made tarballs usually include the prerequisites needed to properly compile & package the software compared to the “raw” sources).

It’s undeniable that if the xz malicious code was present in the “raw” sources themselves, it would have been detected way faster and more easily (which is why it was only injected in the custom made tarball as a way to obfuscate it). My personal take on that is, *when possible,* we should prefer using a more transparent source (over a more convenient one), which is more trustworthy.

## What about the GPG signature, though?

As said previously in this article, it’s *unfortunately* quite common that upstream developers only sign such custom made tarballs and not commits / tags on the git sources themselves (which is one of the reason package maintainers may choose to base their packages on them).

However, as said in the [first chapter](#context) of this article, it’s important to remind that the *infected* xz tarball **was signed** with the OpenPGP key of the (co-)maintainer of the project himself (who also introduced the backdoor). That raises an important question: "To which degree do we want to trust a GPG signature over anything else (in this particular case, over a more transparent source)?"

While the signature on its own indeed proved the identity of the person that created & signed the tarball (and that it has not been altered since it got signed), it does not guarantee **anything** about the content of the archive in the first place (as the xz situation demonstrated)! When the people themselves are compromised, the signatures worth nothing.

My personal opinion is that, while GPG signatures are important, a transparent source (that does not require any additional effort to be proven reliable & trustworthy when compared to “raw” sources) outweighs it.  
Also, realistically, a GPG signature is only valuable if it is accompanied by a [trust path](https://en.wikipedia.org/wiki/Trusted_path) (such as a [MAINTAINERS file](https://github.com/Nitrokey/pynitrokey/blob/master/MAINTAINERS.md) for instance), in order to ensure that said key identity is expected / trusted to sign release artifacts upstream wise.

## So, what action will I take on my side?

I already started the effort of switching the source of the packages I maintain on Arch Linux side that are currently based on such custom made tarballs to either the auto-generated tarball made by the git platform the code is hosted on, or to the git sources themselves directly (hopefully not at the expense of a GPG signature but I will do it if there's no other choice).

With the recent xz situation, I think that basing our packages on a more transparent source, at the potential cost of [more complex](https://gitlab.archlinux.org/archlinux/packaging/packages/mupdf/-/commit/9e7f9c55b141833762d7951b81c0a574aa9353d9) packages to maintain (as the eventual pre-required steps needed for the source to be usable in the first place would now be on our side) is worth the price.

Additionally, together with David Runge (an Arch Linux Developer), we jointly [wrote an RFC](https://rfc.archlinux.page/0046-upstream-package-sources/) which aims to establish some standards regarding the way we deal with our package sources and digital signatures for them.

## This is not only a downstream / packaging matter but also an upstream one

While package maintainers can make changes on their sides to bring more transparency into their packages and *mitigate* eventual issues, it’s in my opinion very important that all of this turns into a common effort in which upstream developers also adapt their development and release workflow to provide transparent sources / artifacts without skimping on the “trust path” they provide with it.

Ideally, such questions as “should I prefer a signed source or a transparent one?” shouldn’t be a thing. Realistically, only signed VCS objects (e.g. commits or tags) or signed auto-generated source tarballs (accompanied by a trust path regarding signatures) are trustworthy.

So, for eventual upstream developers passing by: If you don’t already, please (:pleading_face:) consider signing tags and / or auto-generated source tarballs (as well as providing a trust path, such as a MAINTAINERS file, ideally) and provide information about additional steps that may be required to make your sources usable without having to rely on custom made source tarballs.  
*(I started [doing this](https://github.com/Antiz96/arch-update/blob/main/MAINTAINERS.md) myself for the few projects I’m developing* :grinning:*).*

Now, I’m aware that things may not be as easy as they might sound, and I assume that there are some potential blockers for specific cases I don’t fully understand nor even be aware of.

All and all, I'm aware that this article as a whole might constitutes a very basic view to a complicated matter, but I’m just exposing what an ideal situation could look like. :smile:

## Conclusion

That’s it!  
Let’s move toward a better (and safer) place together! :v:

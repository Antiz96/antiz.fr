---
title: "What should we learn from the XZ situation as Package Maintainers?"
date: 2024-04-03T14:56:04+02:00
draft: false
---

## Context

As you probably already know by now, a backdoor / security vulnerability has been [recently discovered in xz](https://www.openwall.com/lists/oss-security/2024/03/29/4). In this article, I won’t cover the technical aspect or the potential consequences of it (it has already been done by people way more knowledgeable than am I on that matter) but I will expose what I think we should learn from it, from a packaging stand point.

To sum up the situation briefly (as a context for the rest of this article), the xz (co-)maintainer himself introduced a [backdoor](https://en.wikipedia.org/wiki/Backdoor_(computing)) in the code, obfuscated by the fact that the malicious code (or at least parts of it) was only present in the *custom* made release tarball of the sources, but not present in the "raw" sources hosted in the git repo itself. Said tarball was signed with his OpenPGP key and used by package maintainers used as a source for their package.

## Why relying on a custom made tarball of the sources over the sources themselves in the first place?

Firstly, depending on how a software is developed and what it relies / depends on, the *raw* sources might not be usuable *as-is*. Some software’s sources require additional prerequisites in order to be properly compiled and packaged (for instance projects that relies on [autotools](https://en.wikipedia.org/wiki/GNU_Autotools) to "configure" sources or [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) to pull required third party dependencies). As a matter of convenience, it is quite common for upstream developers to provide custom made tarballs of their software's sources with those pre-required additional steps already done, offering a convienient sources for package maintainers to work with.

The other reason why package maintainers often rely on such custom made tarballs over “raw” sources is because it’s quite common for upstream developers to only cryptographically sign said *custom* made tarballs (e.g. with [GPG](https://www.gnupg.org/gph/en/manual/x135.html)) and not "raw" sources (e.g. git tags or git forge's auto-generated tarballs), probably as a way to “promote” such tarballs over raw sources regarding the previous point about convenience. In such case, the cryptographic signature linked to the source tarball represents an additional level of trust for package maintainers as it provides a way to proves the identity of the person that generated it (or, to be more precise, the identity of the person that *signed* it, hoping that it means that they validate the tarball's content) as well as ensuring that the tarball hasn’t been tampered with after being signed.

## As package maintainers, should we prefer a more transparent source over a convenient one?

While such custom made tarballs are often more convenient to work with for us package maintainers (as explained above), they are also less transparent by nature. Indeed, it's way harder / more involved to review and audit a custom made tarball compared to a publicly and easily accessible online git repo. Also, checking for differences between the content of the tarball and the content of the “raw” sources is not so relevant, as this is often actually expected (since these custom made tarballs usually include the prerequisites needed to properly compile & package the software compared to the “raw” sources).

It’s undeniable that if the `xz` malicious code was introduced in the “raw” / git sources themselves, it would have been detected more easily (which is why it was only injected in the custom made tarball as a way to obfuscate it). My personal take on this is that we should prefer relying a more transparent source (over a more convenient but more opaque one), as it's more trustworthy.

## What about signatures, though?

As said previously in this article, it’s *unfortunately* quite common that upstream developers only cryptographically sign such custom made tarballs and not commits / tags of the git sources themselves (which is one of the reason package maintainers may choose those as the base for their packages).

However, as said in the [first chapter](#context) of this article, it’s important to remind that the *infected* xz tarball **was signed** with the OpenPGP key of the (co-)maintainer of the project himself (who also introduced the backdoor). That raises an important question: "To which degree do we want to trust a cryptographic signature over the rest (in this particular case, over a more transparent source)?"

While the signature on its own indeed proves the identity of the person that created (or signed) the tarball, it does not guarantee **anything** about the content of the tarball in the first place (as the xz situation demonstrated)! When the people themselves are compromised, the signatures worth nothing.

My personal opinion is that, while cryptographical signatures are valuable, a transparent source outweighs it.  
Futhermore, realistically, a cryptographical signature is only fully valuable if it is accompanied by a [trust path](https://en.wikipedia.org/wiki/Trusted_path) (such as a [MAINTAINERS file](https://github.com/Nitrokey/pynitrokey/blob/master/MAINTAINERS.md) for instance), in order to ensure that said key identity is expected / trusted (upstream wise) to sign releases objects.

## So, what action will I take on my side?

I already started the effort of switching the source of the packages I maintain on the Arch Linux side to either rely on the auto-generated tarball produced by the git forge the usptream code is hosted on, or directly on the git tags; hopefully not at the expense of a cryptographical signature (for which I [establish contact with upstream](https://github.com/vsajip/python-gnupg/issues/245) if needed) but I'd rather drop it if a choice has to be made.

With the recent `xz` situation, I think that basing our packages on a more transparent source, at the potential cost of [more complex](https://gitlab.archlinux.org/archlinux/packaging/packages/mupdf/-/commit/9e7f9c55b141833762d7951b81c0a574aa9353d9) packages to maintain (due to the fact that eventual prerequisites needed to work with the source needs to be handled on our side now) is worth the price.

Additionally, together with [David Runge](https://sleepmap.de/) (an Arch Linux Developer), we jointly [wrote an RFC](https://rfc.archlinux.page/0046-upstream-package-sources/) which aims to establish some standards regarding the way we deal with our package sources and criptographic signatures for them.

## This is not only a downstream / packaging matter but also an upstream one

While package maintainers can make changes on their sides to bring more transparency into their packages and *mitigate* potential issues, it’s crucial that all of this turns into a common effort in which upstream developers also adapt their development and release workflow to provide transparent sources / release objects as well as all the necessary information for downstream redistributor / package maintainers to be able to work with them (and, ideally, without skimping on the additional level of trust they can provide them with like criptographical signatures and trust paths).

Ideally, such questions as “should I prefer a signed source or a transparent one?” shouldn’t be a thing. Objectively, only signed VCS objects (e.g. git tags) or signed auto-generated git forge's source tarballs are fully trustworthy.

So, for eventual upstream developers passing by: If you don’t already, please consider signing tags and / or auto-generated source tarballs (as well as providing a trust path for signatures, such as a MAINTAINERS file, ideally) and make sure to provide every information needed to work with your sources in case any additional pre-steps may be required.
*(I started [doing this](https://github.com/Antiz96/arch-update/blob/main/MAINTAINERS.md) myself for the few projects I’m developing* :grinning:*).*

I’m aware that it might not always be as easy as it sounds and, of course, specific cases are a thing. I’m just exposing what the ideal situation would be. :smile:

## Conclusion

That’s it!  
Let’s move toward a better (and safer) place together! :v:

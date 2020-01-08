---
layout: post
title: Apache Wicket 7.16.0 released
---
The Apache Wicket PMC is proud to announce Apache Wicket 7.16.0!

Apache Wicket is an open source Java component oriented web application
framework that powers thousands of web applications and web sites for
governments, stores, universities, cities, banks, email providers, and
more. You can find more about Apache Wicket at https://wicket.apache.org

This release marks another minor release of Wicket 7. We
use semantic versioning for the development of Wicket, and as such no
API breaks are present breaks are present in this release compared to
7.0.0.

<OPTIONAL> New and noteworthy
<OPTIONAL> ------------------
<OPTIONAL>
Using this release
------------------

With Apache Maven update your dependency to (and don't forget to
update any other dependencies on Wicket projects to the same version):

{% highlight xml%}
<dependency>
    <groupId>org.apache.wicket</groupId>
    <artifactId>wicket-core</artifactId>
    <version>7.16.0</version>
</dependency>
{% endhighlight%}

Or download and build the distribution yourself, or use our
convenience binary package you can find here:

 * Download: http://wicket.apache.org/start/wicket-7.x.html#manually

<!--more-->

Upgrading from earlier versions
-------------------------------

If you upgrade from 7.y.z this release is a drop in replacement. If
you come from a version prior to 7.0.0, please read our Wicket 7
migration guide found at

 * http://s.apache.org/wicket7migrate

Have fun!

— The Wicket team


========================================================================

    The signatures for the source release artefacts:

    
Signature for apache-wicket-7.16.0.zip:

<div class='highlight'><pre>
-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE0a6YZHC1pJw+aieyh48B+qjTVuEFAl4QoiAACgkQh48B+qjT
VuEcMg//V/HLgAeFzSyvdj+GSvtq3r8aZgmTh+TLJ5zMiFVyu9hfPmh7T5V3EY3+
Qn+CHdXh3kD/G6jLYAhEUw9iqU5duxFqBqXRzdTtmIwxK2VTdfI2iJhyTnmKGXS8
vaUV8cjC8YMXtEjkibQGErbbV5jXRwohF029F7Zck1A7+U0PN58K0feMz7mXMIXT
Gxl3dC0wXYa1SptctjeZSAxVCR4QZc/txIvCah00LlV0GDY24XMfxovd6oDsb6+W
+VjuNbAmleV7D534IPTh9VE9ObcHwqXi7JbPk5f/uL3BUTis+baZp0e+3kGpY4Il
uLdUcGF4juDjc+lY1phxoPbni4XnHfEkDQLez40/jlMWO3Vx7BUkCFVolFOC5hAa
8hmFURXSytXXDD4f3/yCMZr95Sdh4SP+FeQtryckE7K08lrblOHaQJn/dF08tcVN
QOrFJ5k1LfDk3biB7U8bzGQJ1py0UctKyDzw15QY3FQb/stypn/brs7hMAXLQbZp
knu9AhuTGvu2Q2kqqn78UwG+zq6hcZBVR4+XGkX9KHMxN3K16nKBnkdv2v6bLt1E
Qyw1lBZj20Uo2dkpidyN6esDzX8j8US8c0CNylak/4xA1er7+MvkiAQhVjDlvqTH
LbIO5Pyszlq9n1Vw6RSZjbWnhZL/Tv7CIux4zsdTLYMbaohZPZM=
=9BT0
-----END PGP SIGNATURE-----
</pre></div>

    
Signature for apache-wicket-7.16.0.tar.gz:

<div class='highlight'><pre>
-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE0a6YZHC1pJw+aieyh48B+qjTVuEFAl4QoiAACgkQh48B+qjT
VuFEoQ//VxsVwquHRi4ZAHQK6KOlEmqRvF1DGqu9Eawqb8SQGNiqAmkWEjkfIaG0
gBwpZUr1g0CY2F3NbPQMuPaokIn41QIGoeKCMapCYtzI8NjeEHEBHydDqs+9vHLw
mbmuZdZeFmrUFH1DhhuBZY6XgczvlTKxw17HW6OBkqLqE0G6WTFVjMDTlFnXPqOd
7IdXmIfSynxCSORzDvwjZUrtRSrrc/6T10kiaIDNNoBkwqBva2Dnk20i6yLgwoZW
PBZyjosQhKj0FeP8RfD30S51MfJ3QMflY9iOYdN3oGxxNcAxQCHZXkzZA/dqvLcj
TB1VJtmJ/O2wuASNDfa85FmbH7B+sFM4yp6rYsTsWLcWFLXm6y2r8iBER9AD04P8
vUbqh4s7x8wWHX4T6n5xMq8nlSyoMokAEu+sEA2vkd32a1qrUSnKhI0qJK8Xlgz1
DCeca2txqWTTr2qmK9xydBEcNUo9uNDS6Z6YpOY3AX3P9oA7TXBKBAyzRvZ/I5aN
iZUVgYwvGPH7VfIF7YR3fRBvik2LwpfAq1kE19WZugKTCXWihgjHDKfZKxpnzOL+
p5+WcEnf6NzsHSzoaAU/az0Wvem4yCj2B49uZUeMZfrgRoLt/DWB4mOBj/uhb+8K
GkN/vehn3d9ZHJ76ImhkV1EGGgfAkSq1O7nHE2E2NxrZOVe8Ueo=
=3rL9
-----END PGP SIGNATURE-----
</pre></div>

    
========================================================================

### This Release

#### CHANGELOG for 7.16.0:
    
##### Bug

 * [WICKET-6531] - Crash in Unsafe.getObject when running on the J9 VM
 * [WICKET-6704] - JavaSerializer.serialize causes the JVM crash !
 * [WICKET-6706] - Websocket Endpoint logs exception when user leaves page
 * [WICKET-6707] - Property setter parameter type is assumed to be equal to getter return type
 * [WICKET-6708] - FormComponent should read only the GET/POST parameters of the request, not both


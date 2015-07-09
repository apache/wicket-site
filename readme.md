Wicket Site
===========

This is a project for tracking a new design for the Apache Wicket website. The
site is generated to static html using
[jekyll](http://github.com/mojombo/jekyll).

If you want to see how it might look in the future, see the file
[wicketsite5.pdf](http://github.com/apache/wicket-site/blob/asf-site/_design/wicketsite5.pdf
"Design document")

If you want to see how it looks now, see the [generated
markup](http://github.com/dashorst/wicket-site/raw/master/_site/index.html).

Running the site
----------------

Use (after installing jekyll) the following command to run jekyll in a server
mode:

    $ ./regenerate.sh

This instructs jekyll to generate new output whenever something changes on
the filesystem, and serve those files to the default port (4000) on your box.

Note that this script restores Subversion (`.svn`) subfolders
inside `_site`, which are erased when Jekyll is generating the content.


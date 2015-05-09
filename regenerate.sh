#!/bin/bash

#workaround script for regenerating the site because jekyll completely wipes _site which causes problems for svn
echo Backing up .svn folders in _site
mkdir _tmp
tar cfT _tmp/archive.tar /dev/null
find _site -name ".svn"|xargs -I{} tar -rf _tmp/archive.tar {}
#jekyll
jekyll build
echo Restoring .svn folders in _site
tar -xf _tmp/archive.tar
rm -rf _tmp


#!/bin/bash
pkg=evil-mark-replace-0.0.6
mkdir $pkg
cp README.org $pkg
cp *.el $pkg
if [[ `uname -s` == *Darwin* ]]; then
   COPYFILE_DISABLE="" tar cvf $pkg.tar $pkg/
else
   tar cvf $pkg.tar $pkg/
fi
rm -rf $pkg/


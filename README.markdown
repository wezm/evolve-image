Evolve Image
============

This is an attempt to implement something like
[http://alteredqualia.com/visualization/evolve/][1] and [http://rogeralsing.com/2008/12/07/genetic-programming-evolution-of-mona-lisa/][2] in Objective-C using just the
GNUStep/Cocoa Foundation Library. Ultimately it is to be multithreaded in an attempt
to evolve an image a quickly as possible, particularly on multi core machines.

  [1]: http://alteredqualia.com/visualization/evolve/
  [2]: http://rogeralsing.com/2008/12/07/genetic-programming-evolution-of-mona-lisa/

Building
--------

Mac OS X

Linux

Windows

Download the following from:
http://www.gtk.org/download-windows.html

* The "Dev" cairo package
* Fontconfig Binaries
* freetype Binaries
* libpng Binaries

Unzip the downloaded files to C:\gtk-libs
E.g. (from within the GNUstep shell)
cd /c
mkdir gtk-libs
cd gtk-libs
unzip /c/Documents\ and\ Settings/wmoore/Desktop/cairo-dev_1.8.0-1_win32.ziz

cairo will try to find libpng13.dll so you will need to copy libpng12-0.dll
I.e.
cd /c/gtk-libs/bin
cp libpng12-0.dll libpng13.dll

To run the executable, it will need to know where to find the libraries. Add
the path to the bin dir to the PATH.

I.e. (from within the GNUstep shell):
export PATH=$PATH:/c/gtk-libs/bin
./obj/EvolveImage

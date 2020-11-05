# Inkscape 0.92 GCode Plugin (Laserengraver)

* copy to InkscapePortable0924\App\Inkscape\share\extensions
* create path > path from object or bitmap
* extension > laserengraver > laser
* save as c:\output\lasercut.nc

## Lasertools (linear infill)

Based on https://github.com/ChrisWag91/Inkscape-Lasertools-Plugin

This extension can generate CNC code for filled areas. This only works for paths with lines and not for curves.

Workaround for text:

* create text object
* path > object to path
* object > ungroup
* extension > modify path > add nodes (10px)
* extension > lasertools > lasertools (0,2mm)

A good way to test the NC GCode is the CAMotics software.

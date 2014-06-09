Readme for ProX and ProXist
===========================



0. License
==========

TBA: license note here



1. Install
==========

TBA eXist installation



2. Changes
==========

2014-05-20

* Added optional <metadata> to <param>.

* Added optional <packages> to <pipeline>.



3. Known Issues
===============

* <option> currently includes <params>, which is probably a mistake.
  This might be removed in a coming version.

* <option> should probably include <metadata>, as should the
  Calabash config elements.

* ProXist requires Jim Fuller's XML Calbash eXist module, that in
  turn requires a calabash.jar that includes fixes for URI
  handling, also by Jim. Neither one is in active development,
  but a Calabash module by Dmitriy Shabanov is, and seems at a
  quick glance to be more feature-complete. ProXist, therefore,
  probably needs to be rewritten for that module.
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



3. Included Files
=================

NOTE: The repository contains a lot more stuff than required for
ProXist, mostly for historical reasons (Balisage and XML Prague
demos) and various tests.

The following is required by ProX:

* relaxng/...

  - processes.rnc
  - package.rnc
  - auxiliary.rnc
  - xproc-cmdline.rnc
  - xproc-pipes.rnc

* xforms/...

  - select-prox.xhtml
  - style-sel.css

* xml/...

  - prox-blueprint.xml (example only)
  - resource-map-template.xml

* xproc/...

  - proxist-wrapper.xml

* xq/...

  - app.xql
  - ch-mode.xq
  - save.xq

* xslt/...

  - generate-prox-resources-map.xsl
  - prox-fix.xsl (URN to URL from resource-map.xml)
  - prox2xq.xsl (converts ProX instance to XQ) 

Please note that the above rely partly on XML document type-specific
files (XProc, XSL) to work, as generating resource maps depends on
the specific document types to be processed.



4. Known Issues
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
  
  

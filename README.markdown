Generating the documentation
============================

Pre-requirements
----------------

- Apache Ant
- Ruby
- PHP 5 (with DOM, PCRE, SPL, and Tokenizer extensions enabled)
- xsltproc

Building the documentation
--------------------------

To build the complete documentation use:

`cd build; ant`

To build only one version of the docs use:

`cd build; ant build-LANG-VERSION` 
f.e.
`cd build; ant build-en-3.6`

Output
------

The html output will be under:

`build/output/VERSION/LANG/index.html`
f.e.
`build/output/3.6/en/index.html`

The generated PDF will be at:

`build/output/VERSION/LANG/phpunit-book.pdf`
f.e.
`build/output/3.6/en/phpunit-book.pdf`




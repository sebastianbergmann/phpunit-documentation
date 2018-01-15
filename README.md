# Building the Documentation

## Requirements

- Apache Ant
- PHP 5 (with DOM, PCRE, SPL, and Tokenizer extensions enabled)
- Ruby
- xsltproc
- libxml2-utils

## Building the Documentation

To build the complete documentation use:

    cd build
    ant

To build only one version of the documentation use:

    cd build
    ant build-LANG-VERSION

for example

    cd build
    ant build-en-4.3

# Output

The generated files will be in `build/output/VERSION/LANG`.

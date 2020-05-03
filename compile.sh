#!/bin/sh
cp -r images/* markdowns/images/
jupyter nbconvert --output-dir=markdowns/ --to markdown notebooks/*.ipynb
mkdocs build

#!/bin/sh
jupyter nbconvert --output-dir=markdowns/ --to markdown notebooks/*.ipynb
mkdocs build

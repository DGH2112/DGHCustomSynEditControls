 DGH Custom SynEdit Controls
=============================

Author:   David Hoyle

Version:  0.9.1

Date:     11 Nov 2018

Web Page: TBC

## Overview

This project contains a number of useful highlighters, forms and utilty functions that can be used in a
project that contains SynEdit controls to make their use easier.

## Use

There are 3 additional highlighters here for Backus-Naur Format grammar (BNF), Markdown files (MD) and
RegEx File (RegEx) a file format I created for regular expressions that can b build with macros for
constructing complex expressions. Also contained in there are forms for editing aSynEdit controls
properties (Editor, Gutter, Behaviour and Highlighter Attributes) and some useful fnuctions for loading
and saving the files to a TMemIniFile.

## Current Limitations

You need a copy (or Git SubModule) of SynEdit 2.1.0 to be able to compile the components or use the other
code. This ises a Git Submodule to a version of SynEdit 2.1.0 which I've added VCL Theming support to.

## Binaries

There are none - you need to compile the components yourself (you will need to amend the projects for
your version of RAD Studio, I used 10.2.3 Tokyo, and amend the Package output path).

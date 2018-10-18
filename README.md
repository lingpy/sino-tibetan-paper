# Data and source code accompanying the paper "Dated language phylogenies shed light on the ancestry of Sino-Tibetan"

## Overview

This repository offers both source code and data for the analyses that were carried out for the paper "Dated language phylogenies shed light on the ancestry of Sino-Tibetan". 

## Software Requirements

We assume that you have a fresh and unbroken python3 installation on your computer. We tested all Python code for versions 3.5 and 3.7. Please contact us if you find that it does not work for any other Python versions. 

We also assume that you have a running version of TraitLab and Beast2 along with the required dependencies installed (see below for further information).


## Preparing Nexus Files from Linguistic Data

Our lexical data is curated with help of the `lexibank` repository for linguistic datasets. To use obtain the data and convert it to the required formats with help of Python scripts, all you have to do is to `cd` into the folder `LexicalData` and type:

```
$ pip install -r pip-requirements.txt
```

Once this has been done, you can then type:

```
$ python to-nexus.py
```

This will use `lingpy` (http://lingpy.org) and the `lexibank` curation code to obtain the data from the repository and convert it to the nexus format. 

If you want to inspect the resulting wordlist of 180 concepts, we recommend to open the file `data/sino-tibetan-sublist.tsv` with help of the EDICTOR tool.

## Phylogenetic Analysis

### TraitLab

See the file `TraitLabFiles/README.md` for instructions on preparation of Nexus files and analysis.

### Beast

To analyse these data in [BEAST2](http://www.beast2.org/), use the files in [the BeastFiles](./BeastFiles) directory. You will need BEAST2 > v2.40, with the [BEASTLabs (v.1.7.1)](https://github.com/BEAST2-Dev/BEASTLabs) and [Sampled Ancestors (v1.1.7)](https://github.com/CompEvol/sampled-ancestors) packages installed.

## Graphics and Plots

We provide the R-code to create the tree plots in the folder `Plots`.

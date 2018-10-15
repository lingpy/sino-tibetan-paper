# Data and source code accompanying the paper "Dated language phylogenies shed light on the ancestry of Sino-Tibetan"

## Overview

This repository offers both source code and data for the analyses that were carried out for the paper "Dated language phylogenies shed light on the ancestry of Sino-Tibetan". 

## Software Requirements

We assume that you have a fresh and unbroken python3 installation on your computer. We tested all Python code for versions 3.5 and 3.7. Please contact us if you find that it does not work for any other Python versions. 

We also assume that you have a running version of TraitLab (Version +++) and Beast2 (Version +++) along with dependencies XXX installed.


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

## Carrying out TraitLab and Beast2 Analyses





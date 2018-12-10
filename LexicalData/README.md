# Converting the lexical data to Nexus and other formats

## Converting our data to Nexus format for phylogenetic analyses

The dump of the data that we used for our analysis was prepared in March 2018. This dump is provided in this repository. If you want to receive a more recent part of the data, you can run the script `to-nexus.py` along with the argument 'download'. 

To produce the Nexus files (stored in folder `data`), just make sure you have all requirements installed, and run the following:

```
$ python to-nexus.py
```

To make sure to use the same LingPy versions that we used, make sure to start from a fresh virtual environment on your machine, and install all third-party packages by typing:

```
$ pip install -r pip-requirements.txt
```

## Coverage statistics for different language families

The data we use for testing the coverage across different cognate datasets of different language families of the world is taken from the study by Rama et al. (2018), which is available from GitHub (https://github.com/PhyloStar/AutoCogPhylo/tree/1.0/data) and Zenodo (https://github.com/PhyloStar/AutoCogPhylo/tree/1.0). For convenience, we submit the data unchanged in the folder `Rama2018`. 

To run the tests on coverage (number of singletons, number of cognate sets reflected in all branches, etc.), just type:

```
$ python statistics.py NAME_OF_DATA_FILE
```

This will output various statistics on the coverage of the relevant dataset as well as the number of cognate sets.

## Concept list comparison

The script `concepts.py` provides the source code needed to compute a
comparative statistic in comparison with our concept list of 180 items and
lists proposed by other authors. To run it, type:

```
$ python concepts.py
```



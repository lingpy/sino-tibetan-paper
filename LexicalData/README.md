# Converting the lexical data to Nexus and other formats

The dump of the data that we used for our analysis was prepared in March 2018. This dump is provided in this repository. If you want to receive a more recent part of the data, you can run the script `to-nexus.py` along with the argument 'download'. 

To produce the Nexus files (stored in folder `data`), just make sure you have all requirements installed, and run the following:

```
$ python to-nexus.py
```

To make sure to use the same LingPy versions that we used, make sure to start from a fresh virtual environment on your machine, and install all third-party packages by typing:

```
$ pip install -r pip-requirements.txt
```

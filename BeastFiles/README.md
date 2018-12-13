# Files accompanying the BEAST analyses

We analysed the data using the Fossilized Birth-Death model of BEAST2, with a relaxed log-normal mutation rate and a clock-like mutation rate, on the complete data set. The .xml files may be processed directly by BEAST to reproduce our results.

The nexus file that we use as input is the same as the file produced by the `to-nexus.py` script in `LexicalData`, namely the file `sino-tibetan-beastwords.nex`, which we renamed when running the analysis to distinguish it from earlier version.

The file `sinotibetan-march-beast-covarion-relaxed-fbd.trees` contains the output of the main analysis (relaxed-clock). The file `sinotibetan-beast-covarion-strict-fbd.trees` contains the output of the strict-clock analysis. The files `small.trees` and `small_strict.trees` contain the output of an analysis on a subset of 19 languages.

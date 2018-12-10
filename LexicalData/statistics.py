from lingpy import *
from lingpy.compare.sanity import average_coverage
from lingpy import basictypes as bt
from collections import defaultdict

from sys import argv

# Compute basic statistics of the cognate data
def flat(line):
    return [x[0] for x in line if x != 0]

wl = Wordlist(argv[1])
etd = wl.get_etymdict(ref='cogid')

singletons = len([k for k, v in etd.items() if len(flat(v)) == 1])
bins = defaultdict(int)
for k, v in etd.items():
    bins[len(flat(v))] += 1
    if len(flat(v)) > wl.width-5:
        print(wl[flat(v)[0], 'concept'])

perc = wl.width - int(wl.width / 10 + 0.5)

for i in range(0, wl.width, 5):
    tbin = sum([v for k, v in bins.items() if k >= i and k <= i+5])
    print('R > {0:2} < {1:2} reflexes: {2}'.format(i, i+5, tbin))

percc = sum([v for k, v in bins.items() if k >= perc])

print('CONCEPTS:   {0}'.format(wl.height))
print('DOCULECTS:  {0}'.format(wl.width))
print('WORDS:      {0}'.format(len(wl)))
print('COGNATES:   {0}'.format(len(etd)))
print('SINGLETONS: {0} ({1:.2f})'.format(singletons, singletons/len(etd)))
print('COVERAGE:   {0:.2f}'.format(average_coverage(wl)))
print('FCOGS:      {0} / {1}'.format(percc, perc))



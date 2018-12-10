from lexibank_sagartst import Dataset
from pyconcepticon.api import Concepticon
from tabulate import tabulate

lists = [
        'Swadesh-1952-200',
        'Matisoff-1978-200',
        'Swadesh-1955-100',
        'Blust-2008-210',
        'Tadmor-2009-100',
        'Yakhontov-1991-100',
        'Holman-2008-40',
        'SatterthwaitePhillips-2011-50'
        ]
con = Concepticon()
ds = [c['CONCEPTICON_ID'] for c in Dataset().concepts if float(c['Coverage'])
        >= 0.85]
print(len(ds))
coverage = []
all_lists = []
for l in lists:
    subl = [c.concepticon_id for c in con.conceptlists[l].concepts.values()]
    all_lists += subl
    subs = [x for x in ds if x in subl]
    coverage += [[l, len(subs), round(len(subs) / len(subl), 2),  len(subl)]]
subs_ = sorted(set([x for x in ds if not x in all_lists]), key=lambda x: int(x))
subs = len(subs)
coverage += [['unlinked', subs, round(subs / 180, 2), '-']]

print(tabulate(coverage, tablefmt='latex'))

news = []
for i in range(0, len(subs_), 2):
    c1 = con.conceptsets[subs_[i]]
    c2 = con.conceptsets[subs_[i+1]]
    news += [[c1.id, c1.gloss, c2.id, c2.gloss]]

print(tabulate(news, tablefmt='latex'))
    


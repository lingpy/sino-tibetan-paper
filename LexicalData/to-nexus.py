from lingpy import *
from lingpy.convert.strings import write_nexus
from lexibank_jacquesst import Dataset
import json
from lingpy.convert.cldf import from_cldf

# load data into wordlist
ds = Dataset()
wl = Wordlist(ds.raw.joinpath('sino-tibetan-edited.tsv'))
wl.renumber('cogid', 'cogid', override=True)
# load the data
data = json.load(open(ds.raw.posix('data.json')))

# exclude borrowings
D = {0: [h for h in wl.columns]}

# retrieve the cognate sets
C, maxcogs = {}, max(wl.get_etymdict(ref='cogid'))+1 
for idx, doculect, borrowing, concept in wl.iter_rows('doculect', 'borrowing', 'concept'):
    if concept in data['concepts']:
        D[idx] = [h for h in wl[idx]]
        D[idx][wl.header['doculect']] = data['taxa'].get(
                doculect, 
                doculect).replace('_', '')
        # note that we have to whitelist two items that were later annotated as
        # borrowings but not in the version that we analysed from March 2018
        if borrowing.strip() and idx not in [33076, 33526]:
            C[idx] = maxcogs
            maxcogs += 1
        else:
            C[idx] = wl[idx, 'cogid']

wln = Wordlist(D)
wln.add_entries('cognacy', C, lambda x: x)
print("[i] loaded wordlist with ", wln.height, "concepts", 
        wln.width, "taxa", "and",
        len(wln.get_etymdict(ref='cognacy')), "cognate sets")

wln.output('dst', filename='data/sino-tibetan')
wln.output('tsv', filename='data/sino-tibetan-sublist')
etd = wln.get_etymdict('cognacy')

nex = write_nexus(
        wln, ref='cognacy', mode='splitstree',
        filename='data/sino-tibetan-splitstree.nex')
print('[i] wrote splitstree')

nex = write_nexus(
        wln, ref='cognacy', mode='beastwords',
        filename='data/sino-tibetan-beastwords.nex')
print('[i] wrote beast')

nex = write_nexus(
        wln, ref='cognacy', mode='beast', filename='data/sino-tibetan-beast.nex')
print('[i] wrote beastplain')

nex = write_nexus(
        wln, ref='cognacy', mode='traitlab',
        filename='data/sino-tibetan-traitlab.nex')
print('[i] wrote traitlab')




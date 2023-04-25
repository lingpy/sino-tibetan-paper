# Verifying the adequacy of the tree model.

We follow the methodology described by Kelly & Nicholls (2017) and detailed at https://github.com/lukejkelly/TraitLabSDLT

We restricted the data to the following languages:
    BurmishAchang             
    BurmishOldBurmese         
    DengDarangTaraon          
    GaroGaro                  
    KirantiKulung             
    Rabha                     
    rGyalrongJaphug           
    SiniticBeijing            
    SiniticGuangzhou          
    SiniticOldChinese         
    Tangut                    
    TaniBokar                 
    TibetanLhasa              
    TibetanOldTibetan         
    TibetoKinauriByangsi
    
and split the data randomly into a training data set (2804 traits) and a test data set (990 traits), given as ST-50-180-15-train.nex and ST-50-180-15-test.nex

We ran the commands

```matlab
addpath borrowing goodnessOfFit;
global SAVESTATES; SAVESTATES = 1;
```

then ran TraitLab twice on the training data set: once with lateral transfer, and once without. In both cases, the runs were for 1e6 iterations, thinning every 1e3 iterations. 
The corresponding .par files are included.

Finally, the Bayes factor is computed with:

```matlab
lPLnoLT = logPredictiveFromStates('data/', 'ST-50-180-15-test', 'ST-50-180-15-train-noLT-4', 0:1000, 1, 0);
lPLwithLT = logPredictiveFromStates('data/', 'ST-50-180-15-test', 'ST-50-180-15-train-withLT-2', 0:1000, 1, 0);

logMeanX = @(logX) max(logX) + log(mean(exp(logX - max(logX))));
(logMeanX(lPLnoLT(10:1:1000)) - logMeanX(lPLwithLT(10:1:1000))) * log10(exp(1))
```

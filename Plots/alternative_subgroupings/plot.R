library(ape)
library(ggplot2)
library(ggtree)

subgrouping <- list()
subgrouping['Van Driem (1997)'] = '((Kuki,Chin),((Bodo,Garo),Jingpho,Konyak),(((Tibetan,Kiranti),Sinitic),(((Burmish,Loloish),Karenic),Qiangic)));'
subgrouping['Matisoff (1978)'] = '(((((Kuki,Chin),(Bodo,Garo),Jingpho,Konyak)),(Tibetan,Kiranti),Qiangic,(Burmish,Loloish),Karenic),Sinitic);'
subgrouping['Thurgood (2003)'] = '(((Kuki,Chin),(Kiranti,Qiangic),Tibetan,Karenic,(Burmish,Loloish),((Bodo,Garo),Konyak,Jingpho)),Sinitic);'
subgrouping['Blench (2005)'] = '((Kuki,Chin),(Kiranti,(Karenic,(((Bodo,Garo),Jingpho,Konyak),((Sinitic,(Loloish,Burmish),Tibetic),Qiangic)))));'
subgrouping['Fallen Leaves'] = '((Kuki,Chin),Kiranti,Karenic,((Bodo,Garo),Konyak),Jingpho,Sinitic,(Loloish,Burmish),Tibetic,Qiangic);'
subgrouping['Peiros (1998)'] = '((((Burmish,Loloish),Qiangic),Tibetic,(Kuki,Chin),Karenic),Kiranti,(Bodo,Garo),Konyak,Jingpho,Sinitic);'

trees <- list()
for (label in names(subgrouping)) {
    trees[[label]] <- read.tree(text=subgrouping[[label]])

    # Fake branch lengths to make sure the plots have the
    # same scale and line up nicely.
    trees[[label]] <- compute.brlen(trees[[label]])
}
class(trees) <- 'multiPhylo'

p <- ggtree(trees, color="#333333")
p <- p + geom_tiplab(offset=0.01) + xlim(0, 1.3)
p <- p + theme_tree()
p <- p + facet_wrap(~.id, scales="fixed", ncol=2)


ggsave(p, filename='subgroupings.pdf', width=8, height=12)





#library(devtools)
#install_git("https://github.com/GuangchuangYu/ggtree.git")
library('ape')
library('ggplot2')
library('ggtree')

tree <- read.beast("sinotibetan-beast-covarion-relaxed-fbd.trees")

tree@data['rposterior'] <- sprintf("%0.2f", as.numeric(tree@data[['posterior']]))
tree@data['rposterior'][tree@data['rposterior'] == 'NA',] <- NA

cls <- list(
    Chepang=c("ChepangChepang"),
    Jingpho=c("JingphoJingpho"),
    Kiranti=c(
        "KirantiBahing", "KirantiBantawa", "KirantiHayu",
        "KirantiKhaling", "KirantiKulung", "KirantiLimbu", "KirantiThulung"
    ),
    "Kuki-Karbi"=c(
        "ChinHakha", "MizoLushai", "NagaUkhrul",
        "Karbi" # = 30 - Mikir
    ),
    Sal=c("GaroGaro", "Rabha"),
    Sinitic=c(
        "SiniticBeijing", "SiniticChaozhou", "SiniticLonggang",
        "SiniticOldChinese",
        "SiniticGuangzhou", "SiniticJieyang", "SiniticXingning"
    ),
    "Tani-Yidu"=c("TaniBokar", "DengDarangTaraon", "DengYidu"),
    "Tibeto-Dulong"=c(
        "TibetanAlike", "TibetanBatang", "TibetanLhasa", "TibetanOldTibetan",
        "TibetanXiahe",
        "rGyalrongDaofu", "rGyalrongJaphug", "rGyalrongMaerkang",
        "KhroskyabsWobzi", "LoloishLisu", "NungicDulong",
        "QiangicZhaba", "Tangut",
        "BurmishAchang", "BurmishAtsi", "BurmishBola" ,
        "BurmishLashi", "BurmishMaru", "BurmishOldBurmese",
        "BurmishRangoon", "BurmishXiandao"
    ),
    Tshangla=c("BodicTshangla"),
    "West-Himalayish"=c(
        "TibetoKinauriBunan", "TibetoKinauriByangsi", "TibetoKinauriRongpo"
    )
)

colors <- c(
    "#333333", # ??
    "#AECDE1", # Chepang
    "#333333", # Jingpho
    "#3A78AF", # Kiranti
    "#BBDD93", # Kuki-Karbi
    "#559D3F", # Sal
    "#EE9E9B", # Sinitic
    "#D1342B", # Tani-Yidu
    "#F4C07B", # Tibeto-Dulong
    "#EF8532", # Tshangla
    "#C6B4D3" # West-Himalayish
)


tree <- groupOTU(tree, cls, overlap="origin", connect=FALSE)
#attr(tree@phylo, 'group')

# are we missing anything in cls?
stopifnot(
    setdiff(tree@phylo$tip.label, unlist(cls, use.names=FALSE)) == 0
)





# FIGURE -- tree with gray branches
p <- ggtree(tree, ladderize=TRUE, color="#333333")
p <- revts(p)
p <- p + geom_tiplab(align=TRUE, linesize=.5)
p <- p + geom_label(
    aes(label=rposterior), label.size=0.2, na.rm=TRUE, size=2,
    nudge_x=-0.2, nudge_y=0
)
#p <- p + geom_treescale(0, 1000)
p <- p + theme_tree2()
p <- p + scale_color_manual(values=colors)
p <- p + scale_x_continuous(breaks = seq(-9, 0, by = 1), limits=c(-8.0, 6.0))


col_idx = 2
for (clade in names(cls)) {
    m <- MRCA(tree, cls[[clade]])
    if (!is.null(m)) {
        cat(paste(clade, m, col_idx, colors[col_idx]), "\n")
        p <- p + geom_cladelabel(
            node=m, label=clade, color=colors[col_idx],
            offset.text=0.3,
            offset=3.5, barsize=2
        )
    }
    col_idx <- col_idx + 1
}

ggsave('tree-plain-tips.pdf', p, width=8, height=16)




# FIGURE -- tree with colored branches

p <- ggtree(tree, aes(color=group), ladderize=TRUE)
p <- revts(p)
p <- p + geom_tiplab(align=TRUE, linesize=.5)
p <- p + geom_label(
    aes(label=rposterior), label.size=0.2, na.rm=TRUE, size=2,
    nudge_x=-0.2, nudge_y=0
)
p <- p + theme_tree2()
p <- p + scale_color_manual(values=colors)
#p <- p + xlim(-8.0, 5.0)  # fix label issue
p <- p + scale_x_continuous(breaks = seq(-9, 0, by = 1), limits=c(-8.0, 6.0))

col_idx = 2  # start with two as index 1 is the gray non-grouped branches
for (clade in names(cls)) {
    m <- MRCA(tree, cls[[clade]])
    if (!is.null(m)) {
        cat(paste(clade, m, col_idx, colors[col_idx]), "\n")
        p <- p + geom_cladelabel(
            node=m, label=clade, color=colors[col_idx],
            offset.text=0.3,
            offset=3.5, barsize=2
        )
    }
    col_idx <- col_idx + 1
}

ggsave('tree-colored-tips.pdf', p, width=8, height=16)



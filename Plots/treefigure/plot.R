#!/usr/bin/env Rscript

library(devtools)
#install_git("https://github.com/GuangchuangYu/ggtree.git")
library('ape')
library('ggplot2')
library('ggtree')
library('tidytree')

options(error=recover)
options(show.error.locations=TRUE)

# store version details because ggtree is rather flaky in
# which versions of ggplot it needs
sink('versions.txt')
devtools::session_info()
sink()

args <- commandArgs(trailingOnly=TRUE)
# check for -h or --help
if ((length(args) == 0) || (any(grep("^(--help|-h)$", args))))
{
    cat("usage: ./plot.r treefile", sep="\n")
    quit("no", 1)
}




langs <- read.delim('languages.tsv', header=TRUE, stringsAsFactors=FALSE)

tree <- read.beast(args[[1]])

tree@data['rposterior'] <- sprintf("%0.2f", as.numeric(tree@data[['posterior']]))
tree@data['rposterior'][tree@data['rposterior'] == 'NA',] <- NA

# RENAME TIPS (i.e. tree has 'Karbi' but languages.tsv has 'MikirKarbi')
langs[langs$NAMEA == 'MikirKarbi', ]$NAMEA <- 'Karbi'
langs[langs$NAMEA == 'KochRabha', ]$NAMEA <- 'Rabha'
rownames(langs) <- sub("_", "", langs$NAMEA)
# rename taxon labels in tree to nice names
tree@phylo$tip.label <- langs[tree@phylo$tip.label, ]$NAMEB

cls <- list(
    Chepang = c("ChepangChepang"),
    Kiranti = c(
        "KirantiBahing", "KirantiBantawa", "KirantiHayu",
        "KirantiKhaling", "KirantiKulung", "KirantiLimbu", "KirantiThulung"
    ),
    "Kuki-Karbi" = c(
        "ChinHakha", "MizoLushai", "NagaUkhrul",
        "Karbi" # = 30 - Mikir
    ),
    Sal = c("GaroGaro", "Rabha", "JingphoJingpho"),
    Sinitic = c(
        "SiniticBeijing", "SiniticChaozhou", "SiniticLonggang",
        "SiniticOldChinese",
        "SiniticGuangzhou", "SiniticJieyang", "SiniticXingning"
    ),
    "Tani-Yidu" = c("TaniBokar", "DengDarangTaraon", "DengYidu"),
    "Tibetan" = c(
        "TibetanAlike", "TibetanBatang", "TibetanLhasa",
        "TibetanOldTibetan", "TibetanXiahe"
    ),
    "Gyalrongic" = c(
        "rGyalrongDaofu", "rGyalrongJaphug", "rGyalrongMaerkang",
        "KhroskyabsWobzi", "NungicDulong","QiangicZhaba", "Tangut"
    ),
    "Burmic" = c(
        "LoloishLisu", "BurmishAchang", "BurmishAtsi",
        "BurmishBola", "BurmishLashi", "BurmishMaru",
        "BurmishOldBurmese", "BurmishRangoon", "BurmishXiandao"
    ),
    "Tshangla" = c("BodicTshangla"),
    "West-Himalayish" = c(
        "TibetoKinauriBunan", "TibetoKinauriByangsi", "TibetoKinauriRongpo"
    )
)

# Convert tip labels in cls to the new nice labels.
for (clade in names(cls)) {
    newlabels <- langs[cls[[clade]], ]$NAMEB
    if (any(is.na(newlabels))) {
        print(sprintf("ERROR: %s", clade))
        print("Old:")
        print(cls[[clade]])
        print("New:")
        print(cls[[clade]])
        print(newlabels)
        stop()
    }
    cls[[clade]] <- newlabels
}



tree <- groupOTU(tree, cls, overlap="origin", connect=FALSE)
#attr(tree@phylo, 'group')
# levels(attr(tree@phylo, 'group'))

# are we missing anything in cls?
stopifnot(
    setdiff(tree@phylo$tip.label, unlist(cls, use.names=FALSE)) == 0
)

# should match order in levels(attr(tree@phylo, 'group'))
print(levels(attr(tree@phylo, 'group')))
colors <- c(
    "#333333", # 0  - i.e. non colored branches.
    "#F7BC4F", # Burmic
    "#385972", # Chepang
    "#F7A54F", # Gyalrongic
    "#679C50", # Kiranti
    "#8384B3", # Kuki-Karbi
    "#B85D6E", # Sal
    "#AA6D97", # Sinitic
    "#278B6A", # Tani-Yidu
    "#F78F4F", # Tibetan
    "#0C7479", # Tshangla
    "#AEA63D"  # West-Himalayish
)





# FIGURE -- tree with gray branches
p <- ggtree(tree, ladderize=TRUE, color="#333333", size=1.2)
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


col_idx = 1
for (clade in levels(attr(tree@phylo, 'group'))) {
    print(paste("Labelling clade #", col_idx, '=', clade))

    if (is.null(cls[[clade]])) next

    #m <- MRCA(tree, cls[[clade]])
    m <- ape::getMRCA(tree@phylo, cls[[clade]])
    if (!is.null(m)) {
        cat(paste(clade, m, col_idx, colors[col_idx]), "\n")
        p <- p + geom_cladelabel(
            node=m, label=clade, color=colors[col_idx],
            offset.text=0.5,
            extend=0.4,
            offset=3.5, barsize=2
        )
    }
    col_idx <- col_idx + 1
}

ggsave('tree-plain-tips.pdf', p, width=8, height=12)




# FIGURE -- tree with colored branches

p <- ggtree(tree, aes(color=group), ladderize=TRUE, size=1.2)
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

col_idx = 1
for (clade in levels(attr(tree@phylo, 'group'))) {
    if (is.null(cls[[clade]])) next
    m <- ape::getMRCA(tree@phylo, cls[[clade]])
    #m <- MRCA(tree, cls[[clade]])
    if (!is.null(m)) {
        cat(paste(clade, m, col_idx, colors[col_idx]), "\n")
        p <- p + geom_cladelabel(
            node=m, label=clade, color=colors[col_idx],
            offset.text=0.5,
            extend=0.4,
            offset=3.5, barsize=2
        )
    }
    col_idx <- col_idx + 1
}

ggsave('tree-colored-tips.pdf', p, width=8, height=12)



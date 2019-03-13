#!/usr/bin/env Rscript
library(ape)
library(ggplot2)
DATASET <- "../BeastFiles/sinotibetan-march-50-180-beastwords.nex"
nex <- read.nexus.data(DATASET)

statecounts <- function(nexus) {
    out <- data.frame(Language=c(), State=c(), Count=c())
    for (taxon in names(nexus)) {
        f = as.data.frame(table(nexus[[taxon]]))
        out <- rbind(out, 
            data.frame(Language=taxon, State=f$Var1, Count=f$Freq)
        )
    }
    out
}

cognatesizes <- function(nex) {
    df <- as.data.frame(nex)
    count <- function(arow) {
        length(arow[arow == '1'])
    }
    out <- data.frame(
        Site = row.names(df),
        Size = apply(df, 1, count)
    )
    out
}

sc <- statecounts(nex)
p <- ggplot(sc, aes(x=Language, y=Count, fill=State)) + geom_bar(stat="identity") + coord_flip() + theme_bw()
ggsave('statecounts.pdf', p)

sizes <- cognatesizes(nex)
# ignore cognate sets of size zero as these are BEAST's way of marking per-word ascertainment correction.
sizes <- sizes[sizes$Size > 1,]

p <- qplot(Size, data=sizes, geom="histogram", main="Cognate Set Sizes") + theme_bw()
ggsave('cognatesizes.pdf', p)


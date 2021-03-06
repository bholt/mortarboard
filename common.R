suppressPackageStartupMessages(require(RMySQL))
suppressPackageStartupMessages(require(sqldf))
suppressPackageStartupMessages(require(ggplot2))
suppressPackageStartupMessages(require(reshape))
options(RMySQL.dbname="claret") # (rest comes from $HOME/.my.cnf)

db <- function(query, factors=c(), numeric=c()) {
  d <- sqldf(query)
  d[factors] <- lapply(d[factors], factor)
  d[numeric] <- lapply(d[numeric], as.numeric)
  return(d)
}

capply <- function(col, func) unlist(lapply(col, func))

num <- function(var) as.numeric(as.character(var))

save <- function(g, name=FILE_BASE, file=sprintf("%s/%s.pdf",FILE_DIR,name), w=3.3, h=3.1) {
  ggsave(plot=g, filename=file, width=w, height=h)
  print(sprintf("saved: %s", file))
}

prettify <- function(str) gsub('_',' ',gsub('([a-z])([a-z]+)',"\\U\\1\\E\\2",str,perl=TRUE))

regex_match <- function(reg,str) length(grep(reg,str)) > 0

label_pretty <- function(variable, value) {
  vname <- if (regex_match('variable|value',variable)) '' else sprintf('%s:', variable)
  lapply(paste(vname, prettify(as.character(value))), paste, collapse="\n")
}

geom_mean <- function(geom) stat_summary(fun.y='mean', geom=geom, labeller=label_pretty)

geom_meanbar <- function(labeller=label_pretty) {
  return(list(
    stat_summary(fun.y=mean, geom='bar', position='dodge'),
    stat_summary(fun.data=mean_cl_normal, geom='errorbar', width=0.2, position='dodge')
  ))
}

c.blue   <- "#0072B2"
c.yellow <- "#E69F00"
c.green  <- "#009E73"
c.red    <- "#D55E00"
c.pink   <- "#CC79A7"
c.gray   <- "#999999"

# The palette with grey:
cbPalette <- c(c.blue, c.yellow, c.green, c.red, c.pink, "#56B4E9", "#F0E442", c.gray)

theme_mine <- list(
  # To use for fills, add
  scale_fill_manual(values=cbPalette),
  # To use for line and point colors, add
  scale_colour_manual(values=cbPalette),
  # basic black and white theme
  theme(
    panel.background = element_rect(fill="white"),
    panel.border = element_rect(fill=NA, color="grey50"),
    panel.grid.major = element_line(color="grey80", size=0.2),
    panel.grid.minor = element_line(color="grey90", size=0.2),
    strip.background = element_rect(fill="grey90", color="grey50"),
    strip.background = element_rect(fill="grey80", color="grey50"),
    axis.ticks = element_line(colour="black"),
    panel.grid = element_line(colour="black"),
    axis.text.y = element_text(colour="black"),
    axis.text.x = element_text(colour="black"),
    text = element_text(size=9, family="Helvetica")
  )
)

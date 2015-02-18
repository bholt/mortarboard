source('project.R')

library(plotly)
py <- plotly()

# library(jsonlite)
# df.histogram <- function(json, version="none") {
#   d <- fromJSON(json)
#   return(data.frame(x=num(names(d)), y=num(unlist(d)), version=version))
# }
# df <- subset(db("
#     select * from tapir where stat_following_counts is not null
#     and name like '%v0.14%'
# "),
#   nclients == 32
#   & initusers == 4096
# )
# df$grp <- with(df, sprintf("%s\n%s\nmix:%s/%s,\n%s", name, ccmode, mix, alpha, gen))
#
# histogram.facets <- function(df, measure, grp) {
#   d <- data.frame(x=c(),y=c(),version=c())
#   for (i in 1:nrow(df)) {
#     d <- rbind(d, df.histogram(df[i,measure], df[i,grp]))
#   }
#   return(d)
# }
#
# d.follow <- histogram.facets(subset(df,
#     initusers == 4096 & mix == 'geom_repost'
# ), 'stat_follower_counts', 'grp')
# g <- ggplot(d.follow, aes(x=x, weight=y))+
#     # stat_ecdf(color=c.blue)+
#     geom_histogram(binwidth=.1, fill=c.blue)+
#     xlab('# followers / user (log scale)')+ylab('CDF (log scale)')+
#     scale_x_log10(breaks=c(1,10,100,1000))+scale_y_log10(breaks=c(0.1,0.5,1.0))+
#     theme_mine
#
# py$ggplotly(g)

raw <- db("
    select * from tapir where 
    generator_time is not null and total_time is not null
    and name like 'claret-v0.14%'
  ", factors=c('nshards', 'nclients'))
print(raw$nclients)

d <- data(db("
    select * from tapir where 
    generator_time is not null and total_time is not null
    and name like 'claret-v0.14%'
  ",
    factors=c('nshards', 'nclients'),
    numeric=c('total_time', 'txn_count')
))

colnames(d)

d.u <- subset(d, nshards == 4 & initusers == 4096 
                & grepl('geom_repost|read_heavy', mix))
                
                

g <- ggplot(d.u, aes(x=nclients, y=throughput/1000, group=cc, fill=cc, color=cc, linetype=cc))+
    stat_summary(fun.y=mean, geom="line")+
    xlab('Concurrent clients')+ylab('Throughput (k trans. / sec)')+
    # expand_limits(y=0)
    facet_wrap(~workload)+
    theme_mine+
    theme(legend.position='right', legend.direction='vertical', legend.title.align=0)+
    cc_scales(title='Concurrency\ncontrol:')

o <- py$ggplotly(g, kwargs=list(title="throughput", filename="throughput", fileopt="overwrite"))
print(o$response$url)

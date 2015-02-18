cc_scales <- function(field=cc, title="Concurrency control:") list(
  scale_fill_manual(values=my_palette, name=title),
  scale_color_manual(values=my_palette, name=title),
  scale_linetype_manual(name=title, values=c('commutative'=1,'reader/writer'=2))
)

data <- function(d) {
  d$failure_rate <- d$txn_failed / (d$txn_count + d$txn_failed)
  d$throughput <- d$txn_count * num(d$nclients) / d$total_time
  # d$throughput <- d$ntxns * num(d$nclients) / d$total_time
  d$avg_latency_ms <- d$txn_time / d$txn_count * 1000
  
  d$prepare_total <- d$prepare_retries + d$txn_count
  d$prepare_retry_rate <- d$prepare_retries / d$prepare_total
  
  d$ccf <- factor(d$ccmode, levels=c('simple','rw','bottom'))
  
  d$cc <- factor(revalue(d$ccmode, c(
    # 'bottom'='base',
    'rw'='reader/writer',
    'simple'='commutative'
  )), levels=c('commutative','reader/writer','base'))
  d$`Concurrency Control` <- d$cc
  
  d$Graph <- capply(d$gen, function(s) gsub('kronecker:.+','kronecker',s))
  
  d$workload <- factor(revalue(d$mix, c(
    'geom_repost'='repost-heavy',
    'read_heavy'='read-heavy',
    'update_heavy'='mixed'
  )), levels=c('read-heavy', 'repost-heavy', 'mixed'))
  
  d$zmix <- sprintf('%s/%s', d$mix, d$alpha)
  
  d$facet <- sprintf('shards: %d\n%s\n%d users\n%s', num(d$nshards), d$zmix, d$initusers, d$Graph)

  d$gen_label <- sprintf('%d users\n%s', d$initusers, d$Graph)
  
  return(d)
}

c.blue   <- "#0072B2"
c.yellow <- "#E69F00"
c.green  <- "#009E73"
c.red    <- "#D55E00"
c.pink   <- "#CC79A7"
c.gray   <- "#999999"

my_palette <- c(
  'rw'=c.yellow,
  'simple'=c.blue,
  
  'reader/writer'=c.yellow,
  'commutative'=c.blue,
  
  'follow'=c.blue,
  'newuser'=c.yellow,
  'post'=c.green,
  'repost'=c.red,
  'timeline'=c.pink,
  
  'kronecker'=c.blue,
  
  'read'=c.pink,
  'write'=c.green,
  
  'none'=c.gray  
)


# Notes on implementing new features

## Autoref extension
It would be best if I could easily add `\autoref{}` calls using Markdown syntax so we can automatically get nice "Section #", or "Figure #" references in Latex *and* HTML. To start with, the simplest version could just work for adding autoref calls and use `\labels` to declare the labels themselves.

Proposed syntax:

    
    ~~~{r, fig.cap="Throughput as we scale up concurrency.\label{throughput}"}
    ...plotting code...
    ~~~
    
    As you can see in [#throughput].

Look into implementing this as a [Pandoc filter](http://johnmacfarlane.net/pandoc/scripting.html).


### Configuration

Tried using ghc, but couldn't install all the necessary modules.

    > brew install ghc cabal-install
    > cabal update
    > cabal install pandoc
    ..build error..

Python works though:

    pip install pandocfilters



## Scholarly Markdown
http://scholarlymarkdown.com/Scholarly-Markdown-Guide.html
http://scholdoc.scholarlymarkdown.com/

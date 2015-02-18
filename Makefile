
PDFLATEX	?= pdflatex -halt-on-error -file-line-error
BIBTEX		?= bibtex
PANDOC    ?= scholdoc --natbib -S --standalone --data-dir=.

ifneq ($(QUIET),)
PDFLATEX	+= -interaction=batchmode
ERRFILTER	:= > /dev/null || (egrep ':[[:digit:]]+:' *.log && false)
BIBTEX		+= -terse
else
PDFLATEX	+= -interaction=nonstopmode
ERRFILTER=
endif

PAPER += paper

.PHONY: all
	
all: pdf web view
web: $(PAPER).html
pdf: $(PAPER).pdf

view: $(PAPER).pdf
	open -a Skim $(PAPER).pdf

%.md: %.Rmd common.R Makefile
	Rscript --slave -e "library(knitr); source('common.R'); knit('"$<"')"

%.tex: %.md templates/sigplanconf.latex Makefile
	$(PANDOC) --filter=filters/autoref.py --template=templates/sigplanconf.latex -o $@ $<

%.html: %.md templates/bootstrap.html Makefile
	$(PANDOC) --template=templates/bootstrap.html -o $@ $<

%.pdf: %.tex
	$(PDFLATEX) $^
	$(BIBTEX) $(basename $^)
	$(PDFLATEX) $^
	$(PDFLATEX) $^

clean:
	rm -f $(PAPER).{tex,pdf,log,out,html,md,aux,bbl,blg}

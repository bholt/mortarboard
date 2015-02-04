
PDFLATEX	?= pdflatex -halt-on-error -file-line-error
BIBTEX		?= bibtex
PANDOC    ?= pandoc --natbib -S --standalone

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

$(PAPER).md: $(PAPER).Rmd common.R Makefile
	Rscript --slave -e "library(knitr); source('common.R'); knit('"$<"')"

$(PAPER).tex: $(PAPER).md template.tex Makefile
	$(PANDOC) --template=template.tex -o $@ $<

$(PAPER).html: $(PAPER).md template.html Makefile
	# $(PANDOC) --template=template.tex -o $@ $<
	# Rscript --slave -e "library(knitr); pandoc('"$<"')"
	$(PANDOC) --template=template.html -o $@ $<

%.pdf: %.tex
	$(PDFLATEX) $^
	$(BIBTEX) $(basename $^)
	$(PDFLATEX) $^
	$(PDFLATEX) $^

clean:
	rm -f $(PAPER).{tex,pdf,log,out,html,md,aux,bbl,blg}

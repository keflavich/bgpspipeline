# latex Makefile
LATEX=latex
BIBTEX=bibtex
DVIPS=dvips
TARGETS= ms.ps

all: $(TARGETS)

pdf: ms.pdf

clean: 
	@rm -f *.aux *.bbl *.blg *.dvi *.log

ms.dvi: ms.tex
	${LATEX} ms.tex

ms.ps: ms.dvi figures.tex tables.tex milkyway.bib 
	${BIBTEX} ms
	${LATEX} ms.tex
	${BIBTEX} ms
	${LATEX} ms.tex
	${DVIPS} ms.dvi -o ms.ps

ms.pdf: ms.ps
	ps2pdf ms.ps















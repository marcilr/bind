# -*- Mode: Makefile -*-
#
# Created Tue Sep  5 15:57:48 AKDT 2006
# Copyright (C) 2006 by Raymond E. Marcil
# marcilr@rockhounding.net
# 
# This file is part of ImageGallery.
#  
# ImageGallery is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# ImageGallery is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with ImageGallery; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
# 
# Makefile for a single-file LaTeX document plus optional BibTeX file.
#
# Comment out the BibTeX run in the `dvi' target if you don't have a
# bibliography.
#

RM = rm -f
LATEX = latex
BIBTEX = bibtex
DVIPS = dvips
PS2PDF = ps2pdf

BASENAME = $(shell ls *.tex | sed 's/.tex//g')

SRC = $(BASENAME).tex
BIB = $(BASENAME).bib
BLG = $(BASENAME).blg
BBL = $(BASENAME).bbl
IDX = $(BASENAME).idx
IND = $(BASENAME).ind
IST = $(BASENAME).ist
GLO = $(BASENAME).glo
GLS = $(BASENAME).gls
LOG = $(BASENAME).log
TOC = $(BASENAME).toc
DVI = $(BASENAME).dvi
PS  = $(BASENAME).ps
PDF = $(BASENAME).pdf
LOF = $(BASENAME).lof
LOT = $(BASENAME).lot
OUT = $(BASENAME).out

cycle: clean dvi ps pdf

all: dvi ps pdf

clean:
	$(RM) $(LOG) $(LOF) $(TOC) $(DVI) $(PS) 
	$(RM) $(BBL) $(BLG) $(PDF) $(LOT) $(OUT)
	$(RM) $(IDX) $(GLO) *.aux *.tmp

index:
	makeindex $(IDX)

glossary:
	makeindex $(GLO) -s $(IST) -o $(GLS)

dvi:
	$(LATEX) $(SRC)

# Uncomment this entry if there are \citation entries.
#	$(BIBTEX) $(BASENAME)

# Rerun LaTeX again to get the xrefs right.
	$(LATEX) $(SRC)
	$(LATEX) $(SRC)

ps: dvi
# Embed hyperlinks for hyperref package (-z)
# Embed type 1 fonts, optimize for pdf (-Ppdf)
	$(DVIPS) -z -f -Ppdf -tletter < $(DVI) > $(PS)
# Embed type 1 fonts.
#	$(DVIPS) -f -Pcmz < $(DVI) > $(PS)
# Embed type 3 (bitmapped) fonts.
#	$(DVIPS) $(DVI) -o

pdf: ps
	$(PS2PDF) $(PS)

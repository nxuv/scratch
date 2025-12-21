out.html:
	node test.js > out.html

out.md: out.html
	html-to-markdown -o . out.html
	mv out.html.md out.md

.PHONY: all
all: out.md

.DEFAULT_GOAL := all
.MAIN: all

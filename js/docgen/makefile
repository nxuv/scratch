out.html: test.js
	node test.js > out.html

out.md: out.html
	html-to-markdown $< -o .
	mv $<.md $@

.PHONY: all
all: out.md

.PHONY: clean
clean:
	rm out.md out.html

.DEFAULT_GOAL := all
.MAIN: all

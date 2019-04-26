default: all
RDIR = .

all: build_pdf build_html

.PHONY: builds_pdf
build_pdf:
	Rscript -e "bookdown::render_book('index.Rmd', 'thesisdown::thesis_pdf')"
	
.PHONY: builds_html
build_html:
	Rscript -e "bookdown::render_book('index.Rmd', 'thesisdown::thesis_gitbook')"
	
		
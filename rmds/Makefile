default: all
RDIR = .

all: build_pdf build_html

.PHONY: builds_html
build_html:
	Rscript -e "source('.Rprofile'); bookdown::render_book('index.Rmd', 'thesisdown::thesis_gitbook')"
	
.PHONY: builds_pdf
build_pdf:
	cp index.Rmd orig-index.Rmd && \
  Rscript -e "source('format/insert-requirements.R'); insert_requirements('index.Rmd', yaml = 'format/_pdf.yml')" && \
	Rscript -e "source('.Rprofile'); bookdown::render_book('index.Rmd', 'thesisdown::thesis_pdf')" %% \
	rm index.Rmd && \
	mv orig-index.Rmd index.Rmd	
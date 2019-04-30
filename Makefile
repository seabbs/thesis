default: all

all: clean_docs thesis git_commit

.PHONY: clean_docs		 
clean_docs:
	rm -r -f docs
	mkdir docs
     
.PHONY: thesis		 
thesis:
	cd index && make
     

#Commit updates
.PHONY: git_commit
git_commit:
	git add --all
	git commit -m "$(message)"
	git push
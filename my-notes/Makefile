.PHONY: help
.ONESHELL:

analyze: ## Add all vhdl files to work library (retry if an error occures); e.g. make project=test analyze
	@for file in $(shell find ./src/$(project) -type f -name "*.vhdl"); do ees-ghdl -a --workdir=./$(project) $${file}; done

wave: ## Generate wave file and open gtkwave viewer; e.g. make project=test entity=test wave
	cd ./$(project) 
	ees-ghdl -c -r $(entity) --wave=$(entity).ghw
	gtkwave -A $(entity).ghw -a $(entity).gtkw

clean: ## Remove all generated files; e.g. make project=test entity=test clean
	cd ./$(project)
	ees-ghdl --remove
	rm -rf $(entity).ghw $(entity).gtkw 

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

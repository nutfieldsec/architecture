.phony: system-diagram

.phony: clean

.phony: container

.phony: docker-container

.phony: system

.phony: docker-system

clean: 
	mkdir -p ./output
	rm -rf ./output/*

container: 
	podman build -t pandoc-mermaid .

# Adding docker specific version to use in GitHub actions
docker-container: 
	docker build -t pandoc-mermaid -f ./Containerfile .

system: clean
	mkdir -p ./output
#	The following line creates the pdf and outputs all images to output/images (see the comment in the header of 00-introduction.md to control output file type)
	podman run --security-opt label=disable --rm -v .:/data pandoc-mermaid "pandoc \"./system-diagram/00-introduction.md\" \"./system-diagram/01-global system view.md\" \"./system-diagram/02-aws vpn peering.md\" \"./system-diagram/999-CHANGELOG.md\" -s --toc --top-level-division=chapter --lua-filter /filters/diagram.lua --filter pandoc-crossref -V geometry:margin=30mm -f markdown-implicit_figures --embed-resources --extract-media=output/images -o \"output/system-diagram.pdf\""

# Adding docker specific version to use in GitHub actions
docker-system: clean
	mkdir -p ./output
#	The following line creates the pdf and outputs all images to output/images (see the comment in the header of 00-introduction.md to control output file type)
	docker run --security-opt label=disable --rm -v .:/data pandoc-mermaid "pandoc \"./system-diagram/00-introduction.md\" \"./system-diagram/01-global system view.md\" \"./system-diagram/02-aws vpn peering.md\" \"./system-diagram/999-CHANGELOG.md\" -s  --toc --top-level-division=chapter --lua-filter /filters/diagram.lua --filter pandoc-crossref -V geometry:margin=30mm -f markdown-implicit_figures --embed-resources --extract-media=output/images -o \"output/system-diagram.pdf\""


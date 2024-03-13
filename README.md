# Architecture

This repo attempts to contain engineering source files supporting architecture projects. These files often contain narratives, requirements, specifications, and diagrams.

## Requirements

Ideally, reports from this repository will be built by GitHub actions. Until then, users need to manually generate the documents on their local machine.

- [podman](https://podman.io/)
- [podman-desktop (optional)](https://podman-desktop.io/)

Note for `podman-desktop`: If using mac or windows, you will likely need to configure your podman machine to allow rootful containers.

```bash
podman machine set --rootful=true
```

- [wsl](https://learn.microsoft.com/en-us/windows/wsl/install)
- [make](https://www.gnu.org/software/make/)
- [Mermaid Markdown Syntax Highlighting (optional)](https://marketplace.visualstudio.com/items?itemName=bpruitt-goddard.mermaid-markdown-syntax-highlighting)
- [markdown-preview-enhanced (optional)](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced)

## system-diagram

The purpose of this repo was to build diagrams to support the security program.

These can be rebuilt on demand using the included make file. PDF and DOCX files will be exported to the `output/` folder. PNG images extracted from the generated documents will be exported to `output/images/`.

```bash
# Make the pandoc-mermaid container
make container
# Using the pandoc-mermaid container from above, build the documentation set
make system
```

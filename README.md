# Mortarboard
Seamlessly tying together data exploration and analysis, technical blogging, and academic paper writing.

The vision:

- Write about your ideas, hypotheses, and experimental setup with *syntax that stays out of your way* with Markdown
- Put *executable* code in code blocks to load your data and analyze it
- Display generated plots and tables *inline*
- Output to PDF in the correct format of your target *academic publication* to see how the final paper will look as you go
- Output to HTML in a *technical blog style* for easier sharing
- Automatically make the tables and plots *interactive* so collaborators and strangers can manipulate and play with your data in new ways.

# Technology
- Pandoc: generate HTML or Latex from Markdown (or a slew of other markup languages)
  - extensible so we can build filters specifically for common use cases
- R's `knitr` package: actually execute R code blocks and display generated plots inline!
- Plotly: take ggplot plots and automatically make them interactive, letting you drill into the data

# Status
- Currently Latex/PDF generation is working pretty well.
  - Still trying to work out kinks in Pandoc/Knitr's mechanisms for references and labels
  - Would like to add `\autoref` functionality, seems like Pandoc has some efforts in the works but nothing ready
- HTML generation currently poor because we're generating PDFs for plots and not converting them
  - use Plotly when generating HTML to fix this problem

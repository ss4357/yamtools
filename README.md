# Yamtools - Yet Another Metabolomic Toolbox

:tada:Yet Another Metabolomic Toolbox

## About 

Yet Another Metabolomic Toolbox is an online R package that processes
metabolomics raw data. Data is visualized and pathway analysis is cleaned 
and consolidated using Mummichog 2 pathway analysis results.

## Installtion

Install yamtools from github using this code.

```r
install.packages("devtools")
devtools::install_github("ss4357/yamtools")
```


## Examples

Use "extdata/example1" to indicate location of data.

```r
pathway_dir <- system.file("extdata/example1", package = "yamtools")
pathway_pattern <- "mcg_pathwayanalysis_pathway.xlsx"
output_dir <- pathway_dir



concat_pathways(pathway_dir,
                pathway_pattern,
                output_dir,
                "1. r_vs_s",
                "2. v_sd4_vs_s",
                "3. ex_sd4_vs_v_sd4",
                "4. ex2_sd4_vs_v_sd4")


```


### Code style

Since this is a collaborative project, please adhere to the following code formatting conventions:
* We use the tidyverse style guide (https://style.tidyverse.org/)
* Please write roxygen2 comments as full sentences, starting with a capital letter and ending with a period. Brevity is preferred (e.g., "Calculates standard deviation" is preferred over "This method calculates and returns a standard deviation of given set of numbers").


### Special Thanks

Special thanks to Yaoxiang Li (@lzyacht).
#' Concatenate Pathway analysis report tables into one
#'
#' \code{concat_pathways} saved the result into a csv file
#'
#' @param pathway_dir directory for pathways
#' @param pathway_pattern pathway pattern
#' @param ouput_dir ouput directory
#'
#' @author  Samantha Shen \email{<shen.samantha@yahoo.com>}
#'
#' License: GPL (>= 3)
#'
#' @importFrom magrittr %>%
#'
#' @import dplyr readxl stringr
#' @export
#'
#'
concat_pathways <-
  function(pathway_dir = NULL,
           pathway_pattern = "mcg_pathwayanalysis_pathway.xlsx",
           ouput_dir = NULL,
           ...) {

  cmprs <- list(...)


  # STEP 1 Get the union set for all  Significant Pathway names as f --------


  # You have to close the pathway result files before you run this function

  pathways <- list.files(pathway_dir, pathway_pattern, full.names = TRUE, recursive = TRUE)

  #TODO some issues to fix later
  # pathways <- pathways[sapply(pathways, function(x) any(stringr::str_detect(x, unlist(cmprs))))]

  pathway_res <- dplyr::tibble(pathway                           = character(),
                               overlap_size                      = double(),
                               pathway_size                      = double(),
                               `p-value`                         = double(),
                               `overlap_EmpiricalCompounds (id)` = character(),
                               `ove rlap_features (id)`          = character(),
                               `overlap_features (name)`         = character())


  for (pathway in pathways) {
    pathway_res <-
      readxl::read_excel(pathway) %>%
      dplyr::filter(`p-value` < 0.05) %>%
      dplyr::bind_rows(pathway_res)
  }


  pathway_res %<>%
    dplyr::filter(!is.na(`overlap_EmpiricalCompounds (id)`)) %>%
    dplyr::arrange(`p-value`) %>%
    dplyr::distinct(pathway, .keep_all = FALSE)





  # STEP 2 Combining results for each comparison--------

  results <- list()
  for (cmpr in cmprs) {
    current_res <- dplyr::tibble(pathway                           = character(),
                                 overlap_size                      = double(),
                                 pathway_size                      = double(),
                                 `p-value`                         = double(),
                                 `overlap_EmpiricalCompounds (id)` = character(),
                                 `ove rlap_features (id)`          = character(),
                                 `overlap_features (name)`         = character())

    for (pathway in pathways[grep(cmpr, pathways)]) {
      current_res <-
        readxl::read_excel(pathway) %>%
        dplyr::filter(`p-value` < 0.05) %>%
        dplyr::bind_rows(current_res)
    }

    results[[cmpr]] <- current_res %>%
      dplyr::filter(!is.na(`overlap_EmpiricalCompounds (id)`)) %>%
      dplyr::arrange(`p-value`) %>%
      dplyr::distinct(pathway, .keep_all = TRUE)
  }


  short_results <- pathway_res
  for (result in results) {
    short_results <- dplyr::left_join(short_results, result %>% dplyr::transmute(pathway, overlap_pathway_size = paste0(overlap_size, "(", pathway_size ,")"), `p-value`),by = "pathway")
  }





  readr::write_excel_csv(short_results, paste0(output_dir, "/all_res.csv"), na = "-")


  }



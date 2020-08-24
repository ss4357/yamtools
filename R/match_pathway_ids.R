#' Concatenate Pathway analysis report tables into one
#'
#' \code{concat_pathways} saved the result into a csv file
#'
#' @param pathway_res pathway_res
#' @param pathway_EID pathway_EID
#' @param pathway_raw pathway_raw
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
#'
#'
#'
match_pathway_ids <-
  function(pathway_res, pathway_EID, pathway_raw) {

    # Matching the EID to Row numbers -----------------------------------------

    pathway_res %<>%
      dplyr::filter(`p-value` < 0.05) %>%
      dplyr::filter(!is.na(`overlap_EmpiricalCompounds (id)`))

    pathway_res %<>% dplyr::mutate( row_nums = "NA")


    for (i in 1:nrow(pathway_res)) {

      EIDs <- unlist(stringr::str_split(pathway_res[i, ]$`overlap_EmpiricalCompounds (id)`, ","))

      row_num <- pathway_EID[match(EIDs[1], pathway_EID$EID),]$massfeature_rows
      if (length(EIDs) > 1) {
        for (EID in EIDs[2:length(EIDs)]) {
          row_num <- paste0(row_num, ";", pathway_EID[match(EID, pathway_EID$EID),]$massfeature_rows)
        }
      }
      pathway_res[i, ]$row_nums <- row_num
    }




    # Matching the m/z rt -----------------------------------------------------


    pathway_res %<>% dplyr::mutate( mz_rts = "NA")



    for (i in 1:nrow(pathway_res)) {

      row_nums <- unlist(stringr::str_split(pathway_res[i, ]$row_nums, ";"))



      mz_rt <- pathway_raw[match(row_nums[1], pathway_raw$massfeature_rows),]$CompoundID_from_user
      if (length(row_nums) > 1) {
        for (row_num in row_nums) {
          mz_rt <- paste0(mz_rt, ";", pathway_raw[match(row_num, pathway_raw$massfeature_rows),]$CompoundID_from_user)
        }
      }
      pathway_res[i, ]$mz_rts <- mz_rt
    }

    pathway_res
}








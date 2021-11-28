#' Join ID (Old name: `join_id2`)
#' 
#' Works with mod_select_id_cols.R
#'
#' @param ids ID data.frame must has "Name" and "ID" column
#' @param df Report data.frame that has "Name" and "ID" column
#'
#' @return data.frame
join_id <- function(ids, df ){
  
  ids_mod <- ids %>% 
    purrr::map_df(as.character) %>% 
    dplyr::mutate(ID = stringr::str_extract(ID,"[:digit:]+")) 
  
  dplyr::full_join(ids_mod, df, by = "ID", 
                   suffix = c("_from_ID", "_from_Zoom")) %>% 
    dplyr::relocate(tidyselect::starts_with("Name"), .after = "ID") %>% 
    dplyr::arrange(ID)
  
}
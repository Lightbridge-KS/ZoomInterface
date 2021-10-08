### Read Zoom Chat .txt file to a Tibble

library(purrr)
library(dplyr)

# Main Wrapper: Read from File path ------------------------------------------------------------


#' Read Zoom Chat File
#'
#' @param file Path to Zoom's chat .txt file(s)
#'
#' @return A tibble 
#' @export 
read_zoom_chat <- function(file){
  
  zoom_chat_raw <- readtext::readtext(file, encoding = "UTF-8")
  zoom_chat_extract(zoom_chat_raw)
  
}


# Construct Tibble ---------------------------------------------------------


#' Extract Each Element to Tibble
#'
#' @param x A character vector
#'
#' @return A Tibble with columns "Time", "Name", "Content".
#' If full Zoom Chat format is recognized "Target" is added.
#' @export
zoom_chat_extract <- function(x){
  
  time_chr <- zoom_chat_ext_time(x)
  
  if(is_chat_full(x)){
    ## Full Zoom Chat
    name_chr <- zoom_chat_ext_name_target(x)[["name"]]
    target_chr <- zoom_chat_ext_name_target(x)[["target"]] # Extra
    contents_chr <- zoom_chat_ext_contents(x)
  }else{
    ## Abbreviated Zoom Chat
    name_chr <- zoom_chat_ext_name_abbr(x)
    contents_chr <- zoom_chat_ext_contents_abbr(x) 
  }
  
  df1 <- tibble::tibble(
    Time = time_chr,
    Name = name_chr,
    Content = contents_chr
  )
  if( !is_chat_full(x)) return(df1)
  
  ## Full Zoom Chat add "Target"
  df1 %>% 
    dplyr::mutate(Target = target_chr, .after = "Name")
  
}


# Helper: Test if Chat "Full" ------------------------------------------------------------------

#' Test if Zoom Chat is Full
#'
#' Full Zoom chat has `hh:mm:ss from <Name> to <Target> :` structure.
#'
#' @param chr Character vector to test
#'
#' @return Logical: `TRUE` if it was Full
is_chat_full <- function(chr) {
  
  reg_time_from_to <- "\\d{2}:\\d{2}:\\d{2} From .+to .+"
  stringr::str_detect(chr, reg_time_from_to)
  
}


# Extract <Content> -------------------------------------------------------


#' Extract Contents from Zoom Chat
#'
#' @param chr A character vector
#'
#' @return A character vector
#' @export 
#'
zoom_chat_ext_contents <- function(chr) {
  
  chr %>% 
    # Regex match "hh:mm:ss From <Name>  to  <Target>:\n\t"
    stringr::str_split("(\n)?\\d{2}:\\d{2}:\\d{2}.+:\n\t") %>% 
    unlist() %>% 
    # Remove first one that empty
    .[-1]
}


#' Extract Contents from Zoom Chat Abbreviated
#'
#' @param chr A character vector
#'
#' @return A character vector
#' @export 
#'
zoom_chat_ext_contents_abbr <- function(chr) {
  
  chr %>% 
    # Regex match "hh:mm:ss<Name>:\t"
    stringr::str_split("(\n)?\\d{2}:\\d{2}:\\d{2}.+:\t") %>% 
    unlist() %>% 
    # Remove first one that empty
    .[-1]
}

# Extract <Name> and <Target> Full version ---------------------------------------------


#' Extract <Name> and <Target>
#'
#' @param chr A character vector
#'
#' @return A data.frame containing "Name" and "Target"
#' @export 
zoom_chat_ext_name_target <- function(chr) {
  
  reg_from_to <- "(?<=\\d{2}:\\d{2}:\\d{2} From  ).+"
  reg_from_to_name <- ".+(?=  to  )"
  reg_from_to_target <- "(?<=  to  )[^:]+"
  
  from_to <- stringr::str_extract_all(chr, reg_from_to)
  
  Name <- from_to %>% 
    purrr::map(~stringr::str_extract(.x, reg_from_to_name)) %>% unlist()
  
  Target <- from_to %>% 
    purrr::map(~stringr::str_extract(.x, reg_from_to_target)) %>% unlist()
  
  data.frame(name = Name, target = Target)
  
}


# Extract <Name> Abbreviated version ---------------------------------------------

#' Extract <Name> from Zoom Chat Abbreviated
#'
#' @param chr A character vector
#'
#' @return A character vector of <Name>
zoom_chat_ext_name_abbr <- function(chr) {
  
  reg_after_time <- "(?<=\\d{2}:\\d{2}:\\d{2}\t).+"
  reg_before_colontab <- ".+(?=:\t)"
  
  chr %>%
    # Extract Everything to the right of `<Time>\t`
    stringr::str_extract_all(reg_after_time) %>% unlist() %>% 
    # Then, extract Everything to the left of `:\t`
    purrr::map_chr(
      ~stringr::str_extract(.x, reg_before_colontab)
    )
}


# Extract <Time> Stamp ----------------------------------------------------


#' Extract <Time> Stamp
#'
#' @param chr A character vector
#'
#' @return character vector
#' @export
zoom_chat_ext_time <- function(chr) {
  
  reg_time <- "\\d{2}:\\d{2}:\\d{2}"
  stringr::str_extract_all(chr, reg_time) %>% unlist()
  
}


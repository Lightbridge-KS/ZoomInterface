### Read Zoom Chat .txt file to a Tibble



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
#' @return A Tibble
#' @export
zoom_chat_extract <- function(x){
  
  time_chr <- zoom_chat_ext_time(x)
  name_target_df <- zoom_chat_ext_name_target(x)
  contents_chr <- zoom_chat_ext_contents(x)
  
  tibble::tibble(
    Time = time_chr,
    Name = name_target_df[["name"]],
    Target = name_target_df[["target"]],
    Content = contents_chr
  )
  
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


# Extract <Name> and <Target> ---------------------------------------------



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


# Extract <Time> Stamp ----------------------------------------------------


#' Extract <Time> Stamp
#'
#' @param chr A character vector
#'
#' @return character vector
#' @export
zoom_chat_ext_time <- function(chr) {
  
  reg_time <- "\\d{2}:\\d{2}:\\d{2}(?= From)"
  stringr::str_extract_all(chr, reg_time) %>% unlist()
  
}

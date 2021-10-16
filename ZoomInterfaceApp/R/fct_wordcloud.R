### Word Cloud of Zoom Chat

library(showtext)
font_add_google("Sarabun")
showtext_auto()


# Count word of Zoom Chat ---------------------------------------------------------


count_zoom_chat_contents <- function(zoom_df, 
                                     token = c("words", "characters", "character_shingles",
                                               "ngrams", "skip_ngrams", "sentences","lines",
                                               "paragraphs", "regex", "tweets", "ptb"),
                                     ...
) {
  
  token <- match.arg(token)
  
  zoom_df %>% 
    tidytext::unnest_tokens(Word, Content, token = token, ...) %>% 
    dplyr::count(Word, sort = TRUE) %>% 
    dplyr::mutate(prop = n/sum(n))
  
}


# Plot Word Cloud ---------------------------------------------------------


plot_wordcloud <- function(data) {
  
  data %>% 
    ggplot2::ggplot(ggplot2::aes(label = Word, size = n)) +
    ggwordcloud::geom_text_wordcloud(
      family = "Sarabun",
      color = factor(sample.int(10, nrow(data), replace = TRUE)),
      area_corr = TRUE,
      rm_outside = TRUE
    ) +
    ggplot2::scale_size_area(max_size = 20) +
    #ggplot2::scale_radius(range = c(0, 30), limits = c(0, NA)) +
    ggplot2::theme_minimal() 
  
}
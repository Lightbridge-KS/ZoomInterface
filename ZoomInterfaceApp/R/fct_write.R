# Function: Write Custom Excel -------------------------------------------------------------

write_custom.xlsx <- function(x, filename){
  
  
  # Create Header Style
  head_style <- openxlsx::createStyle(textDecoration = "bold", 
                                      halign = "center", valign = "center", 
                                      fgFill = "#d9ead3", 
                                      border = "TopBottomLeftRight")
  
  wb <- openxlsx::write.xlsx(x, filename, 
                             headerStyle = head_style, 
                             borders = "columns")
  # Freeze First Row
  purrr::walk(names(x) , ~openxlsx::freezePane(wb, sheet = .x ,firstRow = T) )
  
  openxlsx::saveWorkbook(wb,  filename, overwrite = T)
  
}
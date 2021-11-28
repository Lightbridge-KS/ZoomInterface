# Fun: Read single file ---------------------------------------------------

read_single <- function(file_name, file_path) {
  
  ext <- tools::file_ext(file_name)
  switch(ext,
         csv = readr::read_csv(file_path),
         xls = readxl::read_excel(file_path),
         xlsx = readxl::read_excel(file_path),
         validate("Invalid file; Please upload a .csv, .xls or .xlsx file")
  )
  
}
### Read Participants
library(here)
library(readr)
i_am("R/read-pp.R")


# Paths -------------------------------------------------------------------


paths_pp <- list(
  cal = "my_data/pp/raw/213ClinCorCa_participants_06-10-64.csv",
  mm1 = "my_data/pp/raw/participants_MM-2021-11-05.csv",
  mm2 = "my_data/pp/raw/participants_MM-2021-11-19.csv",
  metsd = "my_data/pp/raw/participants_metabolic-19-11-64.csv"
)

paths_id <- list(
  md2 = "my_data/ID_file/MD2_2021.csv"
)

# ID file -----------------------------------------------------------------

id_df_md2 <- read_csv(here(paths_id$md2))


# Cleaned -----------------------------------------------------------------


pp_cal_cleaned <- zoomclass::read_participants(here(paths_pp$cal))



# Class Session -----------------------------------------------------------------


pp_cal_session <- zoomclass::class_session(pp_cal_cleaned, 
                                          class_start = "10:00", class_end = "12:00")

# Class Student ID -----------------------------------------------------------------

pp_cal_stuid <- zoomclass::class_studentsID(pp_cal_cleaned, 
                           id_regex = "[:digit:]{7}",
                           class_start = "10:00:00", class_end = "12:00:00", 
                           late_cutoff = "10:15:00",
                           period_to = "min", round_digits = 1)


# Attribute ---------------------------------------------------------------

zoomclass::class_overview(pp_cal_stuid)

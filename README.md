
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ZoomInterface

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

> **A data analysis Shiny web application for Zoom’s participants report
> `.csv` and Zoom’s chat `.txt` file.**

-   The app currently deployed:
    [**here**](https://si-physio-intern.shinyapps.io/zoom_interface)

-   User manual in Thai language can be found:
    [**here**](https://lightbridge-ks.github.io/ZoomInterface/)

-   Main operating functions are provided by
    [**{zoomclass}**](https://github.com/Lightbridge-KS/zoomclass)
    R-package.

------------------------------------------------------------------------

### Modules

-   **Zoom Class Report:** design to analyse student’s time data in Zoom
    classroom from participants report `.csv` file.

-   **Zoom Chat Converter:** convert [Zoom’s chat
    file](https://support.zoom.us/hc/en-us/articles/115004792763-Saving-in-meeting-chat)
    from `.txt` to `.xlsx`, for easy data manipulation and analysis.

------------------------------------------------------------------------

### Zoom Class Report

Main functions:

-   `zoomclass::class_studentsID()`: provides time information
    summarized for each student’s ID.

-   `zoomclass::class_session()`: provides time information for each
    sessions.

More information can be read in the app.

------------------------------------------------------------------------

### Zoom Chat Converter

The main function used is `zoomclass::read_zoom_chat()`.

The output is a data frame created by extracting text information from
the following columns:

-   **Time:** the time stamp of each message

-   **Name:** the person who send the message

-   **Target:** the audience or person who receive the message

-   **Content:** content of the message

Then, the data frame will be displayed in the app and could be download
as excel file.


<!-- README.md is generated from README.Rmd. Please edit that file -->

# ZoomInterface

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

This Shiny Application convert [Zoom’s chat
file](https://support.zoom.us/hc/en-us/articles/115004792763-Saving-in-meeting-chat)
from `.txt` to `.xlsx`, for easy data manipulation and analysis.

> The app currently deployed:
> [**here**](https://si-physio-intern.shinyapps.io/zoom_interface)

## Details

`readtext::readtext()` was used to read `.txt` file as a character
vector.

`{stringr}`’s regular expressions were used to extract information into
the following columns:

-   **Time:** the time stamp of each message

-   **Name:** the person who send the message

-   **Target:** the audience or person who receive the message

-   **Content:** content of the message

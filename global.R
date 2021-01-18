# environment -----
rm(list = ls())
invisible(gc())
options(encoding = "UTF-8", scipen = 999, stringsAsFactors = F, max.print = 80)
if (interactive()) options(shiny.autoreload = T)

# packages -----
suppressPackageStartupMessages({
  library(shiny)
  library(shinyWidgets)
  library(dplyr)
  library(ggplot2)
  library(scales)
  library(extrafont)
  library(rintrojs)
})

# scripts -----
source(file = "functions.R")
source(file = "rscripts/create_pitch.R")

# static data -----
pitch_df <- read.csv(file = "data/pitch_df.csv")
pitch_base_plot <- create_pitch()

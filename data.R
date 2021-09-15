#'---
#' title: "[TRIPOD 1] Identify the study as developing and/or validating a multivariable prediction model, the target population, and the outcome to be predicted."
#' author: 'Author One ^1,✉^, Author Two ^1^'
#' abstract: |
#'  | [TRIPOD 2] Provide a summary of objectives, study design, setting, participants, sample size, predictors, outcome, statistical analysis, results, and conclusions.
#' documentclass: article
#' description: 'Manuscript'
#' clean: false
#' self_contained: true
#' number_sections: false
#' keep_md: true
#' fig_caption: true
#' ---
#'
#+ init, echo=FALSE, message=FALSE, warning=FALSE,results='hide'

debug <- 0;
knitr::opts_chunk$set(echo=debug>0, warning=debug>0, message=debug>0);
#' Load libraries
library(GGally);
library(rio);
library(dplyr);
library(pander);
#library(synthpop);
#' Here are the libraries R currently sees:
search() %>% pander();
#' Load data
inputdata <- c(dat0='data/sim_veteran.xlsx');
if(file.exists('local.config.R')) source('local.config.R',local=TRUE,echo=FALSE);
dat0 <- import(inputdata['dat0']);
#' Make a scatterplot matrix
ggpairs(dat0);
#' Set all the two-value columns to be TRUE/FALSE
dat1 <- mutate(dat0
               , across(where( function(xx) length(unique(xx))<3), as.factor));
#' Now try the scatterplot matrix again
ggpairs(dat1);


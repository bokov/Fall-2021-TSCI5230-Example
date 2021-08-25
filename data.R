#+ init, echo=FALSE, message=FALSE, warning=FALSE,results='hide'

debug <- 0;
knitr::opts_chunk$set(echo=debug>0, warning=debug>0, message=debug>0);
#' Load libraries
library(GGally);
library(rio);
library(dplyr);
library(pander);
library(synthpop);
#' Here are the libraries R currently sees:
search() %>% pander();
#' Load data
# dat0 <- import('example_file.xlsx');
dat0 <- survival::veteran;
#' Make a scatterplot matrix
ggpairs(dat0);
#' Set all the two-value columns to be TRUE/FALSE
dat1 <- mutate(dat0
               , across(where( function(xx) length(unique(xx))==2), as.logical));
#' Now try the scatterplot matrix again
ggpairs(dat1);


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
#' output:
#'   html_document:
#'    code_folding: hide
#'    toc: true
#'    toc_float: true
#' ---
#'
#+ init, echo=FALSE, message=FALSE, warning=FALSE,results='hide'

debug <- 0;
knitr::opts_chunk$set(echo=debug>-1, warning=debug>0, message=debug>0);
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

#' # Using `pander`
#'
#' The `pander()` command helps show tabular (and other) data in a more readable
#' manner. It's optional if you're working in the R console, but if you are also
#' preparing reports from those same scripts (which we are in this class) then
#' it makes a big difference. In most of the examples here we will use `pander`
#' with the following syntax:
#+ panderexample, eval=FALSE

# Standalone
pander(dat0,split.tables=Inf, split.cells=Inf);

# As part of a pipeline of data transformation commands
head(dat0) %>% pander(split.tables=Inf, split.cells=Inf);

#' # Using `dplyr` to transform data
#'
#' ## Row Operations
#'
#' ### `filter`
#'
#' `filter()` selects rows that meet a set of criteria you specify.
#+ filter01
filter(dat0, time > 70 & celltype=='adeno') %>% pander(split.tables=Inf, split.cells=Inf);
#' ### `slice`
#'
#' The following two statements return the same result:
#+ slice01
# Show rows 2 through 6
slice(dat0, 2:6) %>% pander(split.tables=Inf, split.cells=Inf);
dat0[2:16,] %>% pander(split.tables=Inf, split.cells=Inf);
dat0 %>% slice(2:6) %>% pander(split.tables=Inf, split.cells=Inf);
#' Show the top 6 or the bottom 6 rows, respectively. These are equivalent to
#' base R's `head()` and `tail()` commands when used with the `n` argument.
#+ slice02
dat0 %>% slice_head(n=6) %>% pander(split.tables=Inf, split.cells=Inf);
dat0 %>% slice_tail(n=6) %>% pander(split.tables=Inf, split.cells=Inf);
#' The `slice` family of functions can take a `prop` argument instead of an `n`.
#' This specified a proportion of the total rows rather than a fixed number.
#' For example, the top and bottom 10% of the data:
#+ slice03
dat0 %>% slice_head(prop = 0.1)  %>% pander(split.tables=Inf, split.cells=Inf);
dat0 %>% slice_tail(prop = 0.1)  %>% pander(split.tables=Inf, split.cells=Inf);
#' A _very_ useful function is `slice_sample`. It selects a random sample of `n`
#' or `prop` rows from your data.
#+ slice04
slice_sample(dat0, n = 5, replace = TRUE) %>% pander(split.tables=Inf, split.cells=Inf);
slice_sample(dat0, n = 5, replace = TRUE) %>% pander(split.tables=Inf, split.cells=Inf);
#' ### `arrange`
#'
#' `arrange` returns the same data frame but sorted on the columns you specify
#' in the arguments. For example, by `trt` and `celltype`:
#+ arrange01
arrange(dat0, trt,celltype) %>% slice_head(n=20) %>% pander(split.tables=Inf, split.cells=Inf);
#' You can wrap any of the arguments in `desc()` to make it sort from largest to
#' smallest instead of the default smallest to largest.
#+
arrange(dat0, trt,age,celltype) %>% slice_head(n=5) %>% pander(split.tables=Inf, split.cells=Inf);
arrange(dat0, trt,desc(age),celltype) %>% slice_head(n=5) %>% pander(split.tables=Inf, split.cells=Inf);

#' ## Column Operations
#'
#' ### `select` and `where`
#'
#' Select extracts the columns of your choosing. The simplest way to do it is
#' by giving the unquoted, quoted, or back-quoted (` `` `) names of the columns
#' you want, each as a separate un-named argument. If your columns contain
#' spaces or punctuation marks, you have to quote or back-quote them. Here we
#' select three columns, one quoted, one unquoted, one back-quoted.
#+ select01
select(dat0,'karno',age,`prior`) %>% slice_head(n=5) %>% pander(split.tables=Inf, split.cells=Inf);
#' You can also select by the _type_ of column by using the `where()` helper
#' function. That function, in turn, should be wrapped around the _un_quoted
#' name of a function that can take a vector as its first argument and returns a
#' _single_ `TRUE` or `FALSE`. For example, `is.numeric()` and `is.character()`.
#' But you have to use them without the parentheses because you're referencing
#' the functions themselves, not their result (which is what the parentheses
#' would mean).
#+ select02
select(dat0,where(is.numeric)) %>% slice_head(n=5) %>% pander(split.tables=Inf, split.cells=Inf);
select(dat0,where(is.character)) %>% slice_head(n=5) %>% pander(split.tables=Inf, split.cells=Inf);
#' You can also select columns whose names match a particular pattern by using
#' `start_with()`, `ends_with()`, or `matches()` helper functions.
#+ select03
select(dat0,starts_with('t')) %>% slice_head(n=5) %>% pander(split.tables=Inf, split.cells=Inf);
select(dat0,ends_with('time')) %>% slice_head(n=5) %>% pander(split.tables=Inf, split.cells=Inf);
select(dat0,matches('ag')) %>% slice_head(n=5) %>% pander(split.tables=Inf, split.cells=Inf);
#'
#' ### `mutate`
#'
#' ### `rename`
#'
#' ### `relocate`
#'
#' ## Groups of Rows
#'
#' ### `group_by` and `summarise`

#' Set all the two-value columns to be TRUE/FALSE
dat1 <- mutate(dat0
               , across(where( function(xx) length(unique(xx))<3), as.factor));
#' Now try the scatterplot matrix again
ggpairs(dat1);


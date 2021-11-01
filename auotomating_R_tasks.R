#'---
#' title: "Automating Repetitive Tasks."
#' author: 'Author One ^1,✉^, Author Two ^1^'
#' abstract: |
#'  | For loops and apply functions.
#' documentclass: article
#' description: 'Manuscript'
#' clean: false
#' self_contained: true
#' number_sections: false
#' keep_md: true
#' fig_caption: true
#' css: production.css
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
library(broom);

#library(synthpop);
#' Here are the libraries R currently sees:
search() %>% pander();
#' Load data
inputdata <- c(dat0='data/sim_veteran.xlsx');
if(file.exists('local.config.R')) source('local.config.R',local=TRUE,echo=FALSE);
dat0 <- import(inputdata['dat0']);

#' Create the training and testing data
dat0$sample <- sample(c('train','test'),nrow(dat0),rep=T,prob = c(0.6667,0.3333));
dtrain <- subset(dat0,sample=='train');
dtest <- subset(dat0,sample=='test');

View(dtrain)
outcomes <- c("time", "status", "age")
nonanalitical <- c("sample")
model1 <- lm(age ~ trt + karno, dtrain)
summary(model1)

plot(model1)
prediction <- predict(model1)
plot(prediction, dtrain$age)

setdiff(colnames(dtrain), c(outcomes, "sample"))
rightside <- setdiff(colnames(dtrain), c(outcomes, nonanalitical))
model2 <- lm(paste(rightside, collapse = " + ") %>% paste("age ~", .), dtrain)
summary(model2)

for (ii in outcomes) {
  model2 <- lm(paste(rightside, collapse = " + ") %>%
                 paste(ii, " ~", .), dtrain)  %>% update(. ~.)
  # summary(model2)
  print(model2)
  plot(model2, which = c(1:2), ask = F)
}


# *apply functions


results <- sapply(outcomes,
                  function(ii) paste(rightside, collapse = " + ") %>%
                    paste(ii, " ~", .) %>% lm(dtrain)  %>% update(. ~.),
                  simplify = FALSE)

sapply(results, plot, which = c(1:2), ask = FALSE)

sapply(results, tidy)

# lapply returns lists
lapply(results, tidy) %>% bind_rows(.id = "model") -> results_df

results_df %>% pander()


# modeling

res2 <- list()  # create an empty list
reduced <- list() # for the reduced models
for (ii in outcomes) {
  res2[[ii]] <- lm(paste(rightside, collapse = " + ") %>%
                 paste(ii, " ~", .), dtrain)  %>% update(. ~.)
  reduced[[ii]] <- step(res2[[ii]], scope = list(lower = . ~ 1, upper = . ~ (.)^2))
  print(res2[[ii]])
  par(mfcol=c(2,2))
  plot(res2[[ii]], which = c(1:2), ask = F)
plot(reduced[[ii]], which = (1:2), ask = FALSE)
par(mfcol = c(1,2))
plot(predict(res2[[ii]]), dtrain[[ii]])
plot(predict(reduced[[ii]]), dtrain[[ii]])
plot(predict(res2[[ii]], dtest), dtest[[ii]], main= paste("Original model", ii))
plot(predict(reduced[[ii]], dtest), dtest[[ii]], main= paste("Stepwise",ii))
  }

temp <- step(model2, scope = list(lower = . ~ 1, upper = . ~ (.)^2))
plot(dtrain$age,predict(temp))





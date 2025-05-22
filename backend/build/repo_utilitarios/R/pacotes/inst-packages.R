# Lista dos pacotes essenciais
pacotes_essenciais <- c(
"ggplot2", "data.table", "lubridate", "stringr", "readr", 
"plotly", "shiny", "caret", "randomForest", "xgboost", 
"knitr", "rmarkdown", "survey", "lmtest", "xts", 
"zoo", "car", "psych", "MASS", "boot",
"dplyr", "tidyr", "forcats", "pryr", "Hmisc", 
"rpart", "lme4", "glmulti", "brms", "rjags", "bayesplot",
"probability", "infer", "BDA3", "coda", 
"MCMCpack", "tidymodels", "lightgbm", "keras", 
"tensorflow", "e1071", "mlr3", "rvest", "httr", 
"RSelenium", "jsonlite", "xml2", "leaflet", 
"highcharter", "visNetwork", "ggvis", "networkD3", "gganimate", 
"ggthemes",
"broom", "gvlma", "faraway", "sem", "sp", 
"sf", "spdep", "Matrix", "corrplot", "GPArotation", 
"lmerTest", "h2o", "caretEnsemble", "glmnet", "cvms", 
"superml", "deepnet", "mxnet", "forecast", "tseries", 
"urca", "dynlm", "plm", "panelview", "statmod", 
"INLA", "bayesm", "rstanarm", "simstudy", "ggmosaic", 
"viridis", "ggforce", "sunburstR", "treemap", "plot3D", 
"RCurl", "rjson", "curl", "rgl", 
"rayshader", "scales", "gridExtra", "cowplot", "patchwork", 
"grid", "rstatix", "hrbrthemes", "ggprism", 
"RColorBrewer", "showtext", "ggpattern"

)

# Instalar pacotes
instalar_pacotes <- pacotes_essenciais[!(pacotes_essenciais %in% installed.packages()[,"Package"])]
if(length(instalar_pacotes) > 0) install.packages(instalar_pacotes)

# Carregar todos os pacotes
lapply(pacotes_essenciais, library, character.only = TRUE)

# Carregando pacotes
lapply(c("shiny", "shinythemes", "plotly", "data.table", "shinyWidgets", "shinydashboard", "ggplot2", "forcats", "markdown"), require, character.only = TRUE)

# Carrega dados
load("data/peso.rda")
load("data/alunos.rda")
load("data/complementar.rda")
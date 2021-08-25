# Carregando pacotes
lapply(c("shiny", "shinythemes", "plotly", "data.table", "shinyWidgets", "shinydashboard", "forcats", "markdown"), require, character.only = TRUE)

# Carrega dados
load("data/peso.rda")
load("data/alunos.rda")
load("data/complementar.rda")
load("data/simulacao-inicial.rda")


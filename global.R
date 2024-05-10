# Carregando pacotes
library("shiny")
library("shinythemes")
library("plotly")
library("shinyWidgets")
library("shinydashboard")
library("shinydashboardPlus")
library("markdown")
library("simulador.fundeb")
options(scipen=999)

# Carrega dados
load("data/pesos.rda")
load("data/matriculas.rda")
load("data/complementar.rda")
load("data/simulacao_base.rda")
load("data/simulacao_base_agregada.rda")

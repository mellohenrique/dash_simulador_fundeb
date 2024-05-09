# Carregando pacotes
library("shiny")
library("shinythemes")
library("plotly")
library("shinyWidgets")
library("shinydashboard")
library("shinydashboardPlus")
library("markdown")
library("simulador.fundeb")
library("ggplot2")
options(scipen=999)

# Carrega dados
load("data/pesos.rda")
load("data/alunos.rda")
load("data/complementos.rda")
load("data/simulacao_inicial.rda")
load("data/simulacao_inicial_agregada.rda")

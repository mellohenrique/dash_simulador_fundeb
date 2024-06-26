# Carregando pacotes
library("shiny")
library("shinythemes")
library("plotly")
library("shinyWidgets")
library("shinydashboard")
library("shinydashboardPlus")
library("markdown")
library("simulador.fundeb")
library("shinycssloaders")
library('shinyalert')
options(scipen=999)

# Carrega dados
load("data/pesos.rda")
load("data/matriculas.rda")
load("data/complementar.rda")
load("data/cenario_atual.rda")
load("data/cenario_atual_agregada.rda")
load('data/cenario_ufs_atual.rda')

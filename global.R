# Carregando pacotes
library("shiny")
library("shinythemes")
library("plotly")
library("data.table")
library("shinyWidgets")
library("shinydashboard")
library("forcats")
library("markdown")
library("simulador.fundeb2")

# Carrega dados
load("data/peso.rda")
load("data/alunos.rda")
load("data/complementar.rda")
load("data/simulacao-inicial.rda")
load("data/codigos-ibge.rda")
load("data/valor-fundo-total.rda")
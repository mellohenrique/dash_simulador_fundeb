# Used packages
pacotes = c("shiny", "shinythemes", "plotly", "plotly", "data.table", "shinyWidgets", "shinydashboard", "ggplot2", "forcats", "markdown")

# Run the following command to verify that the required packages are installed. If some package
# is missing, it will be installed automatically
package.check <- lapply(pacotes, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
  }
})

# Define working directory
load("data/peso.rda")
load("data/alunos.rda")
load("data/complementar.rda")
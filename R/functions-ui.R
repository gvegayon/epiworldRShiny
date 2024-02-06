#' text_input_disease_name Function
#' @export 
#' @return Creates the text input for the disease name
text_input_disease_name <- function(model_name) {
  shiny::textInput(
    inputId     = paste0(model_name, "_disease_name"),
    label       = "Disease",
    value       = "",
    placeholder = "Please enter a disease name"
  )
}

#' slider_prevalence Function
#' @export 
#' @return Creates the prevalence slider
slider_prevalence <- function(model_name) {
  shiny::sliderInput(
    paste0(model_name, "_prevalence"),
    label = "% of population infected",
    value = "0.1",
    min = 0,
    max = 1,
    step = 0.01,
    ticks = FALSE
    )
}

#' numeric_input_ndays Function
#' @export 
#' @return Allows for the ability to specify the number of simulation days
numeric_input_ndays <- function(model_name) {
  shiny::numericInput(
    inputId = paste0(model_name, "_n_days"),
    label   = "Simulation Time (Days)",
    value   = "100",
    min     = 0,
    max     = NA,
    step    = 1
    )
}

#' slider_input_rate Function
#' @export 
#' @return Creates all rate sliders
slider_input_rate <- function(
  model_name, rate_name, value, maxval = 1, input_label = NULL
  ) {

  if (is.null(input_label)) {
    input_label <- gsub("[^a-z0-9]", "_", tolower(rate_name))
  }

  shiny::sliderInput(
    inputId = paste(
      model_name, input_label,
      sep = "_"
    ),
    label = rate_name,
    value = value,
    min   = 0,
    max   = maxval,
    step  = 0.01,
    ticks = FALSE
  )
}

#' network_input Function
#' @export 
#' @return Allows for the ability to specify network parameters
network_input <- function(model_name) {

  shiny::tagList(
    shiny::div(
      id = paste0("network_header_", model_name),
      shiny::headerPanel(
        h4(
          shiny::tagList(
            icon("circle-info"),
          "Population structure"
          )
        )
      )
      ),
    shinyjs::hidden(
      shiny::div(
        id = paste0("network_inputs_", model_name),
        shiny::sliderInput(
          inputId = paste0(model_name, "_population_size"),
          label   = "Population Size",
          min     = 0,
          max     = 100000,
          value   = 50000,
          step    = 1000,
          ticks   = FALSE
          ),
        shiny::numericInput(
          inputId = paste0(model_name, "_k"),
          label   = "Number of Ties",
          min     = 0,
          max     = 500,
          step    = 1,
          value   = 20
          ),
        shiny::selectInput(
          inputId  = paste0(model_name, "_directed"),
          label    = "Directed",
          choices  = c("TRUE", "FALSE"),
          selected = "FALSE"
          ),
        shiny::sliderInput(
          inputId = paste0(model_name, "_prob_rewiring"),
          label   = "Probability of Rewiring",
          value   = "0.20",
          min     = 0,
          max     = 1,
          step    = 0.01,
          ticks   = FALSE
          )
        )
      )
    )
}

#' npis_input Function
#' @export 
#' @return Allows the ability to specify npi/tool characteristics
npis_input <- function(model_name) {
  shiny::tagList(
    shiny::div(
      id = paste0("npis_header_", model_name),
      shiny::headerPanel(
        h4(
          shiny::tagList(
            icon("circle-info"),
            "Interventions"
            )
      ))
      ),
    # By default shinyjs::hidden
    shinyjs::hidden(
      shiny::div(id = paste0("npis_inputs_", model_name),
        shiny::sliderInput(
          inputId = paste0(model_name, "_vaccine_prevalence"),
          label   = "% of agents vaccinated",
          min     = 0,
          max     = 1,
          value   = 0,
          step    = 0.01,
          ticks   = FALSE
          ),
        shiny::sliderInput(
          inputId = paste0(model_name, "_masking_prevalence"),
          label   = "% of agents using masks",
          value   = "0",
          min     = 0,
          max     = 1,
          step    = 0.01,
          ticks   = FALSE
          ),
        shiny::headerPanel(h4("School Closure")),
        shiny::sliderInput(
          inputId = paste0(model_name, "_school_closure_prevalence"),
          label   = "Prevalence",
          value   = "0",
          min     = 0,
          max     = 1,
          step    = 0.01,
          ticks   = FALSE
          ),
        shiny::numericInput(
          inputId = paste0(model_name, "_school_closure_day"),
          label   = "Implementation day",
          value = "0",
          min = 0,
          max = 100,
          step = 1
        )
      )
    )
  )
}

#' seed_input Function
#' @export 
#' @return Allows the user to input a seed for reproducibility
seed_input <- function(model_name) {
  shiny::numericInput(
    inputId = paste0(model_name, "_seed"),
    label   = "Seed (Optional)",
    min     = 0,
    max     = NA,
    step    = 1,
    value   = 2023
    )
}

#' models_setup function
#' @export 
#' @return Function to set up models
models_setup <- function() {

  # Getting the environment
  env <- parent.frame()

  eval({

    # Get a list of all model files in the "models" directory
    models <- list.files(
      system.file("models", package = "epiworldRShiny"),
      pattern = "shiny_[a-z]+\\.R$",
      full.names = TRUE
      )

    # Source each model file
    for (f in models) {
      source(f)
    }

    # Capturing alt names
    models_names <- sapply(models, \(f) {

      # Only on the first line
      altname <- readLines(f, n = 1)

      # Is there any alt name?
      altname <- gsub("^#\\s*alt-name[:]\\s*(.+)\\s*$", "\\1", altname, perl = TRUE)

      # If there is no alt name, use the file name
      if (altname == "") {
        altname <- toupper(gsub("shiny_([^.]+).R", "\\1", basename(f)))
      }
      altname

    })

    # Get the model names from the file names
    models <- gsub("^.+shiny_([^.]+).R$", "\\1", models)

    # Set the names of the models to their alt names (if available)
    names(models_names) <- models
    names(models) <- models_names

    # Get the epiworldR environment
    epiworldR_env <- get("epiworldR_env", envir = .GlobalEnv)

    # Add the model names and models to the epiworldR environment
    epiworldR_env$models_names <- models_names
    epiworldR_env$models <- models

    # Doing some hacking
    models_panels <- mget(paste0(models, "_panel"), envir = .GlobalEnv)
    invisible({
      Map(\(pfun, nam, id) {
        assign(paste0(id, "_panel"), pfun(nam), envir = .GlobalEnv)
      }, pfun = models_panels, nam = models_names, id = models
      )
    })

  }, envir = env)

}

#' population_input Function
#' @export 
#' @return Generates population (equity) demographics
population_input <- function(model_name) {
  shiny::tagList(
    shiny::div(
      id = paste0("population_header_", model_name),
      shiny::headerPanel(
        h4(
          shiny::tagList(
            icon("circle-info"),
            "Population (equity)"
            )
      ))
    ),
    shinyjs::hidden(
      shiny::div(
        id = paste0("population_inputs_", model_name),
        shiny::sliderInput(
          inputId = paste0(model_name, "_prop_hispanic"),
          label   = "% Hispanic",
          value   = "0.5",
          min     = 0,
          max     = 1,
          step    = 0.01,
          ticks   = FALSE
          ),
        shiny::sliderInput(
          inputId = paste0(model_name, "_prop_female"),
          label   = "% Female",
          value   = "0.5",
          min     = 0,
          max     = 1,
          step    = 0.01,
          ticks   = FALSE
          ),
        shiny::sliderInput(
          inputId = paste0(model_name, "_prop_ages"),
          min     = 0,
          max     = 1,
          value   = c(.3, .6),
          label   = "Age distribution (< 20, < 60, 60+)",
          dragRange = TRUE
        )
      )
    )
  )

}

#' simulate_button Function
#' @export 
#' @return Runs the ABM simulation when selected
simulate_button <- function(model_name) {
  actionButton(
    inputId = paste0("simulate_", model_name),
    label   = "Run Simulation"
    )
}
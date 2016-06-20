#' prints a section of stan code to console
#'
#' @param stan_code (chr) text of stan code
#' @param section (chr) name of section to print. Should be one of 'data', 'parameters', 'functions', etc
#'
#' @import assertthat
#'
#' @return NULL
#' @export
print_stan_code <- function(stan_code, section = NULL) {
    valid_sections <-
        c('data',
          'parameters',
          'generated quantities',
          'transformed data',
          'transformed parameters',
          'functions',
          'model')
    assertthat::assert_that(is.null(section) || section %in% valid_sections)

    ## filter stan code for relevant section
    if (!is.null(section)) {
        regex_for_section <- paste(".*(",section,"\\s*\\{.*?\\}).*", sep = '')
        filtered_stan_code <- gsub(stan_code, pattern = regex_for_section, replacement = "\\1")
    } else {
        filtered_stan_code <- stan_code
    }

    ## print filtered code
    for (l in readLines(textConnection(filtered_stan_code)))
        cat(l, '\n')
}

#' reads a stan file into R
#'
#' @param path to stan file
#'
#' @import readr
#'
#' @return character scalar containing stan code
#' @export
read_stan_file <- function(stan_file) {
    readr::read_file(stan_file)
}


#' prints stan file to the console
#'
#' @param stan_file path to stan file
#' @param ... (params to print_stan_code - ex: section)
#'
#' @import readr
#'
#' @return character scalar containing stan code
#' @export
print_stan_file <- function(stan_file, ...) {
    print_stan_code(read_stan_file(stan_file), ...)
}

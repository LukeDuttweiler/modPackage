#' Set Up Modular Package
#'
#' This function sets up the necessary directories for a modular R package, in the
#' style of a function from usethis.
#'
#' @param path The path where the package directories should be created.
#'
#' @details This function creates two directories, 'workingFiles' and 'Rbackup', in
#' the specified path. If these directories do not exist, it creates them. Additionally,
#' it adds 'workingFiles' and 'Rbackup' to the build ignore list using `usethis::use_build_ignore`.
#'
#' @examples
#' \dontrun{
#' # Use the function with the default path
#' use_modular_package()
#'
#' # Use the function with a custom path
#' use_modular_package('/path/to/package')
#' }
#'
#' @return The function is designed to be used for its side effects. It invisibly returns NULL.
#'
#' @export
use_modular_package <- function(path = here::here()){
  #Create paths
  wfDir <- paste0(path, '/workingFiles')
  bupDir <- paste0(path, '/Rbackup')

  #Create directories if don't exist already
  if(!dir.exists(wfDir)){dir.create(wfDir)}
  if(!dir.exists(bupDir)){dir.create(bupDir)}

  #Add to build ignore
  usethis::use_build_ignore('workingFiles', escape = FALSE)
  usethis::use_build_ignore('Rbackup', escape = FALSE)

  return(invisible(NULL))
}

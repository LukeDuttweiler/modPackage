#' Load Modular R Package
#'
#' This function loads and documents a modular R package. It assumes that the package has
#' been set up for modular use with the `use_modular_package` function.
#'
#' @param path The path to the root directory of the modular R package.
#' @param ... Additional parameters passed to devtools::load_all().
#'
#' @details This function performs the following steps:
#' \enumerate{
#'   \item Checks if the required directories ('workingFiles' and 'Rbackup') exist. If not,
#'     it stops execution with an error message suggesting the use of 'use_modular_package'.
#'   \item Removes existing backup files in the 'Rbackup' directory.
#'   \item Copies the current R files to the 'Rbackup' directory.
#'   \item Removes the current R files if the copy to 'Rbackup' was successful.
#'   \item Retrieves R working files from the 'workingFiles' directory.
#'   \item Modifies the file names by appending the paths and copies them into the 'R' directory.
#'   \item Loads all R files and documents the package using devtools.
#' }
#'
#' @examples
#' \dontrun{
#' # Load the modular package with the default path
#' load_modular()
#'
#' # Load the modular package with a custom path
#' load_modular('/path/to/package')
#' }
#'
#' @return The function is designed to be used for its side effects. It invisibly returns NULL.
#'
#' @export
load_modular <- function(path = '.', ...){
  #Create paths
  wfDir <- paste0(path, '/workingFiles')
  bupDir <- paste0(path, '/Rbackup')
  rDir <- paste0(path, '/R')

  #Stop if not set up
  if(!dir.exists(wfDir) | !dir.exists(bupDir)){
    stop('R package not set up for modular use. Did you mean to run use_modular_package first?')
  }

  #Burn current backup files
  rbupFiles <- list.files(bupDir, full.names = TRUE)
  file.remove(rbupFiles)

  #Copy current R files to backup
  currentRFiles <- list.files(rDir, full.names = TRUE)
  rbackupCop <- file.copy(currentRFiles, bupDir,
                          overwrite = TRUE, copy.date = TRUE)

  #Burn current R files as long as copies have been made
  if(all(rbackupCop)){
    file.remove(currentRFiles)
  }else{
    stop('Error in sending current R files to Rbackup.')
  }

  #Get R workingFiles
  workingFiles <- list.files(wfDir, pattern = '.R$', recursive = TRUE, full.names = TRUE)

  #Append paths as file names
  newWFNames <- gsub('./workingFiles/','',workingFiles)
  newWFNames <- gsub('/', '-', newWFNames)
  newWFNames <- paste0(rDir,'/', newWFNames)

  #Copy into R directory
  rFilesCop <- file.copy(workingFiles, newWFNames, overwrite = TRUE, copy.date = TRUE)

  #As long as copies were successful, load all and document
  if(all(rFilesCop)){
    devtools::load_all(path = path, ...)
    devtools::document(pkg = path)
  }else{
    stop('Error in sending working files to R directory.')
  }

  return(invisible(NULL))
}

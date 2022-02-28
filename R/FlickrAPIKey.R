#' Set and get a Flickr API key to/from environment variables.
#'
#' @param api_key Flickr API key
#' @param overwrite If `TRUE`, overwrite existing token; Default: `FALSE`
#' @param install If `TRUE`, install token for use in future sessions; Default:
#'   `FALSE`
#' @rdname setFlickrAPIKey
#' @export
#'
#' @importFrom utils read.table write.table

setFlickrAPIKey <- function(api_key, overwrite = FALSE, install = FALSE) {
  if (is.character(api_key)) {
    type <- "FLICKR_API_KEY"
  } else {
    stop("Your supplied Flickr API key appears to be invalid. Check your Flickr account for details.")
  }

  if (install) {
    home <- Sys.getenv("HOME")
    renv <- file.path(home, ".Renviron")
    if (file.exists(renv)) {
      # Backup original .Renviron before doing anything else here.
      file.copy(renv, file.path(home, ".Renviron_backup"))
    }
    if (!file.exists(renv)) {
      file.create(renv)
    } else {
      if (isTRUE(overwrite)) {
        message("Your original .Renviron will be backed up and stored in your R HOME directory if needed.")
        oldenv <- read.table(renv, stringsAsFactors = FALSE)
        newenv <- oldenv[-grep(type, oldenv), ]
        write.table(newenv, renv,
          quote = FALSE, sep = "\n",
          col.names = FALSE, row.names = FALSE
        )
      } else {
        tv <- readLines(renv)
        if (any(grepl(type, tv))) {
          stop(sprintf("A %s already exists. You can overwrite it with the argument overwrite=TRUE", type), call. = FALSE)
        }
      }
    }

    api_keyconcat <- paste0(sprintf("%s='", type), api_key, "'")
    # Append access token to .Renviron file
    write(api_keyconcat, renv, sep = "\n", append = TRUE)
    message(sprintf('Your API key has been stored in your .Renviron and can be accessed by Sys.getenv("%s"). \nTo use now, restart R or run `readRenviron("~/.Renviron")`', type))
    return(api_key)
  } else {
    message("To install your API key for use in future sessions, run this function with `install = TRUE`.")
    Sys.setenv(type = api_key)
  }
}

#' @export
#' @rdname setFlickrAPIKey
set_flickr_api_key <- setFlickrAPIKey



#' Get Flickr API key from environment variables
#'
#' @rdname setFlickrAPIKey
#' @export

getFlickrAPIKey <- function(api_key = NULL) {
  if (is.null(api_key)) {
    # Use public token first, then secret token
    if (Sys.getenv("FLICKR_API_KEY") != "") {
      api_key <- Sys.getenv("FLICKR_API_KEY")
    } else {
      stop("A Flickr API key is required. Please create a key at your Flickr account: <https://www.flickr.com/services/api/misc.api_keys.html>", call. = FALSE)
    }
  }

  return(api_key)
}

#' @export
#' @rdname setFlickrAPIKey
get_flickr_api_key <- getFlickrAPIKey

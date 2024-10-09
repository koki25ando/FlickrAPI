#' Set and get a Flickr API key to/from environment variables.
#'
#' [setFlickrAPIKey()] sets a Flickr API key for the current session or for
#' future use as a `.Renviron` environment variable. [getFlickrAPIKey()] gets a
#' saved Flickr API key from `.Renviron`.
#'
#' @param api_key Flickr API key. Optional for [getFlickrAPIKey()].
#' @param install If `TRUE`, this function adds your token to your `.Renviron`
#'   using the name "FLICKR_API_KEY" for use in future sessions. Defaults to
#'   `FALSE`.
#' @param overwrite If `TRUE`, overwrite any existing token in `.Renviron` using
#'   the name "FLICKR_API_KEY". Defaults to `FALSE`.
#' @rdname setFlickrAPIKey
#' @export
#'
#' @importFrom utils read.table write.table
#' @importFrom rlang is_false
#' @importFrom cli cli_bullets
setFlickrAPIKey <- function(api_key, overwrite = FALSE, install = FALSE, call = caller_env()) {
  rlang::check_required(api_key, call = call)
  if (!rlang::is_string(api_key)) {
    cli_abort(
      "{.arg api_key} must be a string, not {.obj_type_friendly {api_key}}.",
      call = call
    )
  }

  default <- "FLICKR_API_KEY"

  if (isFALSE(install)) {
    cli_bullets(
      c(
        "v" = "{.envvar {default}} set to {.val {api_key}} with {.fn Sys.setenv}.",
        "*" = "To use this API key in future sessions, call
        {.fn setFlickrAPIKey} using {.arg install = TRUE}."
      )
    )
    Sys.setenv(default = api_key)
    return(invisible(api_key))
  }

  home <- Sys.getenv("HOME")
  renv <- file.path(home, ".Renviron")

  if (file.exists(renv)) {
    default_match <- grepl(paste0("^", default, "(?=\\=)"),
                           readLines(renv),
                           perl = TRUE
    )

    has_default <- any(default_match)

    if (has_default && !overwrite) {
      cli_abort(
        c("{.envvar {default}} already exists in your {.file .Renviron}.",
          "*" = "Set {.arg overwrite = TRUE} to replace this token."
        ),
        call = call
      )
    }
    backup <- file.path(home, ".Renviron_backup")
    file.copy(renv, backup)
    cli_alert_success("{.file .Renviron} backed up to {.path {backup}}.")

    if (has_default) {
      oldenv <- utils::read.table(renv, stringsAsFactors = FALSE)
      newenv <- oldenv[!default_match, ]
      utils::write.table(
        newenv, renv,
        quote = FALSE,
        sep = "\n", col.names = FALSE, row.names = FALSE
      )
    }
  } else {
    file.create(renv)
  }

  write(paste0(default, '="', token, '"'), renv, sep = "\n", append = TRUE)

  cli_bullets(
    c(
      "v" = "{.val {api_key}} saved to {.file .Renviron} variable {.envvar {default}}.",
      "*" = "Restart R or run {.code readRenviron(\"~/.Renviron\")} then use
      {.code Sys.getenv(\"{default}\")} to access the token."
    )
  )

  invisible(token)
}

#' @export
#' @rdname setFlickrAPIKey
set_flickr_api_key <- setFlickrAPIKey



#' Get Flickr API key from environment variables
#'
#' @rdname setFlickrAPIKey
#' @param strict If `TRUE` (default), error if api_key is `NULL` and no valid
#'   key is available using the "FLICKR_API_KEY" environment variable name. If
#'   `FALSE`, warn instead of error and invisibly return `NULL`.
#' @importFrom rlang %||% is_empty is_string
#' @export

getFlickrAPIKey <- function(api_key = NULL, strict = TRUE, error_call = caller_env()) {
  api_key <- api_key %||% Sys.getenv("FLICKR_API_KEY")

  if (!is_empty(api_key) && !identical(api_key, "") && is_string(api_key)) {
    return(api_key)
  }

  message <- c(
    "A Flickr API key is required.",
    "*" = "Please create a key at your Flickr account:
          {.url https://www.flickr.com/services/api/misc.api_keys.html}"
  )
  if (!strict) {
    cli_warn(
      message = message,
      ...
    )

    return(invisible(NULL))
  }

  cli_abort(
    message = message,
    call = call
  )
}
#' @export
#' @rdname setFlickrAPIKey
get_flickr_api_key <- getFlickrAPIKey

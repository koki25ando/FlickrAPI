#' Request data from the Flickr API
#'
#' Request data from the Flickr API using the provided method, API key, and any
#' additional values passed to [httr2::req_url_query()].
#'
#' @param method Flickr API method to use for request.
#' @param api_key Flickr API key. If api_key is `NULL`, the function uses
#'   [getFlickrAPIKey()] to use the environment variable "FLICKR_API_KEY" as the
#'   key.
#' @param format Format parameter passed to [httr2::req_url_query()]
#' @param simplifyVector Default to `TRUE`, passed to [httr2::resp_body_json()]
#' @param check_type Default to `FALSE`, passed to [httr2::resp_body_json()]
#' @param ... Additional parameters passed to [httr2::req_url_query()]
#' @export
#' @importFrom httr2 request req_url_query req_perform resp_body_json
#'   resp_body_string resp_body_raw
FlickrAPIRequest <- function(method = NULL,
                             api_key = NULL,
                             format = "json",
                             simplifyVector = TRUE,
                             check_type = FALSE,
                             ...) {
  api_key <- getFlickrAPIKey(api_key)

  req <- httr2::request("https://api.flickr.com/services/rest")

  req <- httr2::req_url_query(
    req,
    method = method,
    api_key = api_key
  )

  req <- httr2::req_url_query(req, ...)

  req <- httr2::req_url_query(req, format = format)

  if (!is.null(format) && (format == "json")) {
    req <- httr2::req_url_query(req, nojsoncallback = "1")
  }

  resp <- httr2::req_perform(req)

  format <- match.arg(format, c("json", "xml", "string", "raw"))

  switch(format,
    "json" = httr2::resp_body_json(resp,
      check_type = check_type,
      simplifyVector = simplifyVector
    ),
    "xml" = httr2::resp_body_json(resp, check_type = check_type),
    "string" = httr2::resp_body_string(resp),
    "raw" = httr2::resp_body_raw(resp)
  )
}

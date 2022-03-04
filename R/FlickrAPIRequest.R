#' Request data from the Flickr API
#'
#' Request data from the Flickr API using the provided method, API key, and any
#' additional values passed to `httr2::req_url_query`.
#'
#' @param method Flickr API method to use for request.
#' @param api_key Flickr API key. If api_key is `NULL`, the function uses
#'   [getFlickrAPIKey()] to use the environment variable "FLICKR_API_KEY" as the
#'   key.
#' @param ... Additional parameters passed to `httr2::req_url_query`
#' @export
FlickAPIRequest <-
  function(method = NULL,
           api_key = NULL,
           ...) {
    api_key <- getFlickrAPIKey(api_key)

    req <-
      httr2::request("https://api.flickr.com/services/rest/") %>%
      httr2::req_url_query(
        method = method,
        api_key = api_key
      ) %>%
      httr2::req_url_query(
        ...
      ) %>%
      httr2::req_url_query(
        format = "json",
        nojsoncallback = "1"
      )

    resp <- httr2::req_perform(req)

    data <- httr2::resp_body_json(resp, simplifyVector = TRUE)

    return(data)
  }

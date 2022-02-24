#' Get a data frame of hot tags for a given time period.
#'
#' @param api_key Flickr API key. If api_key is `NULL`, the function uses
#'   [getFlickrAPIKey()] to use the environment variable "FLICKR_API_KEY" as the
#'   key.
#' @param period The period for which to fetch hot tags. Valid values are day or
#'   week. Defaults to day
#' @param count The number of tags to return. Defaults to 20. Maximum allowed
#'   value is 200.
#'
#' @seealso \url{https://www.flickr.com/services/api/flickr.tags.getHotList.html}
#'
#' @return This function a data frame of hot tags for the given period
#'
#' @examples
#' \dontrun{
#' getHotTags(
#'   api_key = "*********",
#'   period = "day", count = 20
#' )
#' }
#'
#' @export
#' @importFrom RCurl getURL
#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode

getHotTags <- function(api_key = NULL,
                       period = c("day", "week"),
                       count = 20) {
  api_key <- getFlickrAPIKey(api_key)
  period <- match.arg(period)
  url <-
    utils::URLencode(
      paste0(
        "https://api.flickr.com/services/rest/",
        "?method=flickr.tags.getHotList",
        "&api_key=", api_key,
        "&period=", period,
        "&count=", count,
        "&format=json&nojsoncallback=1"
      )
    )
  data <- RCurl::getURL(url, ssl.verifypeer = FALSE) %>%
    jsonlite::fromJSON()
  hot_tags_df <- data$hottags$tag
  names(hot_tags_df)[2] <- "tag"
  return(hot_tags_df)
}

#' @export
#' @rdname getHotTags
get_hot_tags = getHotTags


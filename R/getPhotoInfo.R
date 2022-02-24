#' Download Flickr photo data
#'
#' R access to photo information of photos posted on Flickr via Flickr API.
#'
#' @param api_key Flickr API key
#' @param photo_id The id of the photo to get information for.
#' @param output Output data type. Supported options include "all", "location",
#'   "date", "url" or "tags". If output = "all", the function returns a list
#'   with all available data. Otherwise the function returns a data frame.
#'
#' @seealso \url{https://www.flickr.com/services/api/flickr.photos.getInfo.html}
#'
#' @return This function returns data of specific photo's information.
#'
#' @examples
#' \dontrun{
#' getPhotoInfo(
#'   api_key = "XXXXXXXXXX",
#'   photo_id = "30484882493",
#'   output = "location"
#' )
#' }
#' @aliases get_photo_info
#' @export
#' @importFrom RCurl getURL
#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode
#' @importFrom janitor clean_names

getPhotoInfo <- function(api_key = NULL,
                         photo_id,
                         output = c("location", "date", "url", "tags")) {
  api_key <- getFlickrAPIKey(api_key)

  url <-
    utils::URLencode(
      paste0(
        "https://api.flickr.com/services/rest/",
        "?method=flickr.photos.getInfo",
        "&api_key=", api_key,
        "&photo_id=", photo_id,
        "&format=json&nojsoncallback=1"
      )
    )
  data <- RCurl::getURL(url, ssl.verifypeer = FALSE) %>%
    jsonlite::fromJSON()

  output_data <- data.frame()

  output <- match.arg(tolower(output), c("all", "location", "date", "url", "tags"))

  output_data <- switch(output,
    "all" = data$photo,
    "location" = janitor::clean_names(as.data.frame(data$photo$location)),
    "data" = janitor::clean_names(as.data.frame(data$photo$dates)),
    "url" = janitor::clean_names(as.data.frame(data$photo$urls$url)),
    "tags" = janitor::clean_names(as.data.frame(data$photo$tags$tag))
  )

  return(output_data)
}

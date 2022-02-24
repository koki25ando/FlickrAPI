#' Returns a data of EXIF data for a given photo.
#'
#' Return a data of EXIF data for a given photo. The calling user must have
#' permission to view the photo.
#'
#' @param api_key Your API application key
#' @param photo_id The id of the photo to fetch information for
#'
#' @return This function returns a data frame of EXIF information of given
#'   photograph
#'
#' @examples
#' \dontrun{
#' getExif(api_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", photo_id = "45961963324")
#' }
#'
#' @aliases get_exif
#' @export
#' @importFrom RCurl getURL
#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode

getExif <- function(api_key = NULL,
                    photo_id) {
  api_key <- getFlickrAPIKey(api_key)
  url <-
    utils::URLencode(
      paste0(
        "https://api.flickr.com/services/rest/",
        "?method=flickr.photos.getExif",
        "&api_key=", api_key,
        "&photo_id=", photo_id,
        "&format=json&nojsoncallback=1"
      )
    )
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  as.data.frame(data)
}

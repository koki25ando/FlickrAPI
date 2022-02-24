#' Photos from the given user's photostream
#'
#' Returns photos from the given user's photostream. Only photos visible to the calling user will be returned.
#'
#' @param api_key Your API application key
#' @param user_id The NSID of the user who's photos to return. A value of me return the calling user's photos
#'
#' @return This function return \code{data.frame} including columns:
#' \itemize{
#'  \item id
#'  \item owner
#'  \item secret
#'  \item server
#'  \item farm
#'  \item title
#'  \item ispublic
#'  \item isfriend
#'  \item isfamily
#' }
#'
#' @examples
#' \dontrun{
#' getPhotos(api_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", user_id = "141696738@N08")
#' }
#' @aliases get_photos
#' @export
#' @importFrom RCurl getURL
#' @importFrom jsonlite fromJSON
#' @importFrom utils URLencode

getPhotos <- function(api_key = NULL,
                      user_id) {
  api_key <- getFlickrAPIKey(api_key)

  url <-
    utils::URLencode(
      paste0(
        "https://api.flickr.com/services/rest/",
        "?method=flickr.photos.search",
        "&api_key=", api_key,
        "&user_id=", user_id,
        "&format=json&nojsoncallback=1"
      )
    )
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  as.data.frame(data$photos$photo)
}

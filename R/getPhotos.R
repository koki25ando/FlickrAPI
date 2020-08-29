#' Photos from the given user's photostream
#'
#' Returns photos from the given user's photostream. Only photos visible to the calling user will be returned.
#'
#' @param api_key Your API application key
#' @param user_id The NSID of the user who's photos to return. A value of me return the calling user's photos
#'
#' @author Koki Ando <koki.25.ando@gmail.com>
#'
#' @import RCurl
#' @import jsonlite
#' @import stringr
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
#'   getPhotos(api_key="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", user_id="141696738@N08")
#' }
#'
#' @export


getPhotos <- function(api_key, user_id){
  url = paste0("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=", api_key,
               "&user_id=", stringr::str_replace(user_id, "@", "%40"), "&format=json&nojsoncallback=1")
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  as.data.frame(data$photos$photo)
}

#' Returns a data of EXIF data for a given photo.
#'
#' Return a data of EXIS data for a given photo. The calling user must have permission to view the photo.
#' 
#' @param api_key Your API application key
#' @param photo_id The id of the photo to fetch information for
#' 
#' @author Koki Ando <koki.25.ando@gmail.com>
#'
#' @import RCurl
#' @import jsonlite
#' 
#' @return This function returns a dataframe of Exif information of given photograph
#' 
#' @examples
#' \dontrun{
#'   getExif(api_key="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", photo_id="45961963324")
#' }
#'
#' @export

getExif <- function(api_key, photo_id){
  url <- paste0("https://api.flickr.com/services/rest/?method=flickr.photos.getExif&api_key=", api_key, "&photo_id=",
         photo_id, "&format=json&nojsoncallback=1")
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  as.data.frame(data)
}

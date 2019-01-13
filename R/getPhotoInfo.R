#' Download Flickr Photo Data
#' 
#' R access to photo information of photos posted on flickr via flickr API interface
#'
#' @param api_key Your API application key
#' @param photo_id The id of the photo to get information for
#' @param output Output data type. It depends on what you are interested in. You have to choose from Location, Date, URL or Tags.
#'
#' @author Koki Ando <koki.25.ando@gmail.com>
#' 
#' @import stringr
#' @import RCurl
#' @import jsonlite
#' 
#' @return This function returns data of specific photo's information.
#' 
#' @examples
#' \dontrun{
#'   getPhotoInfo(api_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", photo_id="30484882493", 
#'                output="location")
#' }
#'
#' @export


getPhotoInfo <- function(api_key, photo_id, 
                         output = c("Location", "Date", "URL", "Tags")){
  head_url = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key="
  tail_url = "&format=json&nojsoncallback=1"
  
  url = paste0(head_url, api_key, "&photo_id=",
               photo_id, tail_url)
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  
  if (stringr::str_to_lower(output) == "location") {
    as.data.frame(data$photo$location)
  } else if (stringr::str_to_lower(output) == "date") {
    as.data.frame(data$photo$dates)
  } else if (stringr::str_to_lower(output) == "url") {
    as.data.frame(data$photo$urls$url)
  } else if (stringr::str_to_lower(output) == "tags") {
    as.data.frame(data$photo$tags$tag)
  } else {
    warnings("\nERROR with output argument. 
You have to choose from following options: Location, Date, URL or Tags")
  }
}
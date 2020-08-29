#' Search for photos on Flickr by tags
#'
#' R access to flickr tag search api
#'
#' @param api_key Your API application key
#' @param tags List of tags you wish to search for e.g. c("cats, "dogs)
#' @param page Number specifying which search results page to return. Default is page 1 of results returned.
#' @param per_page Number specifying how many results per page to return. Default 500 results per page.
#'
#' @return This function returns data of specific photos matching search tags.
#' @export
#'
#' @examples
#' \dontrun{
#'   getPhotoSearch(api_key = "XXXXXXXXXX",
#'                tags= "cats")
#' }
getPhotoSearch <- function(api_key, tags, page = 1, per_page = 500){
  url = paste0("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=",
               api_key,
               "&text=", paste(stringr::str_replace(tags, "@", "%40"), collapse = "%2C"),
               "&per_page=", per_page,
               "&page=", page,
               "&format=json&nojsoncallback=1")
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  as.data.frame(data$photos$photo)
}

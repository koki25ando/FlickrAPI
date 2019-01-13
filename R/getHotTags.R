#' Returns a list of hot tags for the given period.
#'
#' @param api_key Your API application key
#' @param period The period for which to fetch hot tags. Valid values are day and week. Defaults to day
#' @param count The number of tags to return. Defaults to 20. Maximum allowed value is 200.
#' 
#' @author Koki Ando
#' 
#' @import RCurl
#' @import jsonlite
#' @import stringr
#' 
#' @return This function a data frame of hot tags for the given period
#' 
#' @examples
#' \dontrun{
#'  getHotTags(api_key = "********************************", 
#'             period = "day", count=20)
#' }
#'
#' @export

getHotTags <- function(api_key, period = "day", count=20){
  head_url = "https://api.flickr.com/services/rest/?method=flickr.tags.getHotList&api_key="
  url = paste0(head_url, api_key, "&period=",
               stringr::str_to_lower(period), "&count=", count, 
               "&format=json&nojsoncallback=1")
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  data$hottags$tag
}
















getExif <- function(api_key, photo_id){
  url <- paste0("https://api.flickr.com/services/rest/?method=flickr.photos.getExif&api_key=", api_key, "&photo_id=", 
         photo_id, "&format=json&nojsoncallback=1")
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  as.data.frame(data)
}




getPhotoInfo <- function(api_key, photo_id, 
                         output = c("Location", "Date", "URL", "Tags")){
  head_url = "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key="
  tail_url = "&format=json&nojsoncallback=1"
  
  url = paste0(head_url, api_key, "&photo_id=",
               photo_id, tail_url)
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  
  if (output == "Location") {
    as.data.frame(data$photo$location)
  } else if (output == "Date") {
    as.data.frame(data$photo$dates)
  } else if (output == "URL") {
    as.data.frame(data$photo$urls$url)
  } else if (output == "Tags") {
    as.data.frame(data$photo$tags$tag)
  } else {
    
  }
}


getPhotoInfo(api_key, photo_id="30484882493", output="URL")

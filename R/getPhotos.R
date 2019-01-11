# Function for getting photos of given Flickr user


getPhotos <- function(api_key, user_id){
  url = paste0("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=", api_key,
               "&user_id=", stringr::str_replace(user_id, "@", "%40"), "&format=json&nojsoncallback=1")
  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)
  data <- jsonlite::fromJSON(raw_data)
  as.data.frame(data$photos$photo)
}

getPhotos(api_key=api_key, user_id="141696738@N08")

# Function for getting location data of given photos
#'
#'
#' @export



getPhotoLocation <- function(api_key, photo_id){
  head_url = "https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key="
  paste0(head_url, api_key,
         "&photo_id=", photo_id, "&format=json&nojsoncallback=1")
}

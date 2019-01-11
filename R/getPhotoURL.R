# Function for getting URL of given photo
#'
#'
#' @export



url_generate <- function(user_id, photo_id){
  head_url = "https://www.flickr.com/photos"
  tail_url = "/in/dateposted/"
  
  url = paste0(head_url, user_id, photo_id, tail_url)
  url
}


# test
user_id = ""
photo_id = ""
url_generate(user_id, photo_id)
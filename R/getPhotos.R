library(tidyverse)
library(RCurl)
library(XML)
library(httr)
api_key = '7f3677333506e37a7b320d65146bc44b'
secret = '45e30d6546350b6e'
app_name = 'FlickrAPI'


myapp<-oauth_app(app_name,key= api_key,secret= secret)   

ep<-oauth_endpoint(request="https://www.flickr.com/services/oauth/request_token",
                   authorize="https://www.flickr.com/services/oauth/authorize",
                   access="https://www.flickr.com/services/oauth/access_token")

sig<-oauth1.0_token(ep,myapp,cache=F)
fl_sig <- sign_oauth1.0(myapp,sig)


getPhotos <- function(api_key, user_id){
  paste0("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=", api_key,
         "&user_id=", stringr::str_replace(user_id, "@", "%40"), "&format=json&nojsoncallback=1")
}



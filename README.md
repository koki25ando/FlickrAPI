# FlickrAPI
An R package that provides an interface to the [Flickr API](https://www.flickr.com/services/api/) and allows R users to download publicly available photo's data posted on Flickr. You can download data such as Location, Exif,

## Installation
```{r}
devtools::install_github("koki25ando/FlickrAPI")
library(FlickrAPI)
```

## Package Contents
+ getPhotos(api_key, user_id)
+ getExif(api_key, photo_id)
+ getPhotoInfo(api_key, photo_id, output)

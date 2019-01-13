# FlickrAPI
An R package that provides an interface to the [Flickr API](https://www.flickr.com/services/api/) and allows R users to download publicly available photo's data posted on Flickr.

## Installation
```{r}
devtools::install_github("koki25ando/FlickrAPI")
library(FlickrAPI)
```

## Package Contents
+ getPhotos(api_key, user_id)
+ getPhotoInfo(api_key, photo_id, output)
+ getExif(api_key, photo_id)

### See Also
[Flickr API](https://www.flickr.com/services/api/)

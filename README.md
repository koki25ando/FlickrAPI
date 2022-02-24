# FlickrAPI <img src="man/figures/logo.png" width="230px" align="right" />

[![CRAN
status](https://www.r-pkg.org/badges/version/FlickrAPI)](https://cran.r-project.org/package=FlickrAPI)
[![Rdoc](http://www.rdocumentation.org/badges/version/FlickrAPI)](http://www.rdocumentation.org/packages/FlickrAPI)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/FlickrAPI)](http://www.r-pkg.org/pkg/FlickrAPI)
[![total downloads](http://cranlogs.r-pkg.org/badges/grand-total/FlickrAPI)](http://cranlogs.r-pkg.org/badges/grand-total/FlickrAPI)

Provides an interface to the [Flickr API](https://www.flickr.com/services/api/) and allows R users to download publicly available photo's data posted on Flickr.

## Installation
```{r}
install.packages("FlickrAPI")
# devtools::install_github("koki25ando/FlickrAPI")
library(FlickrAPI)
```

## Package Contents
+ getPhotos(api_key, user_id)
+ getPhotoInfo(api_key, photo_id, output)
+ getExif(api_key, photo_id)
+ getHotTags(api_key, period, count)
+ getPhotoSearch(api_key, user_id, tags, licence_id, sort, bbox, extras, per_page, page)

### See Also
+ [FlickrAPI Description on CRAN](https://cran.r-project.org/web/packages/FlickrAPI/index.html)
+ [PDF of FlickrAPI](https://cran.r-project.org/web/packages/FlickrAPI/FlickrAPI.pdf)
+ [Flickr API](https://www.flickr.com/services/api/)

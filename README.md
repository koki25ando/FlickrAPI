
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FlickrAPI

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/FlickrAPI)](https://CRAN.R-project.org/package=FlickrAPI)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/FlickrAPI)](https://www.r-pkg.org/pkg/FlickrAPI)
[![total
downloads](https://cranlogs.r-pkg.org/badges/grand-total/FlickrAPI)](https://cranlogs.r-pkg.org/badges/grand-total/FlickrAPI)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

The goal of FlickrAPI is to provide an interface to the [Flickr
API](https://www.flickr.com/services/api/) and allow R users to download
data on public photos uploaded to Flickr.

## Installation

``` r
install.packages("FlickrAPI")
# remotes::install_github("koki25ando/FlickrAPI")
```

After installing, set up a Flickr API key and save it as a local
environment variable using
`setFlickrAPIKey(api_key = "YOUR_API_KEY_HERE", install = TRUE)`. The
Flickr API is available for non-commercial use by outside developers and
is only available for commercial use under prior arrangements. Review
[the Flickr API
documentation](https://www.flickr.com/services/developer/), [API
Overview](https://www.flickr.com/services/api/misc.overview.html), or
[Flickr Developer Guide](https://www.flickr.com/services/developer/) for
more information.

## Example

You can get photos from any individual user using the `getPhotos()`
function.

``` r
library(FlickrAPI)

photos <- getPhotos(user_id = "grand_canyon_nps")
knitr::kable(photos[1,])
```

| id          | owner          | secret     | server | farm | title                                                  | ispublic | isfriend | isfamily |
|:------------|:---------------|:-----------|:-------|-----:|:-------------------------------------------------------|---------:|---------:|---------:|
| 51924677769 | <50693818@N08> | a48d45c811 | 65535  |   66 | 03/03/22 Desert View Amphitheater Reconstruction 40389 |        1 |        0 |        0 |

For more information about any individual image, you can use
`getPhotoInfo()` or the `getExif()` function.

``` r
photo_info <- getPhotoInfo(photo_id = photos$id[1], output = "tags")
knitr::kable(photo_info[c(1:2),])
```

| id                         | author         | authorname       | raw          | content      | machine\_tag |
|:---------------------------|:---------------|:-----------------|:-------------|:-------------|-------------:|
| 50601005-51924677769-83469 | <50693818@N08> | Grand Canyon NPS | Desert View  | desertview   |            0 |
| 50601005-51924677769-26960 | <50693818@N08> | Grand Canyon NPS | Amphitheater | amphitheater |            0 |

``` r
photo_exif <- getExif(photo_id = photos$id[10])
knitr::kable(photo_exif[1,])
```

| tagspace | tagspaceid | tag         | label       | raw  | clean |
|:---------|-----------:|:------------|:------------|:-----|:------|
| JFIF     |          0 | JFIFVersion | JFIFVersion | 1.02 | NA    |

You can also search photos by tag and license.

``` r
photo_search <- getPhotoSearch(
  sort = "date-taken-desc",
  tags = c("cats", "dogs"),
  per_page = 50)

knitr::kable(photo_search[1,])
```

| id          | owner          | secret     | server | farm | title            | ispublic | isfriend | isfamily | img\_url                                                           | img\_height | img\_width | img\_asp |
|:------------|:---------------|:-----------|:-------|-----:|:-----------------|---------:|---------:|---------:|:-------------------------------------------------------------------|------------:|-----------:|---------:|
| 51958193894 | <50281068@N08> | ca8e35eb2b | 65535  |   66 | Cats Of Mei Ling |        1 |        0 |        0 | <https://live.staticflickr.com/65535/51958193894_ca8e35eb2b_s.jpg> |          75 |         75 |        1 |

### See also

-   [FlickrAPI on
    CRAN](https://cran.r-project.org/web/packages/FlickrAPI/index.html)
    ([PDF](https://cran.r-project.org/web/packages/FlickrAPI/FlickrAPI.pdf))
-   [Flickr API](https://www.flickr.com/services/api/)

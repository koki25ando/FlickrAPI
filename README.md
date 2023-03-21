
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

Install [FlickrAPI from
CRAN](https://cran.r-project.org/package=FlickrAPI):

``` r
install.packages("cli")
```

Or install the development version from GitHub:

``` r
pak::pkg_install("koki25ando/FlickrAPI")
```

## Usage

### Setting up an API key

After installing, set up a Flickr API key and save it as a local
environment variable using
`setFlickrAPIKey(api_key = "YOUR_API_KEY_HERE", install = TRUE)`. The
Flickr API is available for non-commercial use by outside developers and
is only available for commercial use under prior arrangements.

Review [the Flickr API
documentation](https://www.flickr.com/services/developer/), [API
Overview](https://www.flickr.com/services/api/misc.overview.html), or
[Flickr Developer Guide](https://www.flickr.com/services/developer/) for
more information.

### Searching photos

You can get photos from any individual user using the `getPhotos()`
function.

``` r
library(FlickrAPI)

photos <- getPhotos(user_id = "grand_canyon_nps")
knitr::kable(photos[1, ])
```

| id         | owner          | secret     | server | farm | title                           | ispublic | isfriend | isfamily | img_url                                                          | img_height | img_width | img_asp |
|:-----------|:---------------|:-----------|:-------|-----:|:--------------------------------|---------:|---------:|---------:|:-----------------------------------------------------------------|-----------:|----------:|--------:|
| 4660884991 | <50693818@N08> | d67d1f6a94 | 4014   |    5 | Grand Canyon - Mather-Point-009 |        1 |        0 |        0 | <https://live.staticflickr.com/4014/4660884991_d67d1f6a94_m.jpg> |        160 |       240 |     1.5 |

For more information about any individual image, you can use
`getPhotoInfo()` or the `getExif()` function.

``` r
photo_info <- getPhotoInfo(photo_id = photos$id[1], output = "tags")
knitr::kable(photo_info[c(1:2), ])
```

|      |
|:-----|
| NA   |
| NA.1 |

``` r
photo_exif <- getExif(photo_id = photos$id[10])
knitr::kable(photo_exif[1, ])
```

| tagspace | tagspaceid | tag         | label       | raw  | clean |
|:---------|-----------:|:------------|:------------|:-----|:------|
| JFIF     |          0 | JFIFVersion | JFIFVersion | 1.02 | NA    |

You can also search photos by tag and license.

``` r
photo_search <- getPhotoSearch(
  sort = "date-taken-desc",
  tags = c("cats", "dogs"),
  per_page = 50
)

knitr::kable(photo_search[1, ])
```

| id          | owner           | secret     | server | farm | title                   | ispublic | isfriend | isfamily |
|:------------|:----------------|:-----------|:-------|-----:|:------------------------|---------:|---------:|---------:|
| 52760841848 | <197879821@N02> | 5a51344dda | 65535  |   66 | Doggo Bloggo via Poop4U |        1 |        0 |        0 |

## Related projects

- [photosearcher](https://github.com/ropensci/photosearcher): A R
  package for accessing the Flickr API.
- [python-flickr-api](https://github.com/alexis-mignon/python-flickr-api):
  A python implementation of the Flickr API.

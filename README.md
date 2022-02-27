
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FlickrAPI

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/FlickrAPI)](https://CRAN.R-project.org/package=FlickrAPI)
[![Rdoc](http://www.rdocumentation.org/badges/version/FlickrAPI)](http://www.rdocumentation.org/packages/FlickrAPI)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/FlickrAPI)](http://www.r-pkg.org/pkg/FlickrAPI)
[![total
downloads](http://cranlogs.r-pkg.org/badges/grand-total/FlickrAPI)](http://cranlogs.r-pkg.org/badges/grand-total/FlickrAPI)
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
knitr::kable(photos[1:4,])
```

| id          | owner          | secret     | server | farm | title                                              | ispublic | isfriend | isfamily |
|:------------|:---------------|:-----------|:-------|-----:|:---------------------------------------------------|---------:|---------:|---------:|
| 51869456865 | <50693818@N08> | 8c05fed584 | 65535  |   66 | Surprise Valley Search and Rescue-August 2021      |        1 |        0 |        0 |
| 51869119754 | <50693818@N08> | d8c24b3191 | 65535  |   66 | Search Team in Surprise Valley                     |        1 |        0 |        0 |
| 51868796456 | <50693818@N08> | 5ecb258d7b | 65535  |   66 | K9 Mazi in action                                  |        1 |        0 |        0 |
| 51857225906 | <50693818@N08> | f95071f3cc | 65535  |   66 | Desert View Amphitheater Reconstruction 01/31/2022 |        1 |        0 |        0 |

For more information about any individual image, you can use
`getPhotosInfo()` or the `getExif()` function.

``` r
photo_info <- getPhotoInfo(photo_id = photos$id[1], output = "tags")
knitr::kable(photo_info)
```

| id                          | author         | authorname       | raw               | content         | machine\_tag |
|:----------------------------|:---------------|:-----------------|:------------------|:----------------|-------------:|
| 50601005-51869456865-282130 | <50693818@N08> | Grand Canyon NPS | search and rescue | searchandrescue |            0 |
| 50601005-51869456865-5867   | <50693818@N08> | Grand Canyon NPS | aviation          | aviation        |            0 |
| 50601005-51869456865-424687 | <50693818@N08> | Grand Canyon NPS | 368               | 368             |            0 |
| 50601005-51869456865-12101  | <50693818@N08> | Grand Canyon NPS | helicopter        | helicopter      |            0 |

``` r
photo_exif <- getExif(photo_id = photos$id[10])
knitr::kable(photo_exif[1:4,])
```

| tagspace | tagspaceid | tag            | label           | raw  | clean |
|:---------|-----------:|:---------------|:----------------|:-----|:------|
| JFIF     |          0 | JFIFVersion    | JFIFVersion     | 1.02 | NA    |
| JFIF     |          0 | ResolutionUnit | Resolution Unit | None | NA    |
| JFIF     |          0 | XResolution    | X-Resolution    | 1    | NA    |
| JFIF     |          0 | YResolution    | Y-Resolution    | 1    | NA    |

You can also search photos by tag and license.

``` r
photo_search <- getPhotoSearch(
  sort = "date-taken-desc",
  tags = c("cats", "dogs"),
  per_page = 50)

knitr::kable(photo_search[1:4,])
```

| id          | owner           | secret     | server | farm | title                                                                                                                                                                                                                                                    | ispublic | isfriend | isfamily |
|:------------|:----------------|:-----------|:-------|-----:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------:|---------:|---------:|
| 51906415945 | <43199415@N08>  | 9866bfb3d1 | 65535  |   66 | Bon+Que+Luna                                                                                                                                                                                                                                             |        1 |        0 |        0 |
| 51906818405 | <13773319@N00>  | 6eb4d2b5f1 | 65535  |   66 | Sunset walk                                                                                                                                                                                                                                              |        1 |        0 |        0 |
| 51905165797 | <135136799@N08> | 22e2d1ceb8 | 65535  |   66 | 🔥🔥                                                                                                                                                                                                                                                       |        1 |        0 |        0 |
| 51906730250 | <66619978@N04>  | 4ac4a74b75 | 65535  |   66 | “Beautiful Girl Creature Riding on Bird”, Created for International Women’s Day, this design was all hand drawn by me, created for use as fabric, wallpaper and home decor items. Original drawn with pencils, pens, pastel pencils and colored pencils. |        1 |        0 |        0 |

### See also

-   [FlickrAPI on
    CRAN](https://cran.r-project.org/web/packages/FlickrAPI/index.html)
    ([PDF](https://cran.r-project.org/web/packages/FlickrAPI/FlickrAPI.pdf))
-   [Flickr API](https://www.flickr.com/services/api/)

#' Get available information for a Flickr photo.
#'
#' R access to photo information of photos posted on Flickr via Flickr API.
#'
#' @inheritParams FlickrAPIRequest
#' @param photo_id The id of the photo to get information for.
#' @param output Output data type. Supported options include "all", "location",
#'   "date", "url" or "tags". If `output = "all"`, the function returns a list
#'   with all available data. Otherwise the function returns a data frame.
#'
#' @seealso
#' - Flickr API Documentation: [flickr.photos.getInfo](https://www.flickr.com/services/api/flickr.photos.getInfo.html)
#'
#' @return This function returns data of specific photo's information.
#'
#' @examples
#' \dontrun{
#' getPhotoInfo(
#'   api_key = get_flickr_api_key(),
#'   photo_id = "30484882493",
#'   output = "location"
#' )
#' }
#' @export
#' @importFrom janitor clean_names

getPhotoInfo <- function(api_key = NULL,
                         photo_id,
                         output = c("location", "date", "url", "tags")) {
  data <-
    FlickrAPIRequest(
      method = "flickr.photos.getInfo",
      api_key = api_key,
      photo_id = photo_id
    )

  output <-
    match.arg(
      tolower(output),
      c("all", "location", "date", "url", "tags")
    )

  switch(output,
    "all" = data$photo,
    "location" = janitor::clean_names(as.data.frame(data$photo$location)),
    "data" = janitor::clean_names(as.data.frame(data$photo$dates)),
    "url" = janitor::clean_names(as.data.frame(data$photo$urls$url)),
    "tags" = janitor::clean_names(as.data.frame(data$photo$tags$tag))
  )
}

#' @export
#' @rdname getPhotoInfo
get_photo_info <- getPhotoInfo

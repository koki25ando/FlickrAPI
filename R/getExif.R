#' Get EXIF data for a Flickr photo.
#'
#' Return a data of EXIF data for a given photo. The calling user must have
#' permission to view the photo.
#'
#' @inheritParams FlickrAPIRequest
#' @param photo_id The id of the photo to fetch information for
#'
#' @return This function returns a data frame of EXIF information of given
#'   photograph
#'
#' @examples
#' \dontrun{
#' getExif(api_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", photo_id = "45961963324")
#' }
#'
#' @export
getExif <- function(api_key = NULL,
                    photo_id = NULL) {
  data <-
    FlickrAPIRequest(
      method = "flickr.photos.getExif",
      api_key = api_key,
      photo_id = photo_id
    )

  return(as.data.frame(data$photo$exif))
}

#' @export
#' @rdname getExif
get_exif <- getExif

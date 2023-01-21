#' Get EXIF data for a Flickr photo.
#'
#' Return a data of EXIF data for a given photo. The calling user must have
#' permission to view the photo.
#'
#' @inheritParams FlickrAPIRequest
#' @param photo_id The id of the photo to fetch EXIF information for.
#' @param secret The secret for the photo. If the correct secret is passed then
#'   permissions checking is skipped. This enables the 'sharing' of individual
#'   photos by passing around the id and secret.
#' @return A data.frame with EXIF information for an image with the provided
#'   photo_id.
#'
#' @examples
#' \dontrun{
#' getExif(
#'   api_key = get_flickr_api_key(),
#'   photo_id = "45961963324"
#' )
#' }
#'
#' @seealso
#' - Flickr API Documentation: [flickr.photos.getExif](https://www.flickr.com/services/api/flickr.photos.getExif.html)
#' @export
getExif <- function(api_key = NULL,
                    photo_id = NULL,
                    secret = NULL) {
  data <-
    FlickrAPIRequest(
      method = "flickr.photos.getExif",
      api_key = api_key,
      photo_id = photo_id,
      secret = secret
    )

  as.data.frame(data$photo$exif)
}

#' @export
#' @rdname getExif
get_exif <- getExif

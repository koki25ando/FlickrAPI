#' Get photos from a Flickr user photo stream.
#'
#' Returns photos from the given user's photo stream. Only photos visible to the
#' calling user will be returned.
#'
#' @param user_id The NSID of the user who's photos to return. A value of "me"
#'   return the calling user's photos.
#' @inheritParams getPhotoSearch
#' @param ... Additional parameters passed to [getPhotoSearch]
#'
#' @return This function returns a \code{data.frame} including columns:
#' \itemize{
#'  \item id
#'  \item owner
#'  \item secret
#'  \item server
#'  \item farm
#'  \item title
#'  \item ispublic
#'  \item isfriend
#'  \item isfamily
#' }
#'
#' @examples
#' \dontrun{
#' getPhotos(api_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", user_id = "141696738@N08")
#' }
#' @export

getPhotos <- function(user_id = NULL,
                      extras = NULL,
                      api_key = NULL,
                      ...) {
  data <-
    getPhotoSearch(
      user_id = user_id,
      extras = extras,
      api_key = api_key,
      ...
    )

  return(data)
}


#' @export
#' @rdname getPhotos
get_photos <- getPhotos

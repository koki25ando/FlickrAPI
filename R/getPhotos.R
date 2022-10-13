#' Get Flickr user photos or a user's favorite photos
#'
#' Returns photos from the given user's photo stream. Only photos visible to the
#' calling user will be returned.
#'
#' For `getFavePhotos` the provided user_id may need to be the NSID code or the
#' user name rather than the typical user id due to some inconsistencies in the
#' Flickr API.
#'
#' @param user_id The NSID of the user whose photos to return. A value of "me"
#'   return the calling user's photos.
#' @inheritParams getPhotoSearch
#' @inheritDotParams getPhotoSearch
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
#' getPhotos(
#'   api_key = get_flickr_api_key(),
#'   user_id = "141696738@N08"
#' )
#' }
#' @name getPhotos
#' @export
getPhotos <- function(user_id = NULL,
                      img_size = "s",
                      extras = NULL,
                      api_key = NULL,
                      ...) {
  getPhotoSearch(
    user_id = user_id,
    img_size = img_size,
    extras = extras,
    api_key = api_key,
    ...
  )
}

#' @name get_photos
#' @rdname getPhotos
#' @export
get_photos <- getPhotos


#' @name getFavePhotos
#' @rdname getPhotos
#' @param fave_date Length 1 or 2 vector with UNIX formatted date (may include
#'   minimum and maximum favorite date).
#' @param public If `TRUE`, get public favorites (no authentication needed). If
#'   `FALSE`, get all favorite (requires authentication for access).
#' @export
#' @importFrom rlang abort
getFavePhotos <- function(user_id = NULL,
                          img_size = "s",
                          extras = NULL,
                          fave_date = NULL,
                          public = TRUE,
                          api_key = NULL,
                          page = NULL,
                          per_page = 100,
                          ...) {
  if (!is.null(user_id) && !grepl("@", user_id)) {
    user_id <- getUserNSID(user_id)
  }

  min_fave_date <- NULL
  max_fave_date <- NULL

  if (!is.null(fave_date)) {
    if (!is.numeric.Date(fave_date)) {
      rlang::abort(
        "`fave_date` must be a UNIX format date."
      )
    }

    min_fave_date <- min(fave_date)
    max_fave_date <- max(fave_date)
  }


  if (!is.null(extras)) {
    extras <-
      getPhotoExtras(
        extras = extras,
        img_size = img_size
      )
  }

  method <- "flickr.favorites.getPublicList"

  if (!public) {
    method <- "flickr.favorites.getList"
  }

  data <-
    FlickrAPIRequest(
      method = method,
      api_key = api_key,
      user_id = user_id,
      extras = extras,
      page = page,
      per_page = per_page,
      ...
    )

  getPhotoData(
    data = data[["photos"]][["photo"]],
    img_size = img_size
  )
}

#' @name get_fave_photos
#' @rdname getPhotos
#' @export
get_fave_photos <- getFavePhotos

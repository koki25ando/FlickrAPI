#' Get Flickr user photos or a user's favorite photos
#'
#' Returns photos from the given user's photo stream. Only photos visible to the
#' calling user will be returned.
#'
#' For [getFavePhotos()] the provided user_id may need to be the NSID code or
#' the user name rather than the typical user id due to some inconsistencies in
#' the Flickr API.
#'
#' @param user_id The NSID of the user whose photos to return. A value of "me"
#'   return the calling user's photos.
#' @inheritParams getPhotoSearch
#' @inheritDotParams getPhotoSearch
#'
#' @returns A `data.frame` with basic information on photos.
#'
#' @examples
#' \dontrun{
#' getPhotos(
#'   api_key = get_flickr_api_key(),
#'   user_id = "141696738@N08"
#' )
#' }
#' @name getPhotos
#' @seealso
#' - Flickr API documentation: [flickr.favorites.getPublicList](https://www.flickr.com/services/api/flickr.favorites.getPublicList.html)
#' or
#' [flickr.favorites.getList](https://www.flickr.com/services/api/flickr.favorites.getList.html)
#'
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
#' @param fave_date Date favorited in any format supported by [as.POSIXlt()].
#'   If fave_date is a length 1 vector, it is treated as a minimum date
#'   uploaded with the maximum set one day later. If fave_date has a length
#'   greater than 1, the minimum and maximum date from the vector are used. If
#'   date is provided, "date_upload" is added to extras.
#' @param public If `TRUE`, get public favorites (no authentication needed). If
#'   `FALSE`, get all favorites (requires authentication for access).
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
    fave_date <- set_date_range_arg(fave_date, numeric = TRUE)
    min_fave_date <- fave_date[1]
    max_fave_date <- fave_date[2]
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
      min_fave_date = min_fave_date,
      max_fave_date = max_fave_date,
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

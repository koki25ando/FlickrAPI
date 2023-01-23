#' Search for photos on Flickr by user id, tags, license, or bounding box
#'
#' Use the Flickr Search API to return pages of photos sorted by date posted,
#' date taken, interestingness, and relevance. Optional search parameters
#' including spatial bounding box, user id, tags, and image license.
#'
#' @inheritParams FlickrAPIRequest
#' @param user_id The NSID of the user with photos to search. If this parameter
#'   is `NULL` passed then all public photos will be searched.
#' @param tags A vector of tags to search for.
#' @param license_id The license id for photos. For possible values, see the
#'   Flickr API method
#'   [flickr.photos.licenses.getInfo](https://www.flickr.com/services/api/flickr.photos.licenses.getInfo.html)
#'   or see details for more information. If license_id is provided, "license"
#'   is added to extras.
#' @param sort Order to sort returned photos. The possible values are:
#'   "date-posted-asc", "date-posted-desc", "date-taken-asc", "date-taken-desc",
#'   "interestingness-desc", "interestingness-asc", and "relevance" The trailing
#'   "-asc" or "-desc" indicator for sort direction is optional when using the
#'   desc parameter.
#' @param desc If `TRUE`, sort in descending order by the selected sort
#'   variable; defaults to `FALSE`.
#' @param bbox A object of class `bbox` or a numeric vector with values for
#'   xmin, ymin, xmax and ymax representing the bottom-left corner of the box
#'   and the top-right corner.
#' @param img_size A character string with the abbreviation for one or more
#'   image sizes ("sq", "t", "s", "q", "m", "n", "z", "c", "l", or "o"). If a
#'   single img_size is provided the url, width, and height columns are renamed
#'   (e.g. img_url instead of url_sq) and an img_asp column is added to the
#'   results; defaults to `NULL`.
#' @param date Date taken in any format supported by [as.POSIXlt()]. If date is
#'   a length 1 vector, it is treated as a minimum date taken with the maximum
#'   set one day later. If date has a length greater than 1, the minimum and
#'   maximum date from the vector are used.  If date is provided,
#'   "date_taken" is added to extras.
#' @param upload_date Date uploaded in any format supported by [as.POSIXlt()].
#'   If upload_date is a length 1 vector, it is treated as a minimum date
#'   uploaded with the maximum set one day later. If date has a length greater
#'   than 1, the minimum and maximum date from the vector are used.  If date is
#'   provided, "date_upload" is added to extras.
#' @param extras A vector of extra information to fetch for each returned
#'   record. Currently supported fields are: c("description", "license",
#'   "date_upload", "date_taken", "owner_name", "icon_server",
#'   "original_format", "last_update", "geo", "tags", "machine_tags", "o_dims",
#'   "views", "media", "path_alias", "url_sq", "url_t", "url_s", "url_q",
#'   "url_m", "url_n", "url_z", "url_c", "url_l", "url_o")
#' @param per_page Number specifying how many results per page to return.
#'   Default 100 results per page. Maximum of 250 if `bbox` provided or 500
#'   otherwise.
#' @param page Number specifying which search results page to return. Default is
#'   page 1 of results returned.
#' @param ... Dots can be used to pass any additional arguments supported by the
#'   [flickr.photos.search](https://www.flickr.com/services/api/flickr.photos.search.html)
#'   API method excluding license, min_taken_date, max_taken_date,
#'   min_upload_date, and max_upload_date which are supported by other named
#'   parameters. Dots also support two legacy parameters: licence_id (variant
#'   spelling for license_id) and geo (set `geo = TRUE` to include "geo" in
#'   extras).
#' @return This function returns data of specific photos matching search
#'   parameters.
#'
#' @details License id options:
#'
#' license_id can be an integer from 0 to 10 or a corresponding license code
#' including:
#'
#' - "c" (All Rights Reserved),
#' - "by-bc-sa" (Attribution-NonCommercial-ShareAlike),
#' - "by-nc" (Attribution-NonCommercial),
#' - "by-nc-nd" (Attribution-NonCommercial-NoDerivs),
#' - "by" (Attribution),
#' - "by-sa" (Attribution-ShareAlike),
#' - "by-nd" (Attribution-NoDerivs),
#' - "nkc" (No known copyright restrictions),
#' - "pd-us" (United States Government Work),
#' - "cc0" (Public Domain Dedication),
#' - or "pd" (Public Domain Mark).
#'
#' @examples
#' \dontrun{
#' # Search for photos tagged "cats" and "dogs"
#' # Return images in descending order of date taken
#' getPhotoSearch(
#'   api_key = get_flickr_api_key(),
#'   sort = "date-taken-desc",
#'   tags = c("cats", "dogs")
#' )
#' }
#' \dontrun{
#' # Search for photos uploaded to the NPS Grand Canyon user account.
#' # Return extra fields including the date taken and square image URL.
#' getPhotoSearch(
#'   api_key = get_flickr_api_key(),
#'   user_id = "grand_canyon_nps",
#'   extras = c("date_taken", "url_sq")
#' )
#' }
#' \dontrun{
#' # Search for photos tagged "panda" in the area of Ueno Zoo, Tokyo, Japan
#' getPhotoSearch(
#'   api_key = get_flickr_api_key(),
#'   tags = "panda",
#'   bbox = c(139.7682226529, 35.712627977, 139.7724605432, 35.7181464141),
#'   extras = c("geo", "owner_name", "tags")
#' )
#' }
#' @seealso
#' - Flickr API Documentation: [flickr.photos.search](https://www.flickr.com/services/api/flickr.photos.search.html)
#' @export
#' @importFrom rlang list2 abort `!!!`

getPhotoSearch <- function(api_key = NULL,
                           user_id = NULL,
                           tags = NULL,
                           license_id = NULL,
                           sort = "date-posted",
                           desc = FALSE,
                           bbox = NULL,
                           img_size = NULL,
                           date = NULL,
                           upload_date = NULL,
                           extras = NULL,
                           per_page = 100,
                           page = NULL,
                           ...) {
  params <- rlang::list2(...)

  if (!is.null(params$licence_id)) {
    license_id <- params$licence_id
    params$licence_id <- NULL
  }

  if (!is.null(license_id)) {
    extras <- c(extras, "license")
    license_id <- set_license_id_arg(license_id)
  }

  min_taken_date <- NULL
  max_taken_date <- NULL

  if (!is.null(date)) {
    extras <- c(extras, "date_taken")
    date <- set_date_range_arg(date)
    min_taken_date <- date[1]
    max_taken_date <- date[2]
  }

  min_upload_date <- NULL
  max_upload_date <- NULL

  if (!is.null(upload_date)) {
    extras <- c(extras, "date_upload")
    upload_date <- set_date_range_arg(upload_date)
    min_upload_date <- upload_date[1]
    max_upload_date <- upload_date[2]
  }

  sort <- set_sort_arg(sort, desc)

  geo <- params$geo
  params$geo <- NULL

  if (!is.null(c(extras, geo, img_size))) {
    extras <- getPhotoExtras(extras, geo = geo, img_size = img_size)
  }

  if (!is.null(bbox)) {
    bbox_check <- (length(bbox) == 4) && is.numeric(bbox)
    if (!bbox_check) {
      rlang::abort("The `bbox` argument must be a 'bbox' class object or
                   a numeric vector with xmin, ymin, xmax and ymax values.")
    }
    bbox <- paste0(bbox, collapse = ",")
  }

  if (!is.null(tags)) {
    tags <- paste(unique(tags), collapse = ",")
  }

  data <-
    FlickrAPIRequest(
      method = "flickr.photos.search",
      api_key = api_key,
      format = "json",
      simplifyVector = TRUE,
      check_type = FALSE,
      user_id = user_id,
      tags = tags,
      per_page = per_page,
      page = page,
      bbox = bbox,
      license = license_id,
      sort = sort,
      extras = extras,
      min_taken_date = min_taken_date,
      max_taken_date = max_taken_date,
      min_upload_date = min_upload_date,
      max_upload_date = max_upload_date,
      !!!params
    )

  getPhotoData(
    data = data[["photos"]][["photo"]],
    img_size = img_size
  )
}

#' @export
#' @rdname getPhotoSearch
get_photo_search <- getPhotoSearch

#' Set the sort API argument
#'
#' @noRd
set_sort_arg <- function(sort = NULL, desc = FALSE) {
  if (any(c(is.null(sort), identical(sort, "relevance")))) {
    return(sort)
  }

  sort_opts <- c("date-posted", "date-taken", "interestingness")
  dir <- c("-asc", "-desc")
  dir_suffix <- ""

  if (!grepl("-desc$|-asc$", sort)) {
    dir_suffix <- dir[[1]]
    if (desc) {
      dir_suffix <- dir[[2]]
    }
  }

  sort <- paste0(tolower(sort), dir_suffix)
  match.arg(sort, paste0(sort_opts, rep(dir, 3)))
}

#' Set the min/max date taken or date uploaded API arguments
#'
#' @noRd
#' @importFrom rlang try_fetch abort caller_arg
set_date_range_arg <- function(x,
                               arg = rlang::caller_arg(x),
                               n = 2,
                               numeric = FALSE,
                               call = parent.frame()) {
  if (!is.numeric.POSIXt(x)) {
    x <- rlang::try_fetch(
      as.POSIXlt(x),
      error = function(cnd) {
        rlang::abort(
          paste0("`", arg, "` can't be coerced into a date with `as.POSIXlt`."),
          parent = cnd,
          call = call
        )
      }
    )
  }

  if (length(x) == 1) {
    x <- seq.POSIXt(x, by = "day", length.out = n)
  }

  if (isTRUE(numeric)) {
    return(as.double(c(min(x), max(x))))
  }

  strftime(c(min(x), max(x)), format = "%F %X")
}


#' Set the license_id API argument
#'
#' @noRd
#' @importFrom rlang abort
set_license_id_arg <- function(license_id, call = parent.frame()) {
  if (suppressWarnings(as.integer(license_id) %in% c(0:10))) {
    return(license_id)
  }

  if (!is.character(license_id)) {
    rlang::abort(
      "The `license_id` argument must be a documented license id or an integer
      from 0 to 10.",
      call = call
    )
  }

  license_id <-
    match.arg(
      tolower(license_id),
      c(
        "c", "by-bc-sa", "by-nc", "by-nc-nd", "by",
        "by-sa", "by-nd", "nkc", "pd-us", "cc0", "pd"
      )
    )

  switch(license_id,
    "c" = 0,
    "by-bc-sa" = 1,
    "by-nc" = 2,
    "by-nc-nd" = 3,
    "by" = 4,
    "by-sa" = 5,
    "by-nd" = 6,
    "nkc" = 7,
    "pd-us" = 8,
    "cc0" = 9,
    "pd" = 10
  )
}

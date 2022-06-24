#' Search for photos on Flickr by user id, tags, license, or bounding box
#'
#' Use the Flickr Search API to return pages of photos sorted by date posted,
#' date taken, interestingness, and relevance. Optional search parameters
#' including spatial bounding box, user id, tags, and image license.
#'
#' @inheritParams FlickAPIRequest
#' @param user_id The NSID of the user with photos to search. If this parameter
#'   is NULL passed then all public photos will be searched.
#' @param tags A vector of tags to search for.
#' @param license_id The license id for photos. For possible values see the
#'   Flickr API method flickr.photos.licenses.getInfo or see details for more information.
#' @param sort Order to sort returned photos. The possible values are:
#'   "date-posted-asc", "date-posted-desc", "date-taken-asc", "date-taken-desc",
#'   "interestingness-desc", "interestingness-asc", and "relevance" The trailing
#'   "-asc" or "-desc" indicator for sort direction is optional when using the
#'   desc parameter.
#' @param desc If `TRUE`, sort in descending order by the selected sort variable;
#'   defaults to `FALSE`.
#' @param bbox A object of class `bbox` or a numeric vector with values for
#'   xmin, ymin, xmax and ymax representing the bottom-left corner of the box
#'   and the top-right corner.
#' @param img_size A character string with the abbreviation for one or more
#'   image sizes ("sq", "t", "s", "q", "m", "n", "z", "c", "l", or "o"). If a
#'   single img_size is provided the url, width, and height columns are renamed
#'   (e.g. img_url instead of url_sq) and an img_asp column is added to the
#'   results; defaults to `NULL`.
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
#' @param ... Additional parameters that can include licence_id (legacy spelling),
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
#'   api_key = "XXXXXXXXXX",
#'   sort = "date-taken-desc",
#'   tags = c("cats", "dogs")
#' )
#' }
#' \dontrun{
#' # Search for photos uploaded to the NPS Grand Canyon user account.
#' # Return extra fields including the date taken and square image URL.
#' getPhotoSearch(
#'   api_key = "XXXXXXXXXX",
#'   user_id = "grand_canyon_nps",
#'   extras = c("date_taken", "url_sq")
#' )
#' }
#' \dontrun{
#' # Search for photos tagged "panda" in the area of Ueno Zoo, Tokyo, Japan
#' getPhotoSearch(
#'   api_key = "XXXXXXXXXX",
#'   tags = "panda",
#'   bbox = c(139.7682226529, 35.712627977, 139.7724605432, 35.7181464141),
#'   extras = c("geo", "owner_name", "tags")
#' )
#' }
#' @export
#' @importFrom rlang list2

getPhotoSearch <- function(api_key = NULL,
                           user_id = NULL,
                           tags = NULL,
                           license_id = NULL,
                           sort = "date-posted",
                           desc = FALSE,
                           bbox = NULL,
                           img_size = NULL,
                           extras = NULL,
                           per_page = 100,
                           page = NULL,
                           ...) {
  params <- rlang::list2(...)

  if (!is.null(params$licence_id)) {
    license_id <- params$licence_id
  }

  if (!is.null(license_id)) {
    stopifnot(
      "The `license_id` argument must be a documented license id or an integer from 0 to 10." =
        is.character(license_id) | (license_id %in% c(0:10))
    )

    if (is.character(license_id)) {
      license_id <- switch(license_id,
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
  }

  if (!is.null(sort) && (sort != "relevance")) {
    sort_opts <- c("date-posted", "date-taken", "interestingness")

    dir <- c("-asc", "-desc")

    if (!grepl("-desc$|-asc$", sort)) {
      if (desc) {
        dir <- dir[[2]]
      } else {
        dir <- dir[[1]]
      }

      sort <- paste0(sort, dir)
    }

    sort <- match.arg(sort, paste0(sort_opts, rep(dir, 3)))
  }

  if (!is.null(extras)) {
  extras <- getPhotoExtras(extras, geo = params$geo, img_size = img_size)
  }

  if (!is.null(bbox)) {
    stopifnot(
      "The `bbox` argument must be a 'bbox' class object or a numeric vector with xmin, ymin, xmax and ymax values." =
        (("bbox" %in% class(bbox)) || ((length(bbox) == 4) && is.numeric(bbox)))
    )

    bbox <- paste0(bbox, collapse = ",")
  }

  if (!is.null(tags)) {
    tags <- paste(unique(tags), collapse = ",")
  }

  data <-
    FlickAPIRequest(
      method = "flickr.photos.search",
      api_key = api_key,
      user_id = user_id,
      tags = tags,
      per_page = per_page,
      page = page,
      bbox = bbox,
      license = license_id,
      sort = sort,
      extras = extras
    )

  getPhotoData(
    data = data[["photos"]][["photo"]],
    img_size = img_size
  )
}

#' @export
#' @rdname getPhotoSearch
get_photo_search <- getPhotoSearch

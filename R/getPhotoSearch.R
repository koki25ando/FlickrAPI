#' Search for photos on Flickr by user id, tags, license, or bounding box
#'
#' R access to Flickr search api
#'
#' @param api_key Required. Your API application key
#' @param user_id The NSID of the user who's photo to search. If this parameter isn't passed then everybody's public photos will be searched.
#' @param tags List of tags you wish to search for e.g. c("cats, "dogs)
#' @param licence_id The license id for photos (for possible values see the Flickr API method flickr.photos.licenses.getInfo).
#' @param sort Order to sort returned photos. The possible values are: "date-posted-asc", "date-posted-desc", "date-taken-asc", "date-taken-desc", "interestingness-desc", "interestingness-asc", and "relevance"
#' @param bbox A object of class bbox or a numeric vector with values for xmin, ymin, xmax and ymax representing the bottom-left corner of the box and the top-right corner.
#' @param extras A vector of extra information to fetch for each returned record. Currently supported fields are: c("description", "license", "date_upload", "date_taken", "owner_name", "icon_server", "original_format", "last_update", "geo", "tags", "machine_tags", "o_dims", "views", "media", "path_alias", "url_sq", "url_t", "url_s", "url_q", "url_m", "url_n", "url_z", "url_c", "url_l", "url_o")
#' @param per_page Number specifying how many results per page to return. Default 100 results per page. Maximum of 250 if bbox provided or 500 otherwise.
#' @param page Number specifying which search results page to return. Default is page 1 of results returned.
#' @return This function returns data of specific photos matching search parameters.
#'
#' @examples
#' \dontrun{
#' # Search for photos tagged "cats"
#' # Return images in descending order of date taken
#'   getPhotoSearch(api_key = "XXXXXXXXXX",
#'                sort = "date-taken-desc",
#'                tags = "cats")
#' }
#' \dontrun{
#' # Search for photos uploaded to the NPS Grand Canyon user account.
#' # Return extra fields including the date taken and square image URL.
#'   getPhotoSearch(api_key = "XXXXXXXXXX",
#'                user_id = "grand_canyon_nps",
#'                extras = c("date_taken", "url_sq"))
#' }
#' \dontrun{
#' # Search for photos tagged "panda" in the area of Ueno Zoo, Tokyo, Japan
#' getPhotoSearch(api_key = "XXXXXXXXXX",
#'                tags = "panda",
#'                bbox = c(139.7682226529, 35.712627977, 139.7724605432, 35.7181464141),
#'                extras = c("geo", "owner_name", "tags"))
#' }
#'
#' @export

getPhotoSearch <- function(api_key,
                           user_id = NULL,
                           tags = NULL,
                           licence_id = NULL,
                           sort = "date-posted-asc",
                           bbox = NULL,
                           extras,
                           per_page = 100,
                           page = 1) {
  url = paste0(
    "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=",
    api_key,
    "&user_id=",
    stringr::str_replace(user_id, "@", "%40"),
    "&tags=",
    paste(stringr::str_replace(tags, "@", "%40"), collapse = "%2C")
  )

  if (!missing(licence_id) && !(licence_id %in% c(0:10))) {
    stop("The license id provided is not valid. The license id must be an integer from 0 to 10.")
  }

  url = paste0(url, "&license=", licence_id)

  if (!(sort %in% c("date-posted-asc", "date-posted-desc", "date-taken-asc", "date-taken-desc", "interestingness-desc", "interestingness-asc", "relevance"))) {
    stop("The sort provided is not valid. Possible sort values are: date-posted-asc, date-posted-desc, date-taken-asc, date-taken-desc, interestingness-desc, interestingness-asc, and relevance.")
  }

  url = paste0(url, "&sort=", sort)

  if (class(bbox) != "bbox" && length(bbox) != 4) {
    stop("The bbox provided is not valid. The bbox must be an object of class 'bbox' or a numeric vector with xmin, ymin, xmax and ymax values.")
  }

  bbox = paste0(bbox[1], ",", bbox[2], ",", bbox[3], ",", bbox[4])
  url = paste0(url, "&bbox=", bbox)

  if (!missing(extras)) {
    extra_fields = c("description", "license", "date_upload", "date_taken", "owner_name", "icon_server", "original_format", "last_update", "geo", "tags", "machine_tags", "o_dims", "views", "media", "path_alias", "url_sq", "url_t", "url_s", "url_q", "url_m", "url_n", "url_z", "url_c", "url_l", "url_o")

    # Check if all elements of extras are valid extra fields
    if (sum(vapply(extras, function(x) {
      x %in% extra_fields
    }, logical(1))) < length(extras)) {
      stop(paste0("One or more of the extra fields provided is not valid or supported. Supported extra fields are: ", paste0(extra_fields, collapse = ", ")))
    }

    url = paste0(url, "&extras=", paste0(extras, collapse = ","))
  }

  url = paste0(
    url,
    "&per_page=", per_page,
    "&page=", page,
    "&format=json&nojsoncallback=1"
  )

  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE, .mapUnicode = FALSE)

  data <- jsonlite::fromJSON(raw_data)

  as.data.frame(data$photos$photo)
}

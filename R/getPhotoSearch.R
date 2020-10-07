#' Search for photos on Flickr by user id, tags, license, or bounding box
#'
#' R access to flickr search api
#'
#' @param api_key Required. Your API application key
#' @param user_id The NSID of the user who's photo to search. If this parameter isn't passed then everybody's public photos will be searched.
#' @param tags List of tags you wish to search for e.g. c("cats, "dogs)
#' @param license_id The license id for photos (for possible values see the Flickr API method flickr.photos.licenses.getInfo).
#' @param bbox A object of class bbox or a comma-delimited list of 4 values defining the Bounding Box of the area that will be searched. The 4 values represent the bottom-left corner of the box and the top-right corner, minimum_longitude, minimum_latitude, maximum_longitude, maximum_latitude.
#' @param extras A vector of extra information to fetch for each returned record. Currently supported fields are: c("description", "license", "date_upload", "date_taken", "owner_name", "icon_server", "original_format", "last_update", "geo", "tags", "machine_tags", "o_dims", "views", "media", "path_alias", "url_sq", "url_t", "url_s", "url_q", "url_m", "url_n", "url_z", "url_c", "url_l", "url_o")
#' @param per_page Number specifying how many results per page to return. Default 100 results per page. Maximum of 250 if bbox provided or 500 otherwise.
#' @param page Number specifying which search results page to return. Default is page 1 of results returned.
#' @return This function returns data of specific photos matching search parameters.
#' @export
#'
#' @examples
#' \dontrun{
#'   getPhotoSearch(api_key = "XXXXXXXXXX",
#'                tags= "cats")
#' }

getPhotoSearch <- function(api_key,
                           user_id,
                           tags,
                           licence_id,
                           bbox,
                           extras,
                           per_page = 100,
                           page = 1) {
  url = paste0(
    "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=",
    api_key
  )

  if (!missing(user_id)) {
    url = paste0(
      url,
      "&user_id=",
      stringr::str_replace(user_id, "@", "%40")
    )
  }

  if (!missing(tags)) {
    url = paste0(
      url,
      "&tags=",
      paste(stringr::str_replace(tags, "@", "%40"), collapse = "%2C")
    )
  }

  if (!missing(licence_id)) {
    if (!(licence_id %in% c(0:10))) {
      stop("Provided license id is not valid. The license id must be an integer from 0 to 10.")
    }

    url = paste0(url, "&license=", licence_id)
  }

  if (!missing(bbox)) {
    if (class(bbox) == "bbox") {
      bbox = paste0(bbox[1], ",", bbox[2], ",", bbox[3], ",", bbox[4])
    }

    url = paste0(url, "&bbox=", bbox)
  }

  if (!missing(extras)) {
    extra_fields = c("description", "license", "date_upload", "date_taken", "owner_name", "icon_server", "original_format", "last_update", "geo", "tags", "machine_tags", "o_dims", "views", "media", "path_alias", "url_sq", "url_t", "url_s", "url_q", "url_m", "url_n", "url_z", "url_c", "url_l", "url_o")

    # Check if all elements of extras are valid extra fields
    if (sum(vapply(extras, function(x) {
      x %in% extra_fields
    }, logical(1))) < length(extras)) {
      stop(paste0("One or more of the extra fields provided is not valid or is not supported. Supported extra fields are: ", paste0(extra_fields, collapse = ", ")))
    }

    url = paste0(url, "&extras=", paste0(extras, collapse = ","))
  }

  url = paste0(
    url,
    "&per_page=", per_page,
    "&page=", page,
    "&format=json&nojsoncallback=1"
  )


  raw_data <- RCurl::getURL(url, ssl.verifypeer = FALSE)

  data <- jsonlite::fromJSON(raw_data)

  as.data.frame(data$photos$photo)
}

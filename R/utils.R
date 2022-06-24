utils::globalVariables(c("img_height", "img_width"))

#' Get Flickr user NSID
#'
#' @noRd
getUserNSID <- function(user_id,
                        api_key = NULL) {
  FlickrAPIRequest(
    method = "flickr.people.findByUsername",
    username = user_id,
    api_key = api_key
  )[["user"]][["nsid"]]
}

#' Get Flickr extras to return
#'
#' @noRd
getPhotoExtras <- function(extras, geo = NULL, img_size = NULL, fields = NULL) {
  if (!is.null(geo) && geo) {
    # Always include geo in the extras if geo is TRUE
    extras <- c(extras, "geo")
  }

  # Add url of select size to extras if img_size is provided
  if (!is.null(img_size)) {
    img_size <-
      match.arg(
        img_size,
        c("sq", "t", "s", "q", "m", "n", "z", "c", "l", "o"),
        several.ok = TRUE
      )

    extras <- c(extras, paste0("url_", img_size))
  }

  if (is.null(fields)) {
    fields <-
      c(
        "description", "license", "date_upload", "date_taken", "owner_name",
        "icon_server", "original_format", "last_update", "geo", "tags", "machine_tags",
        "o_dims", "views", "media", "path_alias", "url_sq", "url_t", "url_s", "url_q",
        "url_m", "url_n", "url_z", "url_c", "url_l", "url_o"
      )
  }

  # Check if all elements of extras are valid extra fields
  extras <- match.arg(extras, fields, several.ok = TRUE)

  paste0(unique(extras), collapse = ",")
}



#' Get a data frame with photos and optional image aspect ratio
#'
#' @noRd
getPhotoData <- function(data,
                         img_size = NULL) {
  data <- as.data.frame(data)

  if ((nrow(data) == 0)) {
    return(data)
  }

  if (!is.null(img_size) && (length(img_size) > 1)) {
    names(data)[names(data) == paste0("url_", img_size)] <- "img_url"
    names(data)[names(data) == paste0("width_", img_size)] <- "img_width"
    names(data)[names(data) == paste0("height_", img_size)] <- "img_height"

    data <- within(data, {
      img_asp <- img_width / img_height
    })
  }

  data
}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getPhotoSearch.R
\name{getPhotoSearch}
\alias{getPhotoSearch}
\title{Search for photos on Flickr by user id, tags, license, or bounding box}
\usage{
getPhotoSearch(
  api_key,
  user_id = NULL,
  tags = NULL,
  licence_id = NULL,
  sort = "date-posted-asc",
  bbox = NULL,
  extras,
  per_page = 100,
  page = 1
)
}
\arguments{
\item{api_key}{Required. Your API application key}

\item{user_id}{The NSID of the user who's photo to search. If this parameter isn't passed then everybody's public photos will be searched.}

\item{tags}{List of tags you wish to search for e.g. c("cats, "dogs)}

\item{licence_id}{The license id for photos (for possible values see the Flickr API method flickr.photos.licenses.getInfo).}

\item{sort}{Order to sort returned photos. The possible values are: "date-posted-asc", "date-posted-desc", "date-taken-asc", "date-taken-desc", "interestingness-desc", "interestingness-asc", and "relevance"}

\item{bbox}{A object of class bbox or a numeric vector with values for xmin, ymin, xmax and ymax representing the bottom-left corner of the box and the top-right corner.}

\item{extras}{A vector of extra information to fetch for each returned record. Currently supported fields are: c("description", "license", "date_upload", "date_taken", "owner_name", "icon_server", "original_format", "last_update", "geo", "tags", "machine_tags", "o_dims", "views", "media", "path_alias", "url_sq", "url_t", "url_s", "url_q", "url_m", "url_n", "url_z", "url_c", "url_l", "url_o")}

\item{per_page}{Number specifying how many results per page to return. Default 100 results per page. Maximum of 250 if bbox provided or 500 otherwise.}

\item{page}{Number specifying which search results page to return. Default is page 1 of results returned.}
}
\value{
This function returns data of specific photos matching search parameters.
}
\description{
R access to Flickr search api
}
\examples{
\dontrun{
# Search for photos tagged "cats"
# Return images in descending order of date taken
  getPhotoSearch(api_key = "XXXXXXXXXX",
               sort = "date-taken-desc",
               tags = "cats")
}
\dontrun{
# Search for photos uploaded to the NPS Grand Canyon user account.
# Return extra fields including the date taken and square image URL.
  getPhotoSearch(api_key = "XXXXXXXXXX",
               user_id = "grand_canyon_nps",
               extras = c("date_taken", "url_sq"))
}
\dontrun{
# Search for photos tagged "panda" in the area of Ueno Zoo, Tokyo, Japan
getPhotoSearch(api_key = "XXXXXXXXXX",
               tags = "panda",
               bbox = c(139.7682226529, 35.712627977, 139.7724605432, 35.7181464141),
               extras = c("geo", "owner_name", "tags"))
}

}

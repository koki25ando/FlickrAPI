#' Get a data frame of hot tags for a given time period.
#'
#' @inheritParams FlickrAPIRequest
#' @param period The period for which to fetch hot tags. Valid values are day or
#'   week. Defaults to day
#' @param count The number of tags to return. Defaults to 20. Maximum allowed
#'   value is 200.
#'
#' @seealso
#' - Flickr API Documentation: [flickr.tags.getHotList](https://www.flickr.com/services/api/flickr.tags.getHotList.html)
#'
#' @return This function a data frame of hot tags for the given period
#'
#' @examples
#' \dontrun{
#' getHotTags(
#'   api_key = get_flickr_api_key(),
#'   period = "day",
#'   count = 20
#' )
#' }
#'
#' @export
getHotTags <- function(api_key = NULL,
                       period = c("day", "week"),
                       count = 20) {
  period <- match.arg(period)

  data <-
    FlickrAPIRequest(
      method = "flickr.tags.getHotList",
      api_key = api_key,
      period = period,
      count = count
    )

  hot_tags_df <- data$hottags$tag
  names(hot_tags_df)[2] <- "tag"
  hot_tags_df
}

#' @export
#' @rdname getHotTags
get_hot_tags <- getHotTags

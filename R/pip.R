#' Title
#'
#' @param pts
#' @param coords
#'
#' @return
#' @export
#'
#' @examples
inside_cpp11 <- function(pts, coords) {
  InPoly_cpp(pts[,1], pts[,2], coords[,1], coords[,2])
}

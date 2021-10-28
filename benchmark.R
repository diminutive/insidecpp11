coords = structure(c(0.191915028329653, 0.242440023683676,
                     0.435140005964137, 0.750039977007818, 0.794689972902072,
                     0.569089993646897, 0.308240017633102, 0.191915028329653,
                     0.303924266802157, 0.661208259237305, 0.7774331724391,
                     0.725777655460525, 0.340513591328648, 0.179090100770599,
                     0.224288678126852, 0.303924266802157), .Dim = c(8L, 2L
                     ))

pts <- structure(c(0.193090028221607, 0.134340033623905, 0.194265028113561,
                   0.358765012987125, 0.527964997428506, 0.829939969660693, 0.896914963502072,
                   0.146805402658989, 0.461043130945324, 0.74514847432749, 0.626771247918254,
                   0.306076580009597, 0.187699353600361, 0.506241708301578), .Dim = c(7L,
                                                                                      2L), .Dimnames = list(NULL, c("x", "y")))

data("wrld_simpl", package = "maptools")
sfx <- sf::st_as_sf(wrld_simpl)
df <- sfheaders::sf_to_df(sfx)
df$ring_id <- paste(df$multipolygon_id, df$polygon_id, df$linestring_id)
nn <- 1e4
listofcoords <- lapply(split(df[c("x", "y")], df$ring), function(ax) as.matrix(tibble::as_tibble(ax)))
listofpoints <- lapply(listofcoords, function(mx) cbind(runif(nn, min(mx[,1]), max(mx[,1])),
                                                        runif(nn, min(mx[,2]), max(mx[,2]))))



rbenchmark::benchmark(
  insidesexp = {for (i in seq_along(listofcoords)) {pts <- listofpoints[[i]]; coords <- listofcoords[[i]];
                    insidesexp::inside_sexp(pts, coords)}},
  insidesp = {for (i in seq_along(listofcoords)) {pts <- listofpoints[[i]]; coords <- listofcoords[[i]];
      insidesp::inside_sp(pts, coords)}},
  #insidecpp11 = {for (i in seq_along(listofcoords)) {pts <- listofpoints[[i]]; coords <- listofcoords[[i]];
  #                  insidecpp11::inside_cpp11(pts, coords)}},
  polyclip = { for (i in seq_along(listofcoords)) {pts <- listofpoints[[i]]; coords <- listofcoords[[i]];polyclip::pointinpolygon(list(x = pts[,1], y = pts[,2]),
                                        list(x = coords[,1], y = coords[,2]))}},
  cgal = { for (i in seq_along(listofcoords)) {pts <- listofpoints[[i]]; coords <- listofcoords[[i]];
  insidecgal:::point_in_polygon_cgal(pts[,1], pts[,2], coords[,1], coords[,2])}}

  ,
  replications = 5)

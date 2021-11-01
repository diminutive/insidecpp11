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
nn <- 3e3
listofcoords <- lapply(split(df[c("x", "y")], df$ring), function(ax) as.matrix(tibble::as_tibble(ax)))
listofpoints <- lapply(listofcoords, function(mx) cbind(runif(nn, min(mx[,1]), max(mx[,1])),
                                                        runif(nn, min(mx[,2]), max(mx[,2]))))


listofx <- split(df$x, df$ring)
listofy <- split(df$y, df$ring)

wrld_simpl@proj4string@projargs[1] <- NA_character_
## this seems faster though it wasn't in another test (and we still have to coalesce the rings anyway)
rbenchmark::benchmark(
  spover = sp::over(SpatialPoints(pts), as(wrld_simpl, "SpatialPolygons")),
  clipperlist = insideclipper::inside_clipper_loop(pts, listofx, listofy),
  replications = 5
)

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
  insidecgal:::point_in_polygon_cgal(pts[,1], pts[,2], coords[,1], coords[,2])}},
  clipper = { for (i in seq_along(listofcoords)) {pts <- listofpoints[[i]]; coords <- listofcoords[[i]];
  insideclipper::inside_clipper(pts, coords)}},

  ,
  replications = 5)


#         test replications elapsed relative user.self sys.self user.child sys.child
# 4       cgal            5   5.848    1.031     5.851    0.000          0         0
# 5    clipper            5   5.670    1.000     5.676    0.001          0         0
# 1 insidesexp            5  18.900    3.333    18.911    0.000          0         0
# 2   insidesp            5  14.592    2.574    14.607    0.000          0         0
# 3   polyclip            5   6.632    1.170     6.637    0.000          0         0



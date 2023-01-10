detach("package:gdistance", unload = TRUE)
detach("package:raster", unload = TRUE)
detach("package:Rcpp", unload = TRUE)
detach("package:sp", unload = TRUE)

remotes::install_version("raster", "2.6.7")
install.packages("raster")

library(gdistance)
library(raster)

library("gdistance")
set.seed(123)
r <- gdistance::raster(ncol=3,nrow=3)
r[] <- 1:ncell(r)
r
r[] <- 1
r
tr1 <- transition(r, transitionFunction=mean, directions=8)

cost <- raster(nrow=100, ncol=100, 
               xmn=0, xmx=100, ymn=0, ymx=100, crs="+proj=utm")
cost[] <- 10
origin <- c(50, 1)
goal <- c(50, 100)

plot(cost)

cc2 <- cellFromRowColCombine(cost, 50,20:80)
cost2 <- cost
cost2[cc2] <- 0 

plot(cost2)

trCost2 <- transition(cost2, transitionFunction = min, 8)
trCost2 <- geoCorrection(trCost2, type="c")

plot(trCost2)

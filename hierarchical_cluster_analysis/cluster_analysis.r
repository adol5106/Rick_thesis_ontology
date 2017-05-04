ChulaVistaData = read.csv("chula_vistav2.csv", header = TRUE)

hw.ChulaVistaData <- ChulaVistaData[,c("FID","X","Y")]
hw.ChulaData <- data.frame(hw.ChulaVistaData,
   FID = ChulaVistaData$FID,
   X = ChulaVistaData$X,
   Y = ChulaVistaData$Y
 )

install.packages("NbClust")
library(NbClust)
var.hw.data <- hw.ChulaData[,c("X","Y")]
#index.hw.data <- NbClust(var.hw.data, distance="euclidean", min.nc=2, max.nc=21, method = "single", index = "ccc")
#index.hw.data <- NbClust(var.hw.data, distance="euclidean", min.nc=2, max.nc=21, method = "single", index = "ch")
#index.hw.data <- NbClust(var.hw.data, distance="euclidean", min.nc=2, max.nc=21, method = "single", index = "pseudot2")
#index.hw.data <- NbClust(var.hw.data, distance="euclidean", min.nc=2, max.nc=21, method = "single", index = "dindex")

hw.dend.data <- hw.ChulaData[,c("X","Y")]
hw.clusData <- hclust(dist(hw.dend.data), method="single")
hw.clusData$labels<-hw.ChulaData$FID  
plot(hw.clusData, hang = -1, main = "Single Linkage Cluster Analysis")
rect.hclust(hw.clusData, k=6, border="red") 

 
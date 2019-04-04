#!/usr/bin/Rscript
library(stringr)
args <- commandArgs(trailingOnly = TRUE) #Quelldatei wird aus Command Line übernommen.
inhalt <- readLines(args)
limits <- vector()
c <- 0

for (line in inhalt) #Punktmatrizen werden aus dem Datei isolieren
  {
  c = c+1
  if (identical(substring(line,1,1), "G")==TRUE || identical(substring(line,1,1), "-")==TRUE)
    {
    limits <- c(limits, c)
    }
  }

dBeg<- limits[1] #Grenzen der Punktematrizen
dEnd<- limits[2]
rBeg<- limits[3]
rEnd<- limits[4]
cBeg<- limits[5]
cEnd<- limits[6]


g_down <- read.table(args, sep = "", skip = dBeg, nrows = dEnd-dBeg-1) # Matrizen werden in eigene Dataframes gespeichert
g_right <- read.table(args, sep = "", skip = rBeg, nrows = rEnd-rBeg-1)
g_diag <- read.table(args, sep = "", skip = cBeg, nrows = cEnd-cBeg-1)

N <- dim(g_right)[2]
raster <- matrix(0L, ncol = N+1, nrow = N+1) #Leere Matrize für die Punktekarte

for (i in 1:N) #Initialisierung der ersten Zeile und Spalte
{
 raster[1,i+1] <- g_right[1,i]+raster[1,i]
}
for (i in 1:N)
{
  raster[i+1,1] <- g_down[i,1]+raster[i,1]
}

for (i in 2:(N+1)) #Ausfüllen der Matrix
{
  for (c in 2:(N+1))
  {
    raster[c,i] <- max(g_down[c-1,i]+raster[c-1,i],
                       g_right[c,i-1]+raster[c,i-1],
                       g_diag[c-1,i-1]+raster[c-1,i-1])
  }
}
raster
print(raster[N+1,N+1])
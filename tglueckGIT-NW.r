#!/usr/bin/Rscript
library(stringr)
library(optparse)

#Lesen der Eingabe
option_list <- list(make_option(c("-m", "--match"), type="numeric", default = 1, help = "score for a match"),
                    make_option(c("-n", "--mismatch"), type="numeric", default = -1, help = "score for a mismatch"),
                    make_option(c("-g", "--gap"), type="numeric", default = -2, help = "score for a gap"),
                    make_option(c("-i", "--input"), type="character", default = NULL, help = "path of the input file"))
opt_parser <- OptionParser(option_list = option_list)
args <- parse_args(opt_parser)
inhalt <- readLines(toString(args[4]))
limits <- vector()
gap <- as.numeric(args[3])  
mis <- as.numeric(args[2])
mat <- as.numeric(args[1])
similarity <- 0
#Aufbereiten der Eingabedatei
c<-0
for (line in inhalt)
{
  c = c+1
  if (identical(substring(line,1,1), ">")==TRUE)
  {
    limits <- c(limits, c)
  }
}

seq1 <- (inhalt[limits[1]+1])
seq2 <- (inhalt[limits[2]+1])

#Erstellen der Punktematrix
raster <- matrix(0L, ncol = nchar(seq1)+1, nrow = nchar(seq2)+1) #Leere Matrize für die Punktekarte

for (i in 1:nchar(seq1)+1) #Initialisierung der ersten Zeile und Spalte
{
  raster[1,i] <- raster[1,i-1] + gap
}
for (i in 1:nchar(seq2)+1)
{
  raster[i,1] <- raster[i-1,1] + gap
}
for (c in 1:nchar(seq1)+1)
{
  for (i in 1:nchar(seq2)+1)
  {
    if (identical(substr(seq1, i-1, i-1), substr(seq2, c-1, c-1))==TRUE)
    {
      diag<-raster[i-1,c-1] + mat
    }
    else 
    {
      diag<-raster[i-1,c-1] + mis
    }
    right <- raster[i-1,c] + gap
    down <- raster[i,c-1] + gap
    
  raster[i,c] <- max(diag, right, down)
  }
}

#Backtracking
i <- nchar(seq1)
c <- nchar(seq2)
line1 <- ""
line2 <- ""
line3 <- ""
s <- 0

while(c > 0 && i > 0)
{
  Scores <- c(raster[c, i], raster[c, i], raster[c+1,i], raster[c, i+1])
  Score <- raster[c+1,i+1]

  if (Scores[4] != Score - gap) Scores[4] <- -9999
  if (Scores[3] != Score - gap) Scores[3] <- -9999
  if (Scores[2] != Score - mis) Scores[2] <- -9999
  if (Scores[1] != Score - mat) Scores[1] <- -9999
  
  if (Scores[1] == max(Scores))
  {
    line1 <- paste(substr((seq1), i, i),line1, sep = "")
    line2 <- paste(substr((seq2), c, c),line2, sep = "")
    line3 <- paste("*",line3, sep = "")
    i <- i-1 ; c <- c-1
    similarity <- similarity + mat
  }
  else if (Scores[2] == max(Scores))
  {
    line1 <- paste(substr((seq1), i, i),line1, sep = "")
    line2 <- paste(substr((seq2), c, c),line2, sep = "")
    line3 <- paste(" ",line3, sep = "")
    i <- i-1 ; c <- c-1
    similarity <- similarity + mis
  }
  else if (Scores[3] == max(Scores))
  {
    line1 <- paste(substr((seq1), i, i),line1, sep = "")
    line2 <- paste("-",line2, sep = "")
    line3 <- paste(" ",line3, sep = "")
    i <- i-1
    similarity <- similarity + gap
  }
  else if (Scores[4] == max(Scores))
  {
    line1 <- paste("-",line1, sep = "")
    line2 <- paste(substr((seq2), c, c),line2, sep = "")
    line3 <- paste(" ",line3, sep = "")
    c <- c-1
    similarity <- similarity + gap
  }
}
while(c > 0)
{
  line1 <- paste("-",line1, sep = "")
  line2 <- paste(substr((seq2), c, c),line2, sep = "")
  line3 <- paste(" ",line3, sep = "")
  c <- c-1
}
while(i > 0)
{
  line1 <- paste(substr((seq1), i, i),line1, sep = "")
  line2 <- paste("-",line2, sep = "")
  line3 <- paste(" ",line3, sep = "")
  i <- i-1
}

#Ergebnis ausgeben
space1 <- regexpr(" ",inhalt[limits[1]])
name1 <- substr(inhalt[limits[1]],2,space1)
space2 <- regexpr(" ",inhalt[limits[2]])
name2 <- substr(inhalt[limits[2]],2,space2)
for (i in 1:(15-space1[1])) name1 <- paste(name1, " ")
for (i in 1:(15-space2[1])) name2 <- paste(name2, " ")

print("CLUSTAL")
print("")
for (n in seq(0, nchar(line1), by=60))
{
  print(paste(name1 ,substr(line1, n+1, n+60), sep = ""))
  print(paste(name2 ,substr(line2, n+1, n+60), sep = ""))
  print(paste("                ", substr(line3, n+1, n+60), sep = ""))
  print("")
}
print(similarity/(nchar(seq1)+nchar(seq2)/2))
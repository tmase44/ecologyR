install.packages("iNEXT")
install.packages("SoundShape")

library(pacman)
library(psych)
library(tidyverse)
library(iNEXT)
library(SoundShape)
# How to be a quantitative econologist; The 'A to R of Green Mathematics and Statistics
  # Jason Matthiopolous 

# Dummy data
a<-c(1:1000)
b<-c(1000:1)
df<-data.frame(a,b)
df$c<-(df$a+df$b)+df$a

# quick review
dim(df); class(df); ls(df); summary(df); describe(df)
unique(df$a) # do this only with strings not integers
colSums(is.na(df)) # na check

# Some basic syntax
df[2,2] # nth element 2nd row and 2nd col
df$b[2] # or like this by naming the 2nd column and just calling for 2nd row
df$b[-2] # all but nth element
df$b[1:10] # first 10 elements
df$b[-(1:10)] # all but first 10
df$c[df$c>1999]# elements above x value
df$c[df$c>1999&df$c<2001]# elements between x y values
df$c[df$c>=1999&df$c<=2001]# elements between and including
df$c[df$c==2000] # element is exactly x




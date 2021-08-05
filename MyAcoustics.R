# PACKAGES----
library(SoundShape)
library(tuneR)
library(seewave)
library(readr)
library(wrassp)
library(tidyverse)
# https://cran.r-project.org/web/packages/seewave/seewave.pdf

# WAV IMPORT----

# The function to import .wav files from the hard-disk is readWave:
  # > s6<-readWave("mysong.wav")

blackhb <- readWave("/Users/Tom_Macbook/ecologyR/Audio/BlackHornbill.wav")
orientalhb <- readWave("/Users/Tom_Macbook/ecologyR/Audio/OPHornbill.wav")

# EXAMINE----
  # structure
str(blackhb)
str(orientalhb)
  # frequency spectrum plot
acoustat(blackhb) 
acoustat(orientalhb)
  
# oscillogram----
par(mfrow=c(1,2), mar=c(4,4,2,1))
seewave::oscillo(blackhb,title = "Black Hornbill call")
seewave::oscillo(orientalhb,title = "Oriental Pied Hornbill call")

# TRIM----
cut.blackhb <- seewave::cutw(blackhb, f=44100, from=0.0, to=1.4, output = "Wave")
cut.ophb <- seewave::cutw(orientalhb, f=48000, from=0.6, to=1.7, output = "Wave")

  # check
par(mfrow=c(1,2), mar=c(4,4,2,1))
seewave::oscillo(cut.blackhb,title = "Black Hornbill call cut")
seewave::oscillo(cut.ophb,title = "Oriental-Pied Hornbill call cut")

# 3D spectrogram----
par(mfrow=c(1,2), mar=c(0,2,1,0)) # view side by side
threeDspectro(blackhb, flim=c(0, 0.5), 
              colkey=list(plot=FALSE), cex.axis=1, cex.lab=0.8, resfac=3)


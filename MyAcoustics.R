# PACKAGES----
library(SoundShape)
library(tuneR)
library(seewave)
library(readr)
library(wrassp)
library(tidyverse)
# https://cran.r-project.org/web/packages/seewave/seewave.pdf

# TEMP STORE RESULTS----
wav.at <- file.path(base::tempdir(), "original wave2")
if(!dir.exists(wav.at)) dir.create(wav.at)

store.at <- file.path(base::tempdir(), "output2")
if(!dir.exists(store.at)) dir.create(store.at)

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
par(mfrow=c(1,2), mar=c(4,4,2,1))
acoustat(blackhb) 
acoustat(orientalhb)
  
# oscillogram----
  # identify=TRUE helps me pick the times
par(mfrow=c(1,2), mar=c(4,4,2,1))
seewave::oscillo(blackhb,identify=TRUE,title = "Black Hornbill call")
seewave::oscillo(orientalhb,identify=TRUE,title = "Oriental Pied Hornbill call")

# TRIM----
2.8-1.72
3.64-2.67
cut.blackhb <- seewave::cutw(blackhb, f=44100, from=1.72, to=2.8, output = "Wave")
cut.ophb <- seewave::cutw(orientalhb, f=48000, from=2.67, to=3.64, output = "Wave")

# save cuts---- 
writeWave(cut.blackhb, filename = file.path(wav.at, "cut.blackhb.wav"), extensible = FALSE)
writeWave(cut.ophb, filename = file.path(wav.at, "cut.ophb.wav"), extensible = FALSE)
  
# check
par(mfrow=c(1,2), mar=c(4,4,2,1))
seewave::oscillo(cut.blackhb,title = "Black Hornbill call cut")
seewave::oscillo(cut.ophb,title = "Oriental-Pied Hornbill call cut")

# 3D spectrogram----
par(mfrow=c(1,2), mar=c(0,2,1,0)) # view side by side
threeDspectro(cut.blackhb, flim=c(0, 6), 
              colkey=list(plot=FALSE), cex.axis=1, cex.lab=0.8, resfac=3)
threeDspectro(cut.ophb, flim=c(0, 6), 
              colkey=list(plot=FALSE), cex.axis=1, cex.lab=0.8, resfac=3)

#2D spectogram----
par(mfrow=c(1,2), mar=c(4,4,2,1))
seewave::spectro(cut.blackhb, flim=c(0, 6), grid=FALSE, scale=FALSE, main="Black Hornbill call cut")
seewave::spectro(cut.ophb, flim=c(0, 6), grid=FALSE, scale=FALSE, main="Oriental-Pied Hornbill call cut")

#SEMILANDMARK----
# Semilandmarks from sampled surface
par(mfrow=c(1,2), mar=c(0,2,1,0))
threeDspectro(cut.blackhb, flim=c(0, 6), plot.type="points",
              samp.grid=TRUE, x.length=70, y.length=50, main="Semilandmarks 3D",
              colkey=list(plot=FALSE), cex.axis=0.4, cex.lab=0.8)
threeDspectro(cut.ophb, flim=c(0, 6), plot.type="points",
              samp.grid=TRUE, x.length=70, y.length=50, main="Semilandmarks 3D",
              colkey=list(plot=FALSE), cex.axis=0.4, cex.lab=0.8)

# split spectros
seewave::spectro(cut.blackhb, flim = c(0, 6), wl=512, f=44100, ovlp=70, grid=FALSE,main = "Black Hornbill Spectro")
graphics::abline(v=c(0.04, 0.3, 0.7, 1.0), lty=2)

seewave::spectro(cut.ophb, flim = c(0, 6), wl=512, f=44100, ovlp=70, grid=FALSE,main = "Oriental-Pied Hornbill Spectro")
graphics::abline(v=c(0.6, 0.75, 1.0), lty=2)

# standardized
par(mfrow=c(1,2), mar=c(4,4,2,2)) # parameters for aligning charts side by side
seewave::spectro(cut.blackhb, flim=c(0, 6), tlim=c(0, 1), main="data(Black hornbill)",
                 wl=512, f=44100, ovlp=70, grid=FALSE, scale=FALSE) # if scale and grid = TRUE they will be plotted separately
seewave::spectro(cut.ophb, flim=c(0, 6), tlim=c(0, 1), main="data(Oriental-Pied Hornbill)", 
                 wl=512, f=44100, ovlp=70, grid=FALSE, scale=FALSE)

# ALIGNMENT----
align.wave(wav.at=wav.at, wav.to="Aligned2", time.length = 1)

eigensound(analysis.type = "twoDshape", wav.at = file.path(wav.at, "Aligned2"),
           store.at=store.at, plot.exp=TRUE, flim=c(0, 6), tlim=c(0, 1))
store.at

par(mfrow=c(1,2), mar=c(4,4,1,1))
s.kro <- seewave::spectro(cut.blackhb, flim=c(0, 6), tlim = c(0, 1),  
                          grid=F, scale=F, f=44100, wl=512, ovlp=70, fastdisp=TRUE, cont=TRUE, 
                          contlevels = seq(-25, -25, 1), collevels = seq(-60, 0, 0.1))
#> This took quite a lot of time to display this graphic, you may set 'fastdisp=TRUE' for a faster, but less accurate, display



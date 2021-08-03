# PACKAGES----
library(SoundShape)
library(tuneR)
library(seewave)

# CRAN----
# https://cran.r-project.org/web/packages/SoundShape/vignettes/Getting-started.html

# SPECTOGRAM----
# Sample data from SoundShape
data(cuvieri)

# Select acoustic unit from sample
cuvieri.cut <- seewave::cutw(cuvieri, f=44100, from = 0.05, to=0.45, output="Wave")

# 3D spectrogram
par(mfrow=c(1,2), mar=c(0,2,1,0)) # view side by side
threeDspectro(cuvieri.cut, flim=c(0, 2.5), 
              colkey=list(plot=FALSE), cex.axis=0.4, cex.lab=0.8, resfac=3)

#SEMILANDMARK----
# Semilandmarks from sampled surface
threeDspectro(cuvieri.cut, flim=c(0, 2.5), plot.type="points",
              samp.grid=TRUE, x.length=70, y.length=50, main="Semilandmarks 3D",
              colkey=list(plot=FALSE), cex.axis=0.4, cex.lab=0.8)

#OSCILLOGRAM----
# Traditional oscillogram and spectrogram
par(mfrow=c(1,2), mar=c(4,4,2,1)) # view side by side
seewave::oscillo(cuvieri.cut, title="Oscillogram")
seewave::spectro(cuvieri.cut, flim=c(0, 2.5), grid=FALSE, scale=FALSE, main="Spectrogram")

# SAMPLES----
# Samples of data from SoundShape package
data(cuvieri)
data(centralis)
data(kroyeri)

# Plot spectro from sample and highlight acoustic units
dev.off() # if invalid external graphics error
# if the "figure margins too large" error, just drag the plot area larger

# centralis----
seewave::spectro(centralis, flim = c(0, 4), wl=512, f=44100, ovlp=70, grid=FALSE)
graphics::abline(v=c(0.1, 0.8, 1.08, 1.78, 2.1, 2.8), lty=2)


# cuvieri----
seewave::spectro(cuvieri, flim = c(0,4), wl=512, f=44100, ovlp=70, grid=FALSE)
graphics::abline(v=c(0.05, 0.45, 0.73, 1.13, 1.47, 1.87), lty=2)

# kroyeri----
seewave::spectro(kroyeri, flim = c(0, 4), wl=512, f=44100, ovlp=70, grid=FALSE)
graphics::abline(v=c(0.16, 0.96, 1.55, 2.35, 2.9, 3.8), lty=2)

# SAVE ACOUSTIC UNITS----
# Create temporary folder to store ".wav" files
wav.at <- file.path(base::tempdir(), "original wave")
if(!dir.exists(wav.at)) dir.create(wav.at)

# Create temporary folder to store results
store.at <- file.path(base::tempdir(), "output")
if(!dir.exists(store.at)) dir.create(store.at)

# STORE DEFINED ".wav" FILES----
# Select acoustic units
cut.centralis <- seewave::cutw(centralis, f=44100, from=0, to=0.9, output = "Wave")
cut.cuvieri <- seewave::cutw(cuvieri, f=44100, from=0, to=0.9, output = "Wave")
cut.kroyeri <- seewave::cutw(kroyeri, f=44100, from=0.2, to=1.1, output = "Wave")

# Export ".wav" files containing acoustic units and store on previosly created folder
writeWave(cut.cuvieri, filename = file.path(wav.at, "cut.cuvieri.wav"), extensible = FALSE)
writeWave(cut.centralis, filename = file.path(wav.at, "cut.centralis.wav"), extensible = FALSE)
writeWave(cut.kroyeri, filename = file.path(wav.at, "cut.kroyeri.wav"), extensible = FALSE)

# 3 STEPS TO AVOID ERRORS----
# 1. define sound window----

# this is the process of examining the whole clip: time (xaxis) and freq (yaxis)
  # the "eigensound" function defines these with 'tlim' and 'flim'
# it can be seen that kroyeri has the largest freq (about 3.5) & time (about 0.6) duration
  # so these dimensions should be applied to all for comparable charting

# Spectrogram plots using standardized sound window dimensions
par(mfrow=c(2,2), mar=c(4,4,2,2))
seewave::spectro(cut.centralis, flim=c(0, 4), tlim=c(0, 0.8), main="data(centralis)",
                 wl=512, f=44100, ovlp=70, grid=FALSE, scale=FALSE)
seewave::spectro(cut.cuvieri, flim=c(0, 4), tlim=c(0, 0.8), main="data(cuvieri)", 
                 wl=512, f=44100, ovlp=70, grid=FALSE, scale=FALSE)
seewave::spectro(cut.kroyeri, flim=c(0, 4), tlim=c(0, 0.8), main="data(kroyeri)", 
                 wl=512, f=44100, ovlp=70, grid=FALSE, scale=FALSE)

# 2. align units at the beginning of the sound window----
# The eigensound protocol also requires acoustic units to be placed at the 
  # beginning of a sound window before proceeding with the analysis.

# Place sounds at the beginning of a sound window
align.wave(wav.at=wav.at, wav.to="Aligned", time.length = 0.8)

# Verify alignment using analysis.type = "twoDshape"
eigensound(analysis.type = "twoDshape", wav.at = file.path(wav.at, "Aligned"),
           store.at=store.at, plot.exp=TRUE, flim=c(0, 4), tlim=c(0, 0.8))
store.at
# Go to folder specified by store.at and check jpeg files created

# 3. Set relative amplitude background----
#

# 2D spectrogram with curves of relative amplitude at -25 dB
par(mfrow=c(1,2), mar=c(4,4,1,1))
s.kro <- seewave::spectro(cut.kroyeri, flim=c(0, 4), tlim = c(0, 0.8),  
                          grid=F, scale=F, f=44100, wl=512, ovlp=70, cont=TRUE, 
                          contlevels = seq(-25, -25, 1), collevels = seq(-40, 0, 0.1))

# 3D spectrogram (with a lower dBlevel for illustrative purpuses)
threeDspectro(cut.kroyeri, dBlevel=40, flim=c(0, 4), tlim=c(0, 0.8), main="",
              colkey=list(plot=FALSE), cex.axis=0.4, cex.lab=0.8, resfac=2)

# Set background at -40 dB and remove -Inf values from spectrogram data 
for(i in 1:length(s.kro$amp)){if(s.kro$amp[i] == -Inf |s.kro$amp[i] <= -40)
{s.kro$amp[i] <- -40}}

# Add curve of relative amplitude
plot3D::contour3D(x=s.kro$time, y=s.kro$freq, colvar=t(s.kro$amp), z=-25,
                  plot=T, add=T, addbox=F, col="black", lwd=1.9, nlevels=2, dDepth=0.25)


# CITATION----
citation("SoundShape")
#> 
#> To cite package 'SoundShape' in publications use:
#> 
#>   Pedro Rocha (2021). SoundShape: Sound Waves Onto Morphometric Data. R
#>   package version 1.1.0. https://github.com/p-rocha/SoundShape
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {SoundShape: Sound Waves Onto Morphometric Data},
#>     author = {Pedro Rocha},
#>     year = {2021},
#>     note = {R package version 1.1.0},
#>     url = {https://github.com/p-rocha/SoundShape},
#>   }

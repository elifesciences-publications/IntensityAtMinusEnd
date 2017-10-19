# IntensityAtMinusEnd

punctaMeasure.m 
INPUT:
(1) a matrix representing an image/movie (i.e. pixel values in a grid, with a third time dimension)
(2) manual tracking data of an object within that image (x-coordinate, y-coordinate, time). In this case, the object is a GFP-labeled protein (i.e. 'punctum') that is recruited to an ablation-created k-fiber minus-end in a spindle.
OUTPUT:
(1) punctum intensity over time.

sigmFitNorm.m
INPUT:
(1) punctum intensity over time (output from punctaMeasure.m)
OUTPUT:
(1) fit of sigmoidal function to intensity over time of individual puncta
(2) timescale of recruitment (time to half-maximum intensity) of individual puncta

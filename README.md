# FlightMill



This repo contains information on how to operate the Harpur Lab's Arduino-based flight mill system. 


## About the software
in bin/ you will find an R script, soon to be a package, for taking in data from our Bauer mills. The script assumes you're in a directory that contains files ending in .TXT and also contains files called 'beeIDs' and 'length'. 

It assumes **one drone per file**. If you have more than one drone per file, each new drone will begin at '0' and you can't currently use the 'beeIDs' file. 


The code requires the following libraries

```
library(magrittr)
library(ggplot2)
library(readr)  
library(dplyr)  
library(tidyr)  
library(purrr)  
library(plyr)
```


The code will pull in all ARD.TXT files, map the drone ID using 'beeIDs', remove the first 5% of the run, remove points that are too fast to measure (i.e. noise), estimate speed, and estimate acceleration. It will produce mill summaries and bee summaries of all the data and plot speed and acceleration per drone. 


## File types

Each arduino-file looks (e.g. 'ARD1.TXT') like this:

```
0.001,0.001,1
0.672,0.672,1
1.342,0.670,1
2.025,0.683,1
2.708,0.683,1
3.396,0.688,1
4.096,0.700,1
```

Col1 is the time at which the magnet passed by the sensor. Col2 is the difference between sensor passes, col3 is the arduino ID. 



'beeIDs' looks like this:

```
ID,X3
Drone1,0
Drone2,1
```

'ID' is the ID of the drone tested and 'X3' is the arduino file 
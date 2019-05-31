# FlightMill



This repo contains information on how to operate the Harpur Lab's Arduino-based flight mill system. 


in bin/ you will find an R sscript, soon to be a package, for taking in data from our Bauer mills. The script assumes you're in a directory that contains files ending in .TXT and that the directoryu also contains files called 'beeIDs' and 'length'. It also assumes *one drone per file*. 


Each arduino-file looks like this:

```
{
0.001,0.001,1
0.672,0.672,1
1.342,0.670,1
2.025,0.683,1
2.708,0.683,1
3.396,0.688,1
4.096,0.700,1
}
```





'beeIDs' looks like this:

```
{
ID,X3
Drone1,0
Drone2,1
}
```

'ID' is the ID of the drone tested and 'X3' is the arduino file 
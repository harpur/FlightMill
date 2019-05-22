###
# Flight Mill Pipeline
###

#this is the rough script (to be split to a package) for flight mill analysis using the
#Bauer mills


#Variables we want to calculate for each run 
	#total time flying
	#Max velocity (note the max of the machine here too)
	# distance travelled 
	# average speed
	#acceleration?

#maybe? https://ademos.people.uic.edu/Chapter23.html

#Libraries --------------------------------------------------------------------
library(magrittr)
library(ggplot2)
library(readr)  
library(dplyr)  
library(tidyr)  
library(purrr)  
library(plyr)


#Functions --------------------------------------------------------------------

acceleration <- function(velocity = speed, time = X1){
	acc <- (diff(velocity)/diff(time))
	acc <- c(0,acc)
	return(acc)
	}



#Settings ---------------------------------------------------------------------
#this should be loaded into the functions later
mill.diameter <- 25.24125 #in cm
bees <- 'beeIDs' #this is a csv file of your design.
cut.perc <- 0.05 #the front % of data to cut out before analyses begin
max.speed.err <- 0.23 #this is the maximum diff our sensor can detect


#Load data --------------------------------------------------------------------
	#will need to pipeline this to load many different datasets
beeID <- read.table(bees,sep=',',header=T)
files <- dir(pattern='*.TXT')
files <- files[-c(1,2,3)]


df <- files %>% 
		map_dfr(read_csv,col_names=FALSE)
	#the header is: time at sensor pass, difference between times, mill no.
		#at each X1, the insect has made a rotation
		#each X2 indicates difference between the two

# Clean data ------------------------------------------------------------------
df <- merge(df, beeID, by = 'X3') #this'll need fixed, maybe. If an ID is missing or wrong it'll get dropped. 

#should probably eliminate the first few seconds as the bee aclimates and in case we hit the sensor
cuts <- round((nrow(df)/length(unique(df$ID))) * cut.perc,0)
df<- df %>% 
	group_by(ID) %>% 
	slice(cuts:n()) 


# Estimate variables data -----------------------------------------------------
#Eliminate stretches when bee sat on sensor 
df <- df[which(df$X2 > max.speed.err),]

#Estimate speed
circumf <- mill.diameter * pi
df$speed <- circumf/ df$X2

#calculate acceleration
df<-df %>%
  group_by(ID) %>%
  mutate(acc = acceleration(speed, X1))


#random filter
df <- df[which(df$X1<200),]



# Summarize for each individual bee -------------------------------------------
	#this'll be a dplyr summarise to get individual ID

mill.bee.summary <- ddply(df , c("ID"), summarize,
			mn.speed = mean(speed),
			max.speed = max(speed),
			distance = sum((X2) * (speed))

			)

mill.summary <- ddply(df , c("X3"), summarize,
			mn.speed = mean(speed),
			max.speed = max(speed),
			distance = sum((X2) * (speed))

			)


#Plotting Functions ---------------------------------------------------------

p2 <- ggplot(df, aes(x = X1, y = speed,  group = 1)) +  
		geom_line(size = 1.2) +
		geom_point(aes(colour=factor(ID), 
			fill = factor(ID)), shape=21, size = 2, colour = 'black') + 
		scale_fill_brewer(palette = 3) +
	#	scale_fill_manual(values=c("white", "black")) + #fix this for when there are 3+ drones
	#	scale_colour_manual(values=c("black", "black")) + #fix this for when there are 3+ drones
		facet_wrap(~ID, ncol=1, scales = 'free_y') +
		#scale_y_continuous(expand = c(0, 3)) +
		theme_bw() +
		 ylab("Speed (cm/s)")   +
		 xlab("Time (s)")   +
		theme(
			text=element_text(size=12,  family="Helvetica", colour = 'black'),
			strip.text.x = element_blank(),
			#axis.text.x = element_text(angle = 45, hjust = 1),
			#axis.title.x = element_blank(),
			axis.title.y = element_text(size = 12),
			axis.line.x = element_line(color="black", size = 0.5),
			axis.line.y = element_line(color="black", size = 0.5),
			#panel.grid.major = element_blank(),
			panel.grid.minor = element_blank(),
			panel.border = element_blank(),
			strip.background = element_blank(),
			panel.background = element_blank(),
			legend.title=element_blank()

	) 



p2


p.acc <- ggplot(df, aes(x = X1, y = acc,  group = 1)) +  
		geom_line(size = 1.2) +
		geom_point(aes(colour=factor(ID), 
			fill = factor(ID)), shape=21, size = 2, colour = 'black') + 
		scale_fill_brewer(palette = 3) +
	#	scale_fill_manual(values=c("white", "black")) + #fix this for when there are 3+ drones
	#	scale_colour_manual(values=c("black", "black")) + #fix this for when there are 3+ drones
		facet_wrap(~ID, ncol=1, scales = 'free_y') +
		#scale_y_continuous(expand = c(0, 3)) +
		theme_bw() +
		 ylab("Acceleration (cm/s/s)")   +
		 xlab("Time (s)")   +
		theme(
			text=element_text(size=12,  family="Helvetica", colour = 'black'),
			strip.text.x = element_blank(),
			#axis.text.x = element_text(angle = 45, hjust = 1),
			#axis.title.x = element_blank(),
			axis.title.y = element_text(size = 12),
			axis.line.x = element_line(color="black", size = 0.5),
			axis.line.y = element_line(color="black", size = 0.5),
			#panel.grid.major = element_blank(),
			panel.grid.minor = element_blank(),
			panel.border = element_blank(),
			strip.background = element_blank(),
			panel.background = element_blank(),
			legend.title=element_blank()

	) 



p.acc




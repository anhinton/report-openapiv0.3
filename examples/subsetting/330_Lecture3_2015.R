##############################
### STATS 330/762 - Lecture 3: Graphics
### 23/07/2015
### Dr. Steffen Klaere
### Supplementary Code
### NEEDS: hb1.csv and fever_data.csv
##############################

### Change working directory
# Adapt to your own needs
setwd("<Your Directory>")

### Packages
library(R330)

###################################
### First example, Exchange rates
###################################
exchange <- read.csv("hb1.csv")
exchange[,1] <- as.Date(sapply(exchange[,1],function(x){paste(1,x)}),format="%d %B %Y")
plot(USD~month,data=exchange,type="l",lwd=4,col="steelblue",xlab="Date",ylab="Exchange rate",main="Exchange rate between US$ and NZ$")

### Monthly rate of change
diff.in.logs <- sapply(2:nrow(exchange),function(i){log(exchange[i,2])-log(exchange[i-1,2])})
xvec <- seq(-0.2,0.1,length=100)

# Draw histogram
# density plots
pdf("data_dens.pdf",width=8,height=6)
hist(diff.in.logs,nclass=20,freq=F)
lines(density(diff.in.logs),col="blue",lwd=2)
dev.off()

# Add fitted normal density
pdf("normal_dens.pdf",width=8,height=6)
hist(diff.in.logs,nclass=20,freq=FALSE)
lines(density(diff.in.logs),col="blue",lwd=2)
lines(xvec,dnorm(xvec,mean=mean(diff.in.logs),sd=sd(diff.in.logs)),col="red",lwd=2)
dev.off()

#Drawing a qq plot
pdf("qqplot.pdf")
qqnorm(diff.in.logs)
qqline(diff.in.logs,lwd=3,col="red")
dev.off()

###################################
### Second example
###################################
data(rats.df)
rats.df$group <- factor(rats.df$group)
rats.df$rat <- factor(rats.df$rat)
rats.df$change <- factor(rats.df$change)

pdf("day_weight.pdf")
plot(rats.df$day,rats.df$growth,xlab="Time (days)",ylab="Weight (grams)")
dev.off()

group.cols <- c("violet","tomato","steelblue")
rat.col <- group.cols[rats.df$group[match(unique(rats.df$rat),rats.df$rat)]]
rat.legend <- list(text=list(lab=paste("Litter",1:3)),lines=list(col=group.cols,lwd=2),x=0.1,y=0.3,corner=c(0,0),columns=3)

pdf("rat_xyplot.pdf")
xyplot(growth~day,groups=rat,data=rats.df,type="l",lwd=3,col=rat.col,xlab="Time (days)",ylab="Weight (grams)",main="Growth rates for rats",cex.lab=2,key=rat.legend)
dev.off()

pdf("rat_trellis.pdf")
xyplot(growth~day | rat, data=rats.df,xlab="Time (days)",ylab="Weight (grams)")
dev.off()

within.group <- factor(unlist(sapply(1:3,function(i){as.integer(as.factor(as.character(rats.df$rat[rats.df$group==i])))})))


pdf("rat_double.pdf",width=10,height=6)
xyplot(growth~day | within.group+group, data=rats.df,xlab="Time (days)",ylab="Weight (grams)",type="l",lwd=4)
dev.off()

###################################
### Third example - Mouse data
###################################
mouse.df <- read.csv("fever_data.csv")
mouse1 <- mouse.df[mouse.df[,1]=="A03",-c(1,2,3,4,6)]
mouse1$date.time <- strptime(mouse1$date.time,format="%d/%m/%y %H:%M")
#mouse1$time <- strptime(mouse1$time,format="%H:%M")
mouse.temp <- mouse1$temp.med
mouse.ts <- ts(data=mouse.temp,frequency=96)
mouse.stl <- stl(mouse.ts,s.window=96)
mouse.season <- mouse.stl$time.series[64:159,1]+mean(mouse.stl$time.series[,2])

plot(mouse.stl)

pdf("mouse_temp.pdf",width=10,height=6)
boxplot(mouse1$temp.med~mouse1$time,outline=F,col=rgb(255,165,0,maxColorValue=255),xlab="day time",ylab="body temperature")
lines(mouse.season~as.factor(levels(mouse1$time)),lwd=4,col=rgb(0,0,255,maxColorValue=255))
text(55,38,"LOESS Smoothing",col="blue")
dev.off()

###################################
### Fourth example - 3D
###################################
data(cherry.df)
#pairs(cherry.df)
#plot3d(cherry.df,type="s",radius=1,col="blue")
#rgl.snapshot("cherry3d.png",fmt="png")

cylinder<-cherry.df$diameter^2*pi*cherry.df$height/4

pdf("cherry_pairs.pdf")
pairs(cherry.df)
dev.off()

pdf("cherry_diam_vol.pdf")
plot(cherry.df$diameter,cherry.df$volume,pch=21,bg="red",col="red",xlab="Diameter",ylab="Volume")
dev.off()

reg3d(cherry.df,wire=TRUE)
rgl.snapshot("cherry3reg.png")

movie3d(spin3d(axis=c(.5,1,.5),rpm=3),duration=20,convert=FALSE,clean=FALSE,dir="png")

###################################
### Fifth example - Coplots
###################################

pdf("cherry_coplot.pdf",width=10,height=8)
coplot(volume~height | diameter, data=cherry.df,pch=21,bg="red",col="red")
dev.off()

###################################
### Sixth example - Maungawhau (Mt. Eden)
###################################
data(volcano)
z <- 2 * volcano # Exaggerate the relief
x <- 10 * (1:nrow(z)) # 10 meter spacing (S to N)
y <- 10 * (1:ncol(z)) # 10 meter spacing (E to W)
zlim <- range(y)
zlen <- zlim[2] - zlim[1] + 1
colorlut <- terrain.colors(zlen,alpha=0) # height color lookup table
col <- colorlut[ z-zlim[1]+1 ] # assign colors to heights for each point
open3d()
rgl.surface(x, y, z, color=col, alpha=0.75, back="lines")

colorlut <- heat.colors(zlen,alpha=1) # use different colors for the contour map
col <- colorlut[ z-zlim[1]+1 ] 
rgl.surface(x, y, matrix(1, nrow(z), ncol(z)),color=col, back="fill")

movie3d(spin3d(axis=c(1,0,0),rpm=4),duration=30,convert=FALSE,clean=FALSE,dir="png")

#% ffmpeg command to create your own awesome movie :-)
#ffmpeg -r 10 -i movie%03d.png -s:v 1280x720 -c:v libx264 -profile:v high -crf 23 -pix_fmt yuv420p -r 30 out.mp4

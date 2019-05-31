power calculator





mn.mill<-mean((diff(mill.summary$mn.speed)))
sd.mill<-sd((diff(mill.summary$mn.speed)))


#2 sets of drones 

A<-rnorm(N,mean=120, sd = 6)
B<-rnorm(N,mean=110, sd = 6)



A.cor <- A + rnorm(N, mn.mill, sd.mill)
B.cor <- B + rnorm(N, mn.mill, sd.mill)

boxplot(A.cor, B.cor)






ps<-c()
N = 30
for(i in 1:1000){
	A<-rnorm(N,mean=120, sd = 6)
	B<-rnorm(N,mean=110, sd = 6)
	A.cor <- A + rnorm(N, mn.mill, sd.mill)
	B.cor <- B + rnorm(N, mn.mill, sd.mill)
	ps<-c(t.test(A.cor, B.cor)$p.value, ps)
}



#N = 20, 556/1000
#N = 10, 314/1000
#N = 200 1000/1000
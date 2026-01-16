#Raw data importation

d1 <- sasxport.get("data/DEMO_I.xpt")
d2 <- sasxport.get("data/BPX_I.xpt")
d3 <- sasxport.get("data/BMX_I.xpt")
d4 <- sasxport.get("data/GHB_I.xpt")
d5 <- sasxport.get("data/TCHOL_I.xpt")
d1.t <- subset(d1,select=c("seqn","riagendr","ridageyr"))
d2.t <- subset(d2,select=c("seqn","bpxsy1"))
d3.t <- subset(d3,select=c("seqn","bmxbmi"))
d4.t <- subset(d4,select=c("seqn","lbxgh"))
d5.t <- subset(d5,select=c("seqn","lbdtcsi"))
d <- merge(d1.t,d2.t)
d <- merge(d,d3.t)
d <- merge(d,d4.t)
d <- merge(d,d5.t)



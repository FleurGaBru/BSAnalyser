library(cowplot)
args = commandArgs(trailingOnly = TRUE)

snpData <-data.frame(read.table("/home/sebastiaan/Documents/PureBSAnalyser/output/snpfinalAVGS2.bnch",header=TRUE,sep="\t"),check.names = TRUE) #read.table(args[1],sep="\t",header=TRUE))

quicklyNow <- snpData

for(result in colnames(quicklyNow)[1:ncol(quicklyNow)]){
  plot <- ggplot(quicklyNow,aes(x=rownames(quicklyNow),y=quicklyNow[,result]))+geom_bar(fill = "#ed4591ff", stat = "identity")
  plot<- plot + xlab("Tool")
  plot<-plot + ylab(result)
  plot<-plot + labs(title = result)
  plot<-plot + theme(axis.text.x = element_text(angle = 90, hjust = 1))
  ggsave(paste(result,".jpg"), path = "~/Documents/PureBSAnalyser/output/reports/snp/")#args[2])
}

plot <- ggplot(quicklyNow,aes(x=rownames(quicklyNow),y=quicklyNow[,"common_SNPs_SNPChip"]/quicklyNow[,"totalSNPsCalled"]))+geom_bar(fill = "#ed4591ff", stat = "identity")
plot<- plot + xlab("")
plot<-plot + ylab("SNPs in common divided by total SNPs")
plot<-plot + labs(title = "SNPs in common divided by total SNPs")
plot<-plot + theme(axis.text.x = element_text(angle = 90, hjust = 1))
ggsave(paste(result,".jpg"), path = "~/Documents/PureBSAnalyser/output/reports/snp/")#args[2])
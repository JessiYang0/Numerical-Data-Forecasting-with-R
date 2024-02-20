#Read data
rm(list=ls())
setwd("C:/Users/User/Desktop/進階R/R final")
library(readr)
train_dataset <- read.csv("train_dataset.csv",na.strings = c("?","NA"),stringsAsFactors = TRUE)
train_ans <- read.csv("train_label.csv",na.strings = c("","NA"))
summary(train_ans$readmitted)
##merge data & ans
train_merge<-merge(train_dataset, train_ans, by="encounter_id")
rm(train_dataset,train_ans)


# fillin na
summary(train_merge$diag_1)
#train_merge$diag_1<-as.character(train_merge$diag_1)
#train_merge$diag_2<-as.character(train_merge$diag_2)
#train_merge$diag_3<-as.character(train_merge$diag_3)
#train_merge$diag_1<-as.numeric(train_merge$diag_1)
#train_merge$diag_2<-as.numeric(train_merge$diag_2)
#train_merge$diag_3<-as.numeric(train_merge$diag_3)

train_merge[(is.na(train_merge$diag_1)),"diag_1"]<-"428"
train_merge[(is.na(train_merge$diag_2)),"diag_2"]<-"276"
train_merge[(is.na(train_merge$diag_3)),"diag_3"]<-"250"



#ans convert to category
train_merge$ans<-0
train_merge[train_merge$readmitted=="<30","ans"]<-2
train_merge[train_merge$readmitted==">30","ans"]<-1
train_merge$ans<-as.factor(train_merge$ans)

#delet gender=?
train_merge<-train_merge[train_merge$gender!="Unknown/Invalid",]
train_merge$gender<-as.character(train_merge$gender)
train_merge[train_merge$gender=="Female","gender"]<-"1"
train_merge[train_merge$gender=="Male","gender"]<-"0"
train_merge$gender<-as.factor(train_merge$gender)

# convert change to category
summary(train_merge$change)
train_merge$change<-as.character(train_merge$change)
train_merge[train_merge$change=="Ch","change"]<-"1"
train_merge[train_merge$change=="No","change"]<-"0"
train_merge$change<-as.factor(train_merge$change)
# Categories with similar averages of readmitted, are grouped together into one category
train_merge$admission_source_id<-as.character(train_merge$admission_source_id)
train_merge[train_merge$admission_source_id==13,"admission_source_id"]<-"7"
train_merge[train_merge$admission_source_id==11,"admission_source_id"]<-"7"
train_merge[train_merge$admission_source_id==22,"admission_source_id"]<-"7"
train_merge[train_merge$admission_source_id==25,"admission_source_id"]<-"7"
train_merge[train_merge$admission_source_id==14,"admission_source_id"]<-"7"
train_merge[train_merge$admission_source_id==20,"admission_source_id"]<-"7"
train_merge$admission_source_id<-as.factor(train_merge$admission_source_id)

##### diagnosis
# Categories with similar averages of readmitted are grouped together into one category, so this category is a new feature
train_merge$diag1_m <- as.numeric(train_merge$diag1_m)
train_merge$dia_1_g[train_merge$diag1_m >= 1 & train_merge$diag1_m <= 139] <- 1
train_merge$dia_1_g[train_merge$diag1_m >= 140 & train_merge$diag1_m <= 239] <- 2
train_merge$dia_1_g[train_merge$diag1_m >= 240 & train_merge$diag1_m <= 279] <- 3
train_merge$dia_1_g[train_merge$diag1_m >= 280 & train_merge$diag1_m <= 289] <- 4
train_merge$dia_1_g[train_merge$diag1_m >= 290 & train_merge$diag1_m <= 319] <- 5
train_merge$dia_1_g[train_merge$diag1_m >= 320 & train_merge$diag1_m <= 359] <- 6
train_merge$dia_1_g[train_merge$diag1_m >= 360 & train_merge$diag1_m <= 389] <- 7
train_merge$dia_1_g[train_merge$diag1_m >= 390 & train_merge$diag1_m <= 459] <- 8
train_merge$dia_1_g[train_merge$diag1_m >= 460 & train_merge$diag1_m <= 519] <- 9
train_merge$dia_1_g[train_merge$diag1_m >= 520 & train_merge$diag1_m <= 579] <- 10
train_merge$dia_1_g[train_merge$diag1_m >= 580 & train_merge$diag1_m <= 629] <- 11
train_merge$dia_1_g[train_merge$diag1_m >= 630 & train_merge$diag1_m <= 679] <- 12
train_merge$dia_1_g[train_merge$diag1_m >= 680 & train_merge$diag1_m <= 709] <- 13
train_merge$dia_1_g[train_merge$diag1_m >= 710 & train_merge$diag1_m <= 739] <- 14
train_merge$dia_1_g[train_merge$diag1_m >= 740 & train_merge$diag1_m <= 759] <- 15
train_merge$dia_1_g[train_merge$diag1_m >= 760 & train_merge$diag1_m <= 779] <- 16
train_merge$dia_1_g[train_merge$diag1_m >= 780 & train_merge$diag1_m <= 799] <- 17
train_merge$dia_1_g[train_merge$diag1_m >= 800 & train_merge$diag1_m <= 999] <- 18
train_merge$dia_1_g[train_merge$diag1_m >= 1001 & train_merge$diag1_m <= 1799] <- 19
train_merge$dia_1_g[train_merge$diag1_m >= 1800 & train_merge$diag1_m <= 1999] <- 20

# convert diagnosis to category
train_merge$dia_1_g<-as.factor(train_merge$dia_1_g)
train_merge$dia_2_g<-as.factor(train_merge$dia_2_g)
train_merge$dia_3_g<-as.factor(train_merge$dia_3_g)


#The box plot reveals the relationship between each category of features and the target variable
ggplot(train_merge, aes(x =dia_1_g, y = ans)) +geom_boxplot()+stat_summary(fun=mean, geom="point",color="red", fill="red")
ggplot(train_merge, aes(x =diagnosis_group, y = ans)) +geom_boxplot()+stat_summary(fun=mean, geom="point",color="red", fill="red")
ggplot(train_merge, aes(x = diag1_m, y = ans)) +geom_boxplot()


# Create new feature from previous
list_1<-tapply(train_merge$ans,train_merge$diag1_m,mean)

namm<-name[[1]]
cc_1<-data.frame(cc=(1:683))
cc_1$cc<-namm
cc_1$mean<-ll
cc_1$diag1_level<-1
for(i in 1:683){
    if(cc_1[i,"mean"]==3){
        cc_1[i,"diag1_level"]<-6
        list_ma[i,"factor"]<-6
    }else if(cc_1[i,"mean"]>2){
        cc_1[i,"diag1_level"]<-5
        list_ma[i,"factor"]<-5
    }else if(cc_1[i,"mean"]==2){
        cc_1[i,"diag1_level"]<-4
        list_ma[i,"factor"]<-4
    }else if(cc_1[i,"mean"]>1.7){
        cc_1[i,"diag1_level"]<-3
        list_ma[i,"factor"]<-3
    }else if(cc_1[i,"mean"]>1.3){
        cc_1[i,"diag1_level"]<-2
        list_ma[i,"factor"]<-2
    }else if(cc_1[i,"mean"]>1){
        cc_1[i,"diag1_level"]<-1
        list_ma[i,"factor"]<-1
    }else if(cc_1[i,"mean"]==1){  
        cc_1[i,"diag1_level"]<-0
        list_ma[i,"factor"]<-0
    }   
}


##### medical_specialty
#Categories with similar averages of readmitted are grouped together into one category
table(train_merge$medical_specialty)

train_merge$medical_s2 <- 0
train_merge$medical_s2[train_merge$medical_specialty == "Surgery???Pediatric"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Surgery???Neuro"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Surgery???Maxillofacial"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Surgery???Colon&Rectal"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Surgeon"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "SportsMedicine"] <- 2
train_merge$medical_s2[train_merge$medical_specialty == "Speech"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Resident"] <- 3
train_merge$medical_s2[train_merge$medical_specialty == "Psychiatry???Child/Adolescent"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Psychiatry???Addictive"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Proctology"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Pediatrics???Pulmonology"] <- 2
train_merge$medical_s2[train_merge$medical_specialty == "Pediatrics???Neurology"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Pediatrics???Endocrinology"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Pediatrics???EmergencyMedicine"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Pediatrics???AllergyandImmunology"] <- 2
train_merge$medical_s2[train_merge$medical_specialty == "Otolaryngology"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "ObstetricsandGynecology"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Obstetrics"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Neurophysiology"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Hematology"] <- 2
train_merge$medical_s2[train_merge$medical_specialty == "Gynecology"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Endocrinology???Metabolism"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Dermatology"] <- 2
train_merge$medical_s2[train_merge$medical_specialty == "Dentistry"] <- 2
train_merge$medical_s2[train_merge$medical_specialty == "DCPTEAM"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "Cardiology???Pediatric"] <- 2
train_merge$medical_s2[train_merge$medical_specialty == "Anesthesiology"] <- 1
train_merge$medical_s2[train_merge$medical_specialty == "AllergyandImmunology"] <- 3

table(train_merge$medical_s2)



##XGBoost
#先dummy再切
library(dummies)
dummy_all<-dummy.data.frame(train_merge3[,2:49])
##

dummy_all$ans<-train_merge$ans
dummy_final<-cbind(train_merge$encounter_id,dummy_all)
colnames(dummy_final)[1]<-"encounter_id"
#
# split train & test
set.seed(123)
n<-nrow(dummy_final)
nn<-sample(n)
shuffled_train <- dummy_final[nn, ]
trainn<-shuffled_train[1:round(0.75 * n),]
testnn<-shuffled_train[(round(0.75 * n) + 1):n,]
rm(dummy_all,n,nn,shuffled_train)



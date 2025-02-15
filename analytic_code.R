

##########################################################


# Title:  Cost of Diagnostic Delays in Fungal Pathogens
# Editor: Jason Massey
# Date:   11/20/2024


##########################################################


#NOTES:

#TO DO: create finalized figures (add in all_pathogens group) into large forest plots

# (1) how to present results?
# (2) should we consider cost for implementing testing?  --> next analysis? 
# (3) should we consider how in ways events over time affect the outcome? for example
#      how many times is someone visiting a doctor ordering antibiotics etc. before
#      getting diagnosed? That would affect cost by extending the delay per person  



#####################

# Libraries

#####################
library(mgcv)
library(tidyr)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(magrittr)
library(MASS)
library(PSweight)
library(broom)
library(ggeffects)
library(mlogit)
library(nnet)
library(lsr)
library(data.table)

#####################

# Reading in Data 

#####################

# Read in Survival Data
delay <- read.csv("XXXX")
blasto <- read.csv("XXXX")
cocci <- read.csv("XXXX")
histo <- read.csv("XXXX")
combined <- read.csv("XXXX")


#stating the variables I want to be a factor
cols = c("SEX", "AGE_GROUP", "RURAL_STATUS", "REGION", "STATE", "INSURANCE", 
         "ANTIBIOTICS", "ANTIFUNGALS", "COND_IMMUNOSUPPRESSED")

#changing the variables into factors
delay %<>% mutate_at(cols, factor)
blasto %<>% mutate_at(cols, factor)
cocci %<>% mutate_at(cols, factor)
histo %<>% mutate_at(cols, factor)
combined %<>% mutate_at(cols, factor)


################################################

# Propensity Scores and Inverse Probability Weights 

################################################


################################
# Method 1: Quantile Binning
# (assumption is full outcome model is not categorical)
################################

# STEP 1: Create N=3,4,5,10,15,20 Categories 

#making factor 
cols2 = c("delay_q5")
delay %<>% mutate_at(cols2, factor)
blasto %<>% mutate_at(cols2, factor)
cocci %<>% mutate_at(cols2, factor)
histo %<>% mutate_at(cols2, factor)
combined %<>% mutate_at(cols2, factor)

# STEP 2: Propensity Scores Multinomial (PS) polr for ordinal
delay.5 = multinom(formula = delay_q5 ~ SEX + AGE_GROUP + RURAL_STATUS +
                      REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                      COND_IMMUNOSUPPRESSED, data = delay)

blasto.5 = multinom(formula = delay_q5 ~ SEX + AGE_GROUP + RURAL_STATUS +
                  REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                  COND_IMMUNOSUPPRESSED, data = blasto)

cocci.5 = multinom(formula = delay_q5 ~ SEX + AGE_GROUP + RURAL_STATUS +
                     REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                     COND_IMMUNOSUPPRESSED, data = cocci)

histo.5 = multinom(formula = delay_q5 ~ SEX + AGE_GROUP + RURAL_STATUS +
                     REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                     COND_IMMUNOSUPPRESSED, data = histo)

combined.5 = multinom(formula = delay_q5 ~ SEX + AGE_GROUP + RURAL_STATUS +
                     REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                     COND_IMMUNOSUPPRESSED, data = combined)

# Here need to say if delay_q5 = 0,1,2,3,4,5 bin, then fitted = 0,1,2,3,4,5 probability 
delay$prob.5 <- predict(delay.5, type = 'probs')
head(delay$prob.5)

blasto$prob.5 <- predict(blasto.5, type = 'probs')
head(blasto$prob.5)

cocci$prob.5 <- predict(cocci.5, type = 'probs')
head(cocci$prob.5)

histo$prob.5 <- predict(histo.5, type = 'probs')
head(histo$prob.5)

combined$prob.5 <- predict(combined.5, type = 'probs')
head(combined$prob.5)

# Create 0 Vector
delay$w <- rep(0, nrow(delay))
blasto$w <- rep(0, nrow(blasto))
cocci$w <- rep(0, nrow(cocci))
histo$w <- rep(0, nrow(histo))
combined$w <- rep(0, nrow(combined))

# Assign each correct probability to each observation 
delay$w <- ifelse(delay$delay_q5==0,delay$prob.5[,"0"],delay$w)
delay$w <- ifelse(delay$delay_q5==1,delay$prob.5[,"1"],delay$w)
delay$w <- ifelse(delay$delay_q5==2,delay$prob.5[,"2"],delay$w)
delay$w <- ifelse(delay$delay_q5==3,delay$prob.5[,"3"],delay$w)
delay$w <- ifelse(delay$delay_q5==4,delay$prob.5[,"4"],delay$w)
delay$w <- ifelse(delay$delay_q5==5,delay$prob.5[,"5"],delay$w)

blasto$w <- ifelse(blasto$delay_q5==0,blasto$prob.5[,"0"],blasto$w)
blasto$w <- ifelse(blasto$delay_q5==1,blasto$prob.5[,"1"],blasto$w)
blasto$w <- ifelse(blasto$delay_q5==2,blasto$prob.5[,"2"],blasto$w)
blasto$w <- ifelse(blasto$delay_q5==3,blasto$prob.5[,"3"],blasto$w)
blasto$w <- ifelse(blasto$delay_q5==4,blasto$prob.5[,"4"],blasto$w)
blasto$w <- ifelse(blasto$delay_q5==5,blasto$prob.5[,"5"],blasto$w)

cocci$w <- ifelse(cocci$delay_q5==0,cocci$prob.5[,"0"],cocci$w)
cocci$w <- ifelse(cocci$delay_q5==1,cocci$prob.5[,"1"],cocci$w)
cocci$w <- ifelse(cocci$delay_q5==2,cocci$prob.5[,"2"],cocci$w)
cocci$w <- ifelse(cocci$delay_q5==3,cocci$prob.5[,"3"],cocci$w)
cocci$w <- ifelse(cocci$delay_q5==4,cocci$prob.5[,"4"],cocci$w)
cocci$w <- ifelse(cocci$delay_q5==5,cocci$prob.5[,"5"],cocci$w)

histo$w <- ifelse(histo$delay_q5==0,histo$prob.5[,"0"],histo$w)
histo$w <- ifelse(histo$delay_q5==1,histo$prob.5[,"1"],histo$w)
histo$w <- ifelse(histo$delay_q5==2,histo$prob.5[,"2"],histo$w)
histo$w <- ifelse(histo$delay_q5==3,histo$prob.5[,"3"],histo$w)
histo$w <- ifelse(histo$delay_q5==4,histo$prob.5[,"4"],histo$w)
histo$w <- ifelse(histo$delay_q5==5,histo$prob.5[,"5"],histo$w)

combined$w <- ifelse(combined$delay_q5==0,combined$prob.5[,"0"],combined$w)
combined$w <- ifelse(combined$delay_q5==1,combined$prob.5[,"1"],combined$w)
combined$w <- ifelse(combined$delay_q5==2,combined$prob.5[,"2"],combined$w)
combined$w <- ifelse(combined$delay_q5==3,combined$prob.5[,"3"],combined$w)
combined$w <- ifelse(combined$delay_q5==4,combined$prob.5[,"4"],combined$w)
combined$w <- ifelse(combined$delay_q5==5,combined$prob.5[,"5"],combined$w)


# STEP 3: Create Weights  

delay <-delay %>%
  mutate(uw=(1/w)) %>%
  mutate(ow= ( 1 /(1/(prob.5[,"0"]) + 1/(prob.5[,"1"]) + 1/(prob.5[,"2"]) +
                     1/(prob.5[,"3"])+ 1/(prob.5[,"4"]) + 
                     1/(prob.5[,"5"])) ) / w  )

blasto <-blasto %>%
  mutate(uw=(1/w)) %>%
  mutate(ow= ( 1 /(1/(prob.5[,"0"]) + 1/(prob.5[,"1"]) + 1/(prob.5[,"2"]) +
                     1/(prob.5[,"3"])+ 1/(prob.5[,"4"]) + 
                     1/(prob.5[,"5"])) ) / w  )

cocci <-cocci %>%
  mutate(uw=(1/w)) %>%
  mutate(ow= ( 1 / ( 1/(prob.5[,"0"]) + 1/(prob.5[,"1"]) + 1/(prob.5[,"2"]) +
                      1/(prob.5[,"3"]) + 1/(prob.5[,"4"]) + 
                      1/(prob.5[,"5"]) ) ) / w  )

histo <-histo %>%
  mutate(uw=(1/w)) %>%
  mutate(ow= ( 1 /( 1/(prob.5[,"0"]) + 1/(prob.5[,"1"]) + 1/(prob.5[,"2"]) +
                      1/(prob.5[,"3"]) + 1/(prob.5[,"4"]) + 
                      1/(prob.5[,"5"]) ) ) / w  )

combined <-combined %>%
  mutate(uw=(1/w)) %>%
  mutate(ow= ( 1 /( 1/(prob.5[,"0"]) + 1/(prob.5[,"1"]) + 1/(prob.5[,"2"]) +
                      1/(prob.5[,"3"]) + 1/(prob.5[,"4"]) + 
                      1/(prob.5[,"5"]) ) ) / w  )

# STEP 4: Check Balance 

# Model Formula
ps.mult <- delay_q5 ~ SEX + AGE_GROUP + RURAL_STATUS +
  REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
  COND_IMMUNOSUPPRESSED

# IPW
bal.ipw.delay <- SumStat(ps.formula = ps.mult,
                          weight = c("IPW"), data = delay)
bal.ipw.blasto <- SumStat(ps.formula = ps.mult,
                   weight = c("IPW"), data = blasto)
bal.ipw.cocci <- SumStat(ps.formula = ps.mult,
                   weight = c("IPW"), data = cocci)
bal.ipw.histo <- SumStat(ps.formula = ps.mult,
                         weight = c("IPW"), data = histo)
bal.ipw.combined <- SumStat(ps.formula = ps.mult,
                         weight = c("IPW"), data = combined)

# Overlap
bal.ow.delay <- SumStat(ps.formula = ps.mult,
                         weight = c("overlap"), data = delay)
bal.ow.blasto <- SumStat(ps.formula = ps.mult,
                  weight = c("overlap"), data = blasto)
bal.ow.cocci <- SumStat(ps.formula = ps.mult,
                        weight = c("overlap"), data = cocci)
bal.ow.histo <- SumStat(ps.formula = ps.mult,
                  weight = c("overlap"), data = histo)
bal.ow.combined <- SumStat(ps.formula = ps.mult,
                        weight = c("overlap"), data = combined)

# SMD Plots
plot(bal.ipw.delay, metric = "ASD")
plot(bal.ipw.blasto, metric = "ASD")
plot(bal.ipw.cocci, metric = "ASD")
plot(bal.ipw.histo, metric = "ASD")
plot(bal.ipw.combined, metric = "ASD")

plot(bal.ow.delay, metric = "ASD")
plot(bal.ow.blasto, metric = "ASD")
plot(bal.ow.cocci, metric = "ASD")
plot(bal.ow.histo, metric = "ASD")
plot(bal.ow.combined, metric = "ASD")


############# Plot Distributions ##############

delay$new_time <- delay$delay_time*delay$ow
cocci$new_time <- cocci$delay_time*cocci$ow
combined$new_time <- combined$delay_time*combined$ow

hist(delay$new_time)
hist(cocci$new_time)
hist(combined$new_time)






# STEP 5: Run Weights in Models 

########## GAM ###########

# GAM Including No Delays K = 3,...10 and SP = 0.01 

m_delay_gam <- gam(total_cost ~ s(delay_time, k=6),
                   data = delay,
                   weight = ow,
                   sp = 0.01)

m_cocci_gam <- gam(total_cost ~ s(delay_time, k=6),
              data = cocci,
              weight = ow,
              sp = 0.01)

m_combined_gam <- gam(total_cost ~ s(delay_time, k=6),
                   data = combined,
                   weight = ow,
                   sp = 0.01)


# GAM Excluding No Delays K = 3,..10 and SP = 0.01 
m_cocci_gam2 <- gam(total_cost ~ s(delay_trunc, k=10),
              data = cocci,
              weight = ow,
              sp = 0.01)

m_delay_gam2 <- gam(total_cost ~ s(delay_trunc, k=10),
                    data = delay,
                    weight = ow,
                    sp = 0.01)

m_combined_gam2 <- gam(total_cost ~ s(delay_trunc, k=10),
                    data = combined,
                    weight = ow,
                    sp = 0.01)

# Coefficients
coefficients(m_cocci_gam)
coefficients(m_cocci_gam2)

# Summary
summary(m_cocci_gam)
summary(m_cocci_gam2)

# Plot
plot(m_delay_gam, shade=TRUE)
plot(m_combined_gam, shade=TRUE)
plot(m_cocci_gam, shade=TRUE)

plot(m_delay_gam2, shade=TRUE)
plot(m_combined_gam2, shade=TRUE)
plot(m_cocci_gam2, shade=TRUE)



# Model Fit
gam.check(m_cocci_gam)
gam.check(m_cocci_gam2)

# Concurvity
concurvity(m_cocci_gam, full = TRUE)
concurvity(m_cocci_gam2, full = TRUE)



###### Truncated Linear Model ####### 

m_delay_linear <- lm(total_cost ~ delay_time ,
                      weights = ow,
                      data = delay)

m_blasto_linear <- lm(total_cost ~ delay_trunc ,
                                        weights = ow,
                                       data = blasto)

m_cocci_linear <- lm(total_cost ~ delay_trunc ,
             weights = ow,
             data = cocci)

m_histo_linear <- lm(total_cost ~ delay_trunc,
                     weights = ow,
                     data = histo)

m_combined_linear <- lm(total_cost ~ delay_trunc,
                     weights = ow,
                     data = combined)

summary(m_delay_linear) 
confint(m_delay_linear)
summary(m_blasto_linear) 
summary(m_cocci_linear) 
confint(m_cocci_linear)
summary(m_histo_linear) 
confint(m_histo_linear)
summary(m_combined_linear) 

######### TRUNCATED LINEAR RESULTS###########

# Average increase of $131.00 per day of delay of all (p < 0.001) 
# Average increase of $180.72 per day of delay of cocci (p < 0.001)  
# Average increase of $38.00 per day of delay of histo (p = 0.401) 

# Blasto and Histo have a bump at no delay -> delay 
# Cocci has a bump in the 3rd month of delay 

table(histo$delay_tert)

########## Binary Model ###########

delay$delay<-ifelse(delay$delay_time==0,0, 1)
delay$delay <- as.factor(delay$delay)
blasto$delay<-ifelse(blasto$delay_time==0,0, 1)
blasto$delay <- as.factor(blasto$delay)
cocci$delay<-ifelse(cocci$delay_time==0,0, 1)
cocci$delay <- as.factor(cocci$delay)
histo$delay<-ifelse(histo$delay_time==0,0, 1)
histo$delay <- as.factor(histo$delay)
combined$delay<-ifelse(combined$delay_time==0,0, 1)
combined$delay <- as.factor(combined$delay)


m_delay_binary <- lm(total_cost ~ delay,
                      weights = ow,
                      data = delay)

m_blasto_binary <- lm(total_cost ~ delay,
                      weights = ow,
                     data = blasto)

m_cocci_binary <- lm(total_cost ~ delay,
             weights = ow,
             data = cocci)

m_histo_binary <- lm(total_cost ~ delay,
                     weights = ow,
                     data = histo)

m_combined_binary <- lm(total_cost ~ delay,
                     weights = ow,
                     data = combined)


summary(m_delay_binary)
summary(m_blasto_binary) # Not stat-sig
summary(m_cocci_binary) 
summary(m_histo_binary)
summary(m_combined_binary)


########### BINARY RESULTS #############

# Those with a delay in any fungal diagnosis pay on avg $13,310
# more than those with no delay (p < 0.0001)

# Those with a delay in blasto diagnosis pay on avg $28,878.60
# more than those with no delay (p = 0.074)

# Those with a delay in cocci diagnosis pay on avg $9,243 
# more than those with no delay (p = 0.031)

# Those with a delay in histo diagnosis pay on avg $22,024 
# more than those with no delay (p < 0.0001)

# Those with a delay in blasto or histo diagnosis pay on avg $16,719 
# more than those with no delay (p < 0.0001)

# Check other models like quartiles, etc. 

# Combine all datasets 




############ Tertiles ############


#creating a new delay variable split into 3 30 day groups (not tertiles - but 30,60,90 days)

delay$delay_tert<-ifelse(delay$delay_time==0, 0,
                          ifelse(delay$delay_time>0 & delay$delay_time<=30,1,
                                 ifelse(delay$delay_time>30 & delay$delay_time<=60,2,
                                        ifelse(delay$delay_time>60 & delay$delay_time<=90,3,NA))))


blasto$delay_tert<-ifelse(blasto$delay_time==0, 0,
                         ifelse(blasto$delay_time>0 & blasto$delay_time<=30,1,
                                ifelse(blasto$delay_time>30 & blasto$delay_time<=60,2,
                                       ifelse(blasto$delay_time>60 & blasto$delay_time<=90,3,NA))))

cocci$delay_tert<-ifelse(cocci$delay_time==0, 0,
                         ifelse(cocci$delay_time>0 & cocci$delay_time<=30,1,
                                ifelse(cocci$delay_time>30 & cocci$delay_time<=60,2,
                                       ifelse(cocci$delay_time>60 & cocci$delay_time<=90,3,NA))))

histo$delay_tert<-ifelse(histo$delay_time==0, 0,
                         ifelse(histo$delay_time>0 & histo$delay_time<=30,1,
                                ifelse(histo$delay_time>30 & histo$delay_time<=60,2,
                                       ifelse(histo$delay_time>60 & histo$delay_time<=90,3,NA))))

combined$delay_tert<-ifelse(combined$delay_time==0, 0,
                         ifelse(combined$delay_time>0 & combined$delay_time<=30,1,
                                ifelse(combined$delay_time>30 & combined$delay_time<=60,2,
                                       ifelse(combined$delay_time>60 & combined$delay_time<=90,3,NA))))


#turning all split delay variables into a factor
delay$delay_tert<-as.factor(delay$delay_tert)
blasto$delay_tert<-as.factor(blasto$delay_tert)
cocci$delay_tert<-as.factor(cocci$delay_tert)
histo$delay_tert<-as.factor(histo$delay_tert)
combined$delay_tert<-as.factor(combined$delay_tert)


# regression

m_delay_tert <- lm(total_cost ~ delay_tert + SEX + AGE_GROUP + RURAL_STATUS +
                      REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                      COND_IMMUNOSUPPRESSED,
                    weights = ow,
                    data = delay)

m_blasto_tert <- lm(total_cost ~ delay_tert + SEX + AGE_GROUP + RURAL_STATUS +
                       REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                       COND_IMMUNOSUPPRESSED,
                    weights = ow,
                     data = blasto)

m_cocci_tert <- lm(total_cost ~ delay_tert + SEX + AGE_GROUP + RURAL_STATUS +
                      REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                      COND_IMMUNOSUPPRESSED,
                   weights = ow,
                    data = cocci)

m_histo_tert <- lm(total_cost ~ delay_tert + SEX + AGE_GROUP + RURAL_STATUS +
                      REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                      COND_IMMUNOSUPPRESSED,
                   weights = ow,
                    data = histo)

m_combined_tert <- lm(total_cost ~ delay_tert + SEX + AGE_GROUP + RURAL_STATUS +
                         REGION + INSURANCE + ANTIBIOTICS + ANTIFUNGALS +
                         COND_IMMUNOSUPPRESSED,
                      weights = ow,
                       data = combined)


#checking summary of results
summary(m_delay_tert)
summary(m_blasto_tert)
summary(m_cocci_tert)
summary(m_histo_tert)
summary(m_combined_tert)


# Create Data Frames from estimates 
delay_est <- data.table(coef(summary(m_delay_tert)))
setDF(delay_est)

blasto_est <- data.table(coef(summary(m_blasto_tert)))
setDF(blasto_est)

cocci_est <- data.table(coef(summary(m_cocci_tert)))
setDF(cocci_est)

histo_est <- data.table(coef(summary(m_histo_tert)))
setDF(histo_est)

# CI Vectors 
confint(m_delay_tert)
confint(m_blasto_tert)
confint(m_cocci_tert)
confint(m_histo_tert)

# Get Counts of pathogens by month
table(delay$delay_tert)
table(combined$delay_tert)
table(cocci$delay_tert)




#Distribution plot
library(ggplot2)
# Basic scatter plot
ggplot(delay, aes(x=delay_time, y=log(total_cost))) + geom_point()

ggplot(delay, aes(x=delay_trunc, y=log(total_cost))) + geom_point()



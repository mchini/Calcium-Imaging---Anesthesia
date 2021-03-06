
rm(list  =  ls())

library('lme4')
library('lmerTest')
library('emmeans')
library('openxlsx')

# dataset is too large to compute the degrees of freedom with standard lme method 
# you can however ignore the warning about lack of calculations for degrees of freedom, the pvalue is still accurate

##################### LOAD DATA FOR HIGH THR DATASET #####################

data <- read.xlsx("transients/transients high thr in this repo")
factor(data$condition) -> condition
factor(data$mouse) -> mouse
factor(data$recording) -> recording
data$n_peaks -> n_peaks
data$height -> height
data$decay_isol_10 -> decay
excel_file <- "where you want to save your results"
wb <- createWorkbook()

# in this case the grouping variable is not only mouse but also recording
# before this was not the case because we only had one parameter value per recording, 
# now we have one per neuron

##################### NUMBER OF PEAKS #####################

model <- lmer(n_peaks ~ condition + (1 | mouse) + (1 | recording)) # fit the model
anova(model) # test it using lmerTest way (ANOVA with Satterthwaite's method)
addWorksheet(wb, "model number of peaks")
writeData(wb, sheet = "model number of peaks", anova(model))

posthoc <- emmeans(model, pairwise ~ condition) # post-hoc comparison (might take a long time)
summary(posthoc) # print the post-hoc results
addWorksheet(wb, "number of peaks means")
writeData(wb, sheet = "number of peaks means", posthoc$emmeans)
addWorksheet(wb, "number of peaks contrasts")
writeData(wb, sheet = "number of peaks contrasts", posthoc$contrasts)

##################### HEIGHT OF TRANSIENTS #####################

model <- lmer(height ~ condition + (1 | mouse) + (1 | recording)) # fit the model
anova(model) # test it using lmerTest way (ANOVA with Satterthwaite's method)
addWorksheet(wb, "model amplitude")
writeData(wb, sheet = "model amplitude", anova(model))

posthoc <- emmeans(model, pairwise ~ condition) # post-hoc comparison 
summary(posthoc) # print the post-hoc results
addWorksheet(wb, "amplitude means")
writeData(wb, sheet = "amplitude means", posthoc$emmeans)
addWorksheet(wb, "amplitude contrasts")
writeData(wb, sheet = "amplitude contrasts", posthoc$contrasts)
remove('posthoc')


##################### DECAY OF TRANSIENTS #####################

model <- lmer(decay ~ condition + (1 | mouse) + (1 | recording)) # fit the model
anova(model) # test it using lmerTest way (ANOVA with Satterthwaite's method)
addWorksheet(wb, "model transient decay")
writeData(wb, sheet = "model transient decay", anova(model))

posthoc <- emmeans(model, pairwise ~ condition) # post-hoc comparison
summary(posthoc) # print the post-hoc results
addWorksheet(wb, "transient decay means")
writeData(wb, sheet = "transient decay means", posthoc$emmeans)
addWorksheet(wb, "transient decay contrasts")
writeData(wb, sheet = "transient decay contrasts", posthoc$contrasts)
remove('posthoc') 


##################### SAVE EVERYTHING TO EXCEL #####################

saveWorkbook(wb = wb, excel_file)

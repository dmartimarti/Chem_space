
## script to prepare data for chemprop D-MPNN

# libraries

library(tidyverse) # master library to deal with data frames
library(readxl) # read xlsx or xls files
library(ggrepel) # ggplot add-on, to plot names that don't collapse in same position
library(here) # usefull to save plots in folders given a root
library(viridis) # color palette package
# library(ComplexHeatmap) # yeah, complex heatmaps
library(plotly)
library(ggridges)

theme_set(theme_light())

# prepare data ------------------------------------------------------------


# prepare data for chemprop

biolog_metabolites_PubChem 



bliss = read_csv('D:/MRC_Postdoc/Pangenomic/biolog/drug_drug_screen/summary/Bliss_scores_corrected.csv')

bliss = bliss %>% separate(Drug.combination, c('Drug', 'Plate'), sep = '_')


chemprop = bliss %>% left_join(biolog_metabolites_PubChem %>% select(Drug = GENERIC_NAME, SMILES))

chemprop %>% 
  mutate(class = case_when(Synergy.score < -4 ~ 1, # antagonistic
                           Synergy.score >= -4 & Synergy.score <= 4 ~ 0, # neutral
                           Synergy.score > 4 ~ 2)) %>% # synergy
  select(smiles = SMILES, synergy = Synergy.score) %>% 
  drop_na(smiles) %>% 
  write_csv(here('chemprop',file = 'chemprop.csv'))

  
  
chemprop %>% 
  mutate(class = case_when(Synergy.score < -4 ~ 1, # antagonistic
                           Synergy.score >= -4 & Synergy.score <= 4 ~ 0, # neutral
                           Synergy.score > 4 ~ 2)) %>% # synergy
  select(smiles = SMILES, class) %>% 
    drop_na(smiles) %>% 
    write_csv(here('chemprop',file = 'chemprop_class.csv'))
  

drugbank %>% 
  select(smiles = SMILES) %>% 
  drop_na(smiles) %>% 
  write_csv(here('chemprop', file = 'predict.csv'))





# read results ------------------------------------------------------------

### read results

# read regression results
pred_reg = read_csv("chemprop/regression/predictions_test.csv")


# drugbank.2 = drugbank %>%
#   select(smiles = SMILES, everything())
# # 
# length(unique(drugbank.2$smiles))
# 
# setdiff(drugbank.2$smiles, pred_reg$smiles)
# intersect(drugbank.2$smiles, pred_reg$smiles)

pred_reg = pred_reg %>% 
  left_join(drugbank %>% select(GENERIC_NAME, smiles = SMILES)) 

pred_reg %>% 
  ggplot(aes(x = synergy)) +
  geom_histogram(stat = 'bin')


chemprop %>% 
  ggplot(aes(x = Synergy.score)) + 
  geom_histogram(stat = 'bin')



# read multi-class results

pred_mc = read_csv("chemprop/multiclass_thr.4/predictions_multiclass.csv") %>% 
  drop_na(smiles) %>% 
  select(-X3:-X10)

pred_mc = pred_mc %>% 
  separate(class_class_0, sep = ', ', into = c('neutral', 'antagonistic', 'synergy')) %>%  # 0:neutral, 1:antagonistic, 2:synergy
  left_join(drugbank %>% select(GENERIC_NAME, smiles = SMILES)) 

pred_mc %>% view



# something weird is happening, how can I lose ~300 compound names?
pred_mc %>% drop_na(GENERIC_NAME)

pred_mc = pred_mc %>% 
  mutate(Class = case_when(neutral > antagonistic & neutral > synergy ~ 'neutral',
                           antagonistic > neutral & antagonistic > synergy ~ 'antagonistic',
                           synergy > neutral & synergy > antagonistic ~ 'synergy')
         ) 

pred_mc %>% arrange(desc(synergy),antagonistic,neutral) %>% 
  write_csv(file = here('chemprop\\multiclass_thr.4', 'predictions_multiclass_fixed.csv'))

pred_mc %>% 
  count(Class) %>% 
  ggplot(aes(y = n, x = Class)) +
  geom_bar(stat = 'identity')



pred_mc %>% 
  pivot_longer(-c(smiles, GENERIC_NAME,Class),names_to = 'prob_class', values_to = 'prob') %>% 
  mutate(prob = as.numeric(prob)) %>% 
  ggplot(aes(x = prob, y = prob_class, fill = prob_class)) + 
  geom_density_ridges() +
  facet_wrap(~Class)


# drug_rep_hub -------------------------------------------------------------------



rep_drugs = read_delim("chemprop/drug_rep_hub/repurposing_samples_20200324.txt", 
                                           "\t", escape_double = FALSE, trim_ws = TRUE, 
                                           skip = 9)

# remove trash
rep_drugs = rep_drugs %>% distinct(pert_iname,.keep_all = TRUE)


rep_drugs


rep_drugs %>% 
  select(smiles) %>% 
  drop_na(smiles) %>% 
  write_csv(here('chemprop', file = 'predict_drug_rep_hub.csv'))













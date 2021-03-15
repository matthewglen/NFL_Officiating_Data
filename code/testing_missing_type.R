# Packages ####
library(tidyverse)
library(nflfastR)
library(reprex)

# 2019 season from the data repository
data_2019 <- readRDS(url('https://raw.githubusercontent.com/guga31bb/nflfastR-data/master/data/play_by_play_2018.rds'))
# Take just the penalty related columns
needed_2019 <- data_2019 %>%
  select(play_id, game_id, penalty_type, desc, penalty_player_name, 
         penalty_player_id, penalty) %>%
  filter(penalty == 1)

# Noticed some NA penalty type despite the desc showing it
# Filter for just NA penalty type
needed_2019 %>%
  select(play_id, penalty_type, desc, game_id, penalty, penalty_player_name, 
         penalty_player_id) %>%
  filter(is.na(penalty_type)) %>%
  view()

reprex_clean()

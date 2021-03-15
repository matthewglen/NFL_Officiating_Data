# Packages ####
library(tidyverse)
library(nflfastR)
library(stringr)

# Currently used the 2019 season data before expanding to 1999-2020
# Play by play and officiating data ####
# 2019 season from the data repository
data_2019 <- readRDS(url('https://raw.githubusercontent.com/guga31bb/nflfastR-data/master/data/play_by_play_2019.rds'))
# Take just the needed penalty related columns
needed_2019 <- data_2019 %>%
  select(play_id, game_id, penalty, penalty_type, penalty_player_name, 
         penalty_player_id) %>%
  filter(penalty == 1)
# There are 245 2019 penalties (out of 3568) that have no player ID
# Things like team penalties (formation, illegal substitution etc.)
# Couple of false start but shouldn't miss them too much
needed_2019 %>%
  filter(is.na(penalty_player_id)) %>%
  view()

data_2019 %>%
  select(play_id, penalty_type, desc, game_id, penalty, penalty_player_name, 
         penalty_player_id) %>%
  filter(penalty == 1 & is.na(penalty_type)) %>%
  view()

# Roster data (to get player ID, and positions)
roster_data <- read_csv(url('https://raw.githubusercontent.com/guga31bb/nflfastR-data/master/roster-data/roster.csv'))
# Take just the needed columns relating to player, their ID, their position
needed_roster <- roster_data %>%
  select(team.season,teamPlayers.displayName,teamPlayers.positionGroup,
         teamPlayers.position,teamPlayers.gsisId) %>%
  filter(team.season == 2019)
# There are 45 players in this season roster data without player ID's
needed_roster %>%
  filter(is.na(teamPlayers.gsisId)) %>%
  view()
# Remove them
needed_roster <- needed_roster %>% drop_na()

# Combine the two sets ####
# Combine the two DFs by the ID columns
combined <- merge(needed_2019, needed_roster, 
                  by.x = "penalty_player_id", by.y = "teamPlayers.gsisId",
                  all.x = TRUE)
# Select important info and rearrange
penalties <- combined %>%
  select(play_id, game_id, penalty_type, penalty_player_name, penalty_player_id,
         teamPlayers.positionGroup, teamPlayers.position) %>%
  rename(
    position_group = teamPlayers.positionGroup,
    position = teamPlayers.position
  )

# Understand which penalties and who ####

tester <- penalties %>%
  filter(penalty_type == "Defensive Holding")
print(head(distinct(tester, position), n=50))

# Get types of penalties given
penalty_types <- unique(penalties["penalty_type"])
# Sort out the index
rownames(penalty_types) <- NULL

# For each penalty type, find the positions that were flagged for it
for (t in 1:nrow(penalty_types)) {
  type <- penalty_types[t,1]
  print(type)
  
  byType <- penalties %>%
    filter(penalty_type == type)
  positions <- unique(byType["position"])
  rownames(positions) <- NULL
  
  for (p in 1:nrow(positions)) {
    pos <- positions[p,1]
    print(pos)
  }
}



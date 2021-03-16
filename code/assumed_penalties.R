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
         penalty_player_id, special, special_teams_play, st_play_type) %>%
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
# There are 45 players in 2019 season roster data without player ID's
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
         teamPlayers.positionGroup, teamPlayers.position, special, 
         special_teams_play) %>%
  rename(
    position_group = teamPlayers.positionGroup,
    position = teamPlayers.position
  )

# New DF, no special teams
noSpecial <- penalties[!(penalties$special==1 | penalties$special_teams_play==1),]
# New DF, only special teams
onlySpecial <- penalties[!(penalties$special!=1 | penalties$special_teams_play!=1),]

# Understand which penalties and who ####

# Get types of penalties given no special team
pen_types_no_spec <- unique(noSpecial["penalty_type"])
# Sort out the index
rownames(pen_types_no_spec) <- NULL
# Get types of penalties given with special team
pen_types_spec <- unique(onlySpecial["penalty_type"])
# Sort out the index
rownames(onlySpecial) <- NULL

# For each penalty type, find the positions that were flagged for it in 2019
# This will allow me to create a document detailing for each penalty, at that
# position, which referee might have given it
# Non special teams
for (t in 1:nrow(pen_types_spec)) {
  type <- pen_types_spec[t,1]
   
  byType <- onlySpecial %>%
    filter(penalty_type == type)
  positions <- unique(byType["position"])
  rownames(positions) <- NULL
  newLine <- ""
  
  for (p in 1:nrow(positions)) {
    pos <- positions[p,1]
    newLine <- paste(newLine,type,",",pos,",", sep = "")
    # Remove the last comma from the line
    newLine <- str_sub(newLine,1,nchar(newLine)-1)
    write.table(newLine, 
                "/Users/mattglen/Documents/NFL Analysis/penalties_by_position_2019.csv", 
                append = TRUE, quote = FALSE, sep = ",", eol = "\n", na = "NA", 
                row.names = FALSE, col.names = FALSE)
    newLine <- ""
  }
}

# Special teams
for (t in 1:nrow(pen_types_no_spec)) {
  type <- pen_types_no_spec[t,1]
  
  byType <- noSpecial %>%
    filter(penalty_type == type)
  positions <- unique(byType["position"])
  rownames(positions) <- NULL
  newLine <- ""
  
  for (p in 1:nrow(positions)) {
    pos <- positions[p,1]
    newLine <- paste(newLine,type,",",pos,",", sep = "")
    # Remove the last comma from the line
    newLine <- str_sub(newLine,1,nchar(newLine)-1)
    write.table(newLine, 
                "/Users/mattglen/Documents/NFL Analysis/penalties_by_position_2019.csv", 
                append = TRUE, quote = FALSE, sep = ",", eol = "\n", na = "NA", 
                row.names = FALSE, col.names = FALSE)
    newLine <- ""
  }
}

# Test weird things ####
# Some code to test weird penalty and positions combos
# Check first using needed_2019, because it is unedited
# Defensive offside, RB
needed_2019 %>%
  filter(penalty_type == "Defensive Offside") %>%
  view()
# Offending play is "2548, 2019_10_SEA_SF, 1, Defensive Offside, R.Mostert, 00-0031687"
# Let's see that play description
data_2019 %>%
  select(play_id, penalty_type, desc, game_id, penalty, penalty_player_name, 
         penalty_player_id, special, special_teams_play) %>%
  filter(play_id == 2548 & game_id == "2019_10_SEA_SF") %>%
  view()
# The answer: special teams!
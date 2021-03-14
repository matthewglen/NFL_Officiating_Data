# Packages ####
install.packages("rvest")
library(rvest)
library(tidyverse)
library(ggrepel)
library(ggimage)
library(nflfastR)
library(stringr)


# Functions ####
## Get official data for a given game ID ####
# PFF uses yyyymmddXYZ as game ID. Where XYZ is the home team
getOfficials <- function(pff_full_ID) {
  # URL of desired game
  url <- gsub(
    " ", "", paste(
      "https://www.pro-football-reference.com/boxscores/",pff_full_ID,".htm"
      )
    )
  url %>% read_html() %>% html_nodes(xpath = '//comment()') %>%    # select comments
    html_text() %>%    # extract comment text
    paste(collapse = '') %>%  # collapse to single string
    read_html() %>%  # reread as HTML
    html_node('table#officials') %>%    # select officials node
    html_table(1)    # output as tibble
}

# Use the given gameID, and the getOfficials function
getPositions <-function(game_id, pff_full_ID) {
  # Empty new line
  newLine <- ""
  newLine <- paste(newLine,game_id,",", sep = "")
  # Call getOfficials and iterate through the officials table
  for (i in 1:7) {
    official <- as.data.frame(getOfficials(pff_full_ID))[i,2]
    # Add each official to a new line followed by a comma
    newLine <- paste(newLine,official,",", sep = "")
  }
  # Remove the last comma from the line
  newLine <- str_sub(newLine,1,nchar(newLine)-1)
  # Write the new line to the csv file
  write.table(newLine, 
            "/Users/mattglen/Documents/NFL Analysis/officials_by_game.csv", 
            append = TRUE, quote = FALSE, sep = ",", eol = "\n", na = "NA", 
            row.names = FALSE, col.names = FALSE)
}

# Get game data ####
# Lee Sharp's games file
games <- readRDS(url("http://www.habitatring.com/games.rds"))

# Select just the info we need
gameIDs <- games %>%
  select(game_id, away_team, home_team, old_game_id)
gameIDs %>% head(5)

# Check which home team codes are used in the data
print(distinct(gameIDs, home_team), n=50)

# Create the PFR version of game ID for each game ####
# Create a new DF to calculate and store the PFF ID
pffIDs <- gameIDs %>%
  mutate(
    # Number (date) component. Same as old_game_id, without the last two num
    # and with a 0 on the end
    pffID_num = gsub(" ", "", paste(str_sub(old_game_id,1,nchar(old_game_id)-2),0)),
    # The char component is a lower case version of the home team
    pffID_ch = tolower(home_team)
  )

# Alter the DF so that the home team code lines up with PFFs way of writing
pffIDs <- pffIDs %>%
  mutate(
    pffID_ch = case_when(
      pffID_ch == 'gb' ~ 'gnb',
      pffID_ch == 'ind' ~ 'clt',
      pffID_ch == 'no' ~ 'nor',
      pffID_ch == 'stl' ~ 'ram',
      pffID_ch == 'ten' ~ 'oti',
      pffID_ch == 'bal' ~ 'rav',
      pffID_ch == 'kc' ~ 'kan',
      pffID_ch == 'ne' ~ 'nwe',
      pffID_ch == 'sf' ~ 'sfo',
      pffID_ch == 'oak' ~ 'rai',
      pffID_ch == 'sd' ~ 'sdg',
      pffID_ch == 'ari' ~ 'crd',
      pffID_ch == 'hou' ~ 'htx',
      pffID_ch == 'la' ~ 'ram',
      pffID_ch == 'lac' ~ 'sdg',
      pffID_ch == 'lv' ~ 'rai',
      pffID_ch == 'tb' ~ 'tam',
      TRUE ~ pffID_ch
    )
  )

# Create a new column with the full PFF ID
# If this was to be added to the full URL, the relevant box score would show
pffIDs <- pffIDs %>%
  mutate(
    pff_full_ID = gsub(" ", "", paste(pffID_num,pffID_ch))
  )

# Check pffIDs
pffIDs %>% head(5)
pffIDs %>% tail(5)

# Call the functions for each game ####
# Check row count
nrow(pffIDs)

# For each row in the file...
for (c in 1579:nrow(pffIDs)) {
  #...call the getPositions function. Passing the game_id and pfr_full_id
  # of the given row
  getPositions(pffIDs[c,1], pffIDs[c,7])
}

# Check a specific row if there's a 404 error
pffIDs [1578,]
# Sometimes, usually for the super bowl games, PFR has the wrong team listed at
# home. A check of wikipedia for each error show's Lee's 'games' data is 
# correct. Not sure why PFR has it like this, but a quick edit of the data
# sorts it all out.
# Line 1044 - OAK/TB SB in '03. Need to change from 200301260tam to 200301260rai
pffIDs[1044,7]="200301260rai"
# Line 1311 - CAR/PAT in '04. Need to change from 200402010nwe to 200402010car
pffIDs[1311,7]="200402010car"
# Line 1578 - PAT/PHI in '05. Need to change from 200502060phi to 200502060nwe
pffIDs[1578,7]="200502060nwe"

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
getOfficials <- function(gameID) {
  url <- gsub(" ", "", paste("https://www.pro-football-reference.com/boxscores/",gameID,".htm"))
  url %>% read_html() %>% html_nodes(xpath = '//comment()') %>%    # select comments
    html_text() %>%    # extract comment text
    paste(collapse = '') %>%  # collapse to single string
    read_html() %>%  # reread as HTML
    html_node('table#officials') %>%    # select desired node
    html_table(1)
}

getPositions <-function(gameID) {
  newLine <- ""
  for (i in 1:7) {
    official <- as.data.frame(getOfficials(gameID))[i,2]
    newLine <- paste(newLine,official,",", sep = "")
  }
  newLine <- str_sub(newLine,1,nchar(newLine)-1)
  print(newLine)
}

getPositions("200709060clt")

# Get game data ####
# Lee Sharp's games file
games <- readRDS(url("http://www.habitatring.com/games.rds"))

# Select just the info we need
gameIDs <- games %>%
  select(game_id, away_team, home_team, old_game_id)
gameIDs %>% head(5)

# Check which home tead codes are used in the data
print(distinct(gameIDs, home_team), n=50)

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

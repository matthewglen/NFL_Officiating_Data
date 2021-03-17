# Load required packages
library(tidyverse)
library(nflfastR)

# Officials per game, 1999-2020
data <- read_csv(url('https://raw.githubusercontent.com/matthewglen/NFL_Officiating_Data/main/data/officials_by_game.csv'))

# For each year get the Referees (head of crew) used
for (y in 1999:2020) {
  # Select just games in the given year
  season <- data %>%
    filter(str_detect(game_id, paste(y)))
  # Get a list of unique referee's used in the given year
  headRef <- unique(season["Referee"])
  # For each referee, paste their name in to the head referees, and the year
  for (h in 1:nrow(headRef)) {
    newLine <- paste(y,headRef[h,1],sep = ",")
    write.table(newLine, 
                "/Users/mattglen/Documents/NFL Analysis/head_officials.csv", 
                append = TRUE, quote = FALSE, sep = ",", eol = "\n", na = "NA", 
                row.names = FALSE, col.names = FALSE)
  }
}

# Import the head officials data
headOfficial <- read_csv(url('https://raw.githubusercontent.com/matthewglen/NFL_Officiating_Data/main/data/head_officials.csv'))

# For each head official, find all games they did in a given season
# This results in a file with games grouped by referee
for (w in 1:nrow(headOfficial)) {
  # Go row by row and find the year and official shown
  year <- paste(headOfficial[w,1])
  whiteHat <- paste(headOfficial[w,2])
  # A DF to hold all the games that were in the given year, with the given official
  crew <- data %>%
    filter(str_detect(game_id, paste(year))) %>%
    filter(Referee == whiteHat)
  # For each row of crew, paste the game, and each official in to a csv
  for (c in 1:nrow(crew)) {
    newLine <- paste(crew[c,1],crew[c,2],crew[c,3],crew[c,4],crew[c,5],crew[c,6]
                     ,crew[c,7],crew[c,8], sep=",")
    write.table(newLine, 
                "/Users/mattglen/Documents/NFL Analysis/crews_per_game.csv", 
                append = TRUE, quote = FALSE, sep = ",", eol = "\n", na = "NA", 
                row.names = FALSE, col.names = FALSE)
  }
}

# Crew data
crews <- read_csv(url('https://raw.githubusercontent.com/matthewglen/NFL_Officiating_Data/main/data/crews_per_game.csv'))

# Identify playoff or not in new column
crews$playoff <- ifelse(grepl("_18_",crews$game_id) | grepl("_19_",crews$game_id) 
                        | grepl("_20_",crews$game_id), 1, 0)

# Create a similar DF but change the game_id to just the year
altered <- crews
altered$game_id <- str_sub(altered$game_id,1,4)

# Remove the duplicate rows from altered.
# This represents a crew that has already been seen.
# Ideally, each referee would have one row per year (their crew), but this isn't
# always the case
altered <- altered %>% distinct()

# This actually results in a few almost identical rows, if it wasn't for spelling
# mistakes
# Replacements to make
replaces <- data.frame(from = c(), to = c())




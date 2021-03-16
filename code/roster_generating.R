# Load required packages
library(tidyverse)
library(nflfastR)

data <- read_csv(url('https://raw.githubusercontent.com/matthewglen/NFL_Officiating_Data/main/data/officials_by_game.csv'))

for (y in 1999:2020) {
  year <- data[grep(y, data$game_id), ]
  referee <- unique(test["Referee"])
  for (r in 1:nrow(referee)) {
    headRef <- referee[r,1]
    crew <- data %>%
      filter(str_detect(game_id, year) == TRUE)
    newLine = ""
    for (c in 1:nrow(crew)) {
      umpire <- crew[c,3]
      headL <- crew[c,4]
      lineJ <- crew[c,5]
      backJ <- crew[c,6]
      sideJ <- crew[c,7]
      fieldJ <- crew[c,8]
      newLine <- paste(newLine,umpire,",",headL,",",lineJ,",",backJ,",",sideJ,
                       ",",fieldJ, sep = "")
      # Remove the last comma from the line
      newLine <- str_sub(newLine,1,nchar(newLine)-1)
      write.table(newLine, 
                  "/Users/mattglen/Documents/NFL Analysis/officials_roster.csv", 
                  append = TRUE, quote = FALSE, sep = ",", eol = "\n", na = "NA", 
                  row.names = FALSE, col.names = FALSE)
      newLine <- ""
    }
  }
}

test <- data[grep("2020", data$game_id), ]
head(test)
referee <- unique(test["Referee"])
head(referee)

umpire <- data %>%
  filter(Referee == "Tony Corrente") %>%
  view()


crew <- data %>%
  filter(str_detect(game_id, '2020')) %>%
  view()
         
         
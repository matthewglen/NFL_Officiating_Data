# NFL_Officiating_Data
A repository to hold historical data on NFL officials, and hopefully functions to assign these to each game. Collated from public data, articles and game books in to one useful, concise, repository available for public use.

<b>If you notice any inconsistencies or incorrect elements to the data, please raise it as an issue.</b>

Latest method (12/03/21):
- Scrape PFF for the crew for each game from 1999
- Using the game data from <a href="https://github.com/leesharpe/nfldata/blob/master/data/games.csv">Lee Sharp's games data</a>
- Rosters files are still there (2008 onwards) but they're probably going to end up redundant

Originally (pre 12/03/21), the idea was:

- Collate a file of NFL crew rosters to the best accuracy from public sources.
- Use <a href="https://github.com/guga31bb/nflfastR-data">nflfastR-data</a> and <a href="https://github.com/leesharpe/nfldata/blob/master/data/games.csv">Lee Sharp's games data</a> (which contains the referee of each game) to assign the other officiating positions based on rosters.
- Use a combination of web scraping, reliable sources, mannual adjustments, and user collaboration to adjust the crew for a specific game if it's wrong.

When information is collated:

- After there's a (semi) reliable list of officials per game, make assumptions of who threw the flag for a specific penalty. Make the assumptions using <a href="https://operations.nfl.com/officiating/the-officials/officials-responsibilities-positions/">the NFL's official definitions of responsibilities.</a>

While this process is in development, I cant gaurantee the accuracy of ALL the data, but the accuracy should improve as the project evolves. As always, contributions, suggestions and collaboration are appreciated, just reach out!

Matt😊

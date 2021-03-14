# NFL_Officiating_Data
A repository to hold historical data on NFL officials, and hopefully functions to assign these to each game. Collated from public data, articles and game books, in to one useful, concise, repository available for public use.

<b>If you notice any inconsistencies or incorrect elements to the data, please raise it as an issue, or drop me a message, cheers!</b>

Latest method (12/03/21):
- Scrape PFF for the crew for each game from 1999-2020 ✅
- This is done using the old_game_id from <a href="https://github.com/leesharpe/nfldata/blob/master/data/games.csv">Lee Sharp's games data</a>, and manipulating this to fit PFR url structure. ✅
- Rosters files are still there (2008 onwards) but they're probably going to end up redundant. They may get updated to show all officials each year, with crew data if known, but only if there's a specific us.

When information is collated:

- After there's a reliable list of officials per game, make assumptions of who threw the flag for a specific penalty. These can me made using <a href="https://operations.nfl.com/officiating/the-officials/officials-responsibilities-positions/">the NFL's official definitions of responsibilities.</a>
- The penalty data (e.g. every penalty, from every game, from 1999 onwards) will come from <a href="https://github.com/guga31bb/nflfastR-data">nflfastR-data</a>.

While this process is in development, I cant gaurantee the accuracy of ALL the data, but the accuracy should improve as the project evolves. As always, contributions, suggestions and collaboration are appreciated, just reach out!

Matt😊

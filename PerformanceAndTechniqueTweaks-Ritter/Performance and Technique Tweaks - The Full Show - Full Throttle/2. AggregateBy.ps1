

# Sample data for testing
$genres = 'Strategy', 'Party', 'Cooperative', 'Card Game', 'Wargame', 'Abstract'
$random = [System.Random]::new()
$boardGames =foreach ($i in 1..50000) {
    [PSCustomObject]@{
        Name        = "Game_$i"
        Genre       = $genres[$random.Next(0, $genres.Length)]
        Price       = [math]::Round($random.NextDouble() * 100, 2)
        ReleaseDate = (Get-Date).AddDays(-$random.Next(0, 5000))
    }
}

# Convert the list of PSCustomObject to List<Game> type



$NativeAggregateTime = Measure-Command {
    $boardgames |
        Group-Object -Property Genre |  # Group by Genre
        Select-Object -Property Name, @{Name="TotalPrice"; Expression={($_.Group | Measure-Object -Property Price -Sum).Sum}} |  # Calculate total price
        Sort-Object -Property TotalPrice -Descending  # Sort by total price in descending order
}


Add-Type -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Linq;

public class GameAggregator
{
    public static Dictionary<string, decimal> AggregatePriceByGenre(List<Game> games)
    {
        return games
            .GroupBy(game => game.Genre)
            .ToDictionary(
                group => group.Key,
                group => group.Sum(game => game.Price)
            )
            .OrderByDescending(genrePrices => genrePrices.Value)
            .ToDictionary(x => x.Key, x => x.Value);
    }
}

public class Game
{
    public string Genre { get; set; }
    public decimal Price { get; set; }
    public Game(string genre, decimal price)
    {
        Genre = genre;
        Price = price;
    }
}
"@


$LinqAggregateTime = Measure-Command {
    $BoardGameList = foreach ($boardgame in $Boardgames) {
        [Game]::new($boardgame.Genre, $BoardGame.Price)
    }
    $aggregatedPrices = [GameAggregator]::AggregatePriceByGenre($BoardgameList)
}

[PSCustomObject]@{
    LinqAggregate = $LinqAggregateTime.TotalMilliseconds
    NativeAggregate = $NativeAggregateTime.TotalMilliseconds
}


# DOTNET 9 LINQ Aggregate
Add-Type -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Linq;

public static class LinqAggregator
{
    public static Dictionary<string, decimal> AggregatePriceByGenre(List<GameEntry> games)
    {
        return games
            .AggregateBy(
                keySelector: game => game.Genre,
                seed: 0m,
                (totalValue, currentGame) => totalValue + currentGame.Price
            )
            .OrderByDescending(kvp => kvp.Value)
            .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
    }
}

public class GameEntry
{
    public string Genre { get; set; }
    public decimal Price { get; set; }

    public GameEntry(string genre, decimal price)
    {
        Genre = genre;
        Price = price;
    }
}
"@
$LinqDotNet9AggregateTime = Measure-Command {
    $BoardGameList = foreach ($boardgame in $Boardgames) {
        [GameEntry]::new($boardgame.Genre, $BoardGame.Price)
    }
    $aggregatedPrices =   [LinqAggregator]::AggregatePriceByGenre($BoardGameList)
}

[PSCustomObject]@{
    LinqAggregate = $LinqAggregateTime.TotalMilliseconds
    NativeAggregate = $NativeAggregateTime.TotalMilliseconds
    LinqDotNet9Aggregate = $LinqDotNet9AggregateTime.TotalMilliseconds
}



# Production example (Large DataSet 500000 entries)

<#
LinqAggregate NativeAggregate LinqDotNet9Aggregate
------------- --------------- --------------------
     13634.26        33673.74             14688.88
#>

# Production example (Really Large DataSet 5M entries)

<#
LinqAggregate NativeAggregate LinqDotNet9Aggregate
------------- --------------- --------------------
    183868.56       603443.12            188902.70
#>
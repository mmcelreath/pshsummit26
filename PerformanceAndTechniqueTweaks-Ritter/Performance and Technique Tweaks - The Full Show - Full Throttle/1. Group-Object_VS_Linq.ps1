# When we want to group objects in PowerShell, we usually use Group-Object. - Its handy for grouping objects by a property.
# But when we want to go fast on large data sets, we can use LINQ to group objects by a property. By using GroupBy() method of LINQ, we can group objects by a property and get the count of each group. This is much faster than using Group-Object.

# Create fake BoardGame objects
$genres = 'Strategy', 'Party', 'Cooperative', 'Card Game', 'Wargame', 'Abstract'
$random = [System.Random]::new()
$boardGames =foreach ($i in 1..1000000) {
    [PSCustomObject]@{
        Name        = "Game_$i"
        Genre       = $genres[$random.Next(0, $genres.Length)]
        Price       = [math]::Round($random.NextDouble() * 100, 2)
        ReleaseDate = (Get-Date).AddDays(-$random.Next(0, 5000))
    }
}
$boardGames | Export-CSV -Path '1. BoardGames.csv' -NoTypeInformation

$boardGames = Import-Csv -Path '1. BoardGames.csv' 
# Measure the time it takes to group objects using Group-Object
$boardGames[0..10] | Group-Object -Property Genre
$groupObjectTime = Measure-Command {
    $grouped1 = $boardGames | Group-Object -Property Genre
}

$boardGames[1..10] | Group-Object -Property Genre -NoElement
$groupObjectNoElementTime = Measure-Command {
    $grouped5 = $boardGames | Group-Object -Property Genre -NoElement
}

# Let us build a class to query the data using linq

Add-Type -TypeDefinition @"
using System;
using System.Linq;
using System.Collections.Generic;

public class GroupResult {
    public string Genre { get; set; }
    public int Count { get; set; }
}

public static class LinqBoardGameHelper {
    public static List<GroupResult> GroupByGenre(List<object> items) {
        return items
            .GroupBy(i => (string)((dynamic)i).Genre)
            .Select(g => new GroupResult { Genre = g.Key, Count = g.Count() })
            .ToList();
    }
}
"@

$boardGamesList = [System.Collections.Generic.List[object]]::new()
$boardGamesList.AddRange($( $boardGames))

# LINQ GroupBy test
[LinqBoardGameHelper]::GroupByGenre($boardGamesList[1..10])
$linqGroupTime = Measure-Command {
    $grouped2 = [LinqBoardGameHelper]::GroupByGenre($boardGamesList)
}

Write-Host "Summary:"
[PSCustomObject]@{
    'Group-Object' = $($groupObjectTime.TotalMilliseconds)
    'LINQ GroupBy' = $($linqGroupTime.TotalMilliseconds)
    'Group-Object NoElement' = $($groupObjectNoElementTime.TotalMilliseconds)
}


# The LINQ GroupBy method is significantly faster than the Group-Object cmdlet in PowerShell for large datasets.

# But our Methods and classes are kinda static, let us make them more dynamic and reusable.

Add-Type -TypeDefinition @"
using System;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;

public class GroupResultByKey {
    public string Key { get; set; }
    public int Count { get; set; }
}

public static class LinqGroupBy {
    public static List<GroupResultByKey> GroupByProperty(List<object> items, string propertyName) {


        // Use reflection on the first object to get the properties
        var firstItem = items.First();
        var psObject = firstItem as System.Management.Automation.PSObject;


        // Look for the property in the PSObject's Properties collection
        var property = psObject.Properties[propertyName];


        // Group the items by the specified property and count them
        return items
            .GroupBy(i => {
                var p = ((System.Management.Automation.PSObject)i).Properties[propertyName].Value?.ToString();
                return p; 
            })
            .Select(g => new GroupResultByKey { Key = g.Key, Count = g.Count() })
            .ToList();
    }
}
"@

$ResultbyGenre = [LinqGroupBy]::GroupByProperty($boardGamesList, 'Genre')
$ResultbyPrice = [LinqGroupBy]::GroupByProperty($boardGamesList, 'Price')

$ResultbyGenre

# As we want to mimic the Group-Object output, we can try to make use of the CountBy Method in Linq in .NET 9.0 and above.
# Unfortunately in PowerShell 7.5 we are still using .NET 8.0, so we cannot use the CountBy method.

# Luckily, the PowerShell preview release 7.6 is using .NET 9.0, so we can use the CountBy method in Linq. 

# Load the required assemblies to access LINQ


Add-Type -TypeDefinition @"
using System;
using System.Linq;
using System.Collections.Generic;

public static class LinqCountBy {
    public static List<KeyValuePair<string, int>> CountByProperty(List<object> items, string propertyName) {
        // Use LINQ's CountBy directly with the selected property
        var result = items
            .OfType<System.Management.Automation.PSObject>() // Ensure we're working with PSObject
            .Select(i => i.Properties[propertyName]?.Value?.ToString())  // Access the property dynamically
            .CountBy(p => p)  // CountBy groups by the value of the selected property
            .ToList();  // Collect the result into a list
        
        // Return the result as a list of KeyValuePair<string, int> where Key is the property value and Value is the count
        return result.ToList();
    }
}
"@

$ResultbyGenreCountBy = [LinqCountBy]::CountByProperty($boardGamesList, 'Genre')

$ResultbyGenreCountBy

$linqCountTime = Measure-Command {
    $grouped3 = [LinqCountBy]::CountByProperty($boardGamesList, 'Genre')
}


Write-Host "Summary:"
[PSCustomObject]@{
    'Group-Object' = $($groupObjectTime.TotalMilliseconds)
    'LINQ GroupBy' = $($linqGroupTime.TotalMilliseconds)
    'LINQ CountBy' = $($linqCountTime.TotalMilliseconds)
    'Group-Object NoElement' = $($groupObjectNoElementTime.TotalMilliseconds)
}

<#
    Production example (Large DataSet 5M entries) in Milliseconds
    Group-Object           : 252712.2462
    LINQ GroupBy           : 1598.574
    LINQ CountBy           : 1155.7077
    Group-Object NoElement : 225277.9013
#>
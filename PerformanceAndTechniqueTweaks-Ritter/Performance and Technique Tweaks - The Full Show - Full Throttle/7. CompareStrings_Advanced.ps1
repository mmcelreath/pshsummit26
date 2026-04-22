# Have you ever been in a situation where you have to compare versions of 
# Software for instance, but sometimes they were called 2 and sometimes 02?

# With the StringComparer class we can do this pretty easily, by using
# the NumericOrdering option




$numericStringComparer = [System.StringComparer]::Create(
    [System.Globalization.CultureInfo]::CurrentCulture,
    [System.Globalization.CompareOptions]::NumericOrdering
)

$numericStringComparer.Equals("02", "2") 

$Values =  "Windows 10", "Windows 8", "Windows 11"

$Values | Sort-Object 

[Array]::Sort($Values, $numericStringComparer)

$Values


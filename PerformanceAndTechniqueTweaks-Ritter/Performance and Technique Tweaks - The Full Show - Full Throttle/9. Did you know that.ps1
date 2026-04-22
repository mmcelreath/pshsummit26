# Did you know that...

# ... you can convert a string into a version object and compare it to another version object?

$version1 = [version]"1.0.0"
$version2 = [version]"1.0.1"
if($version1 -lt $version2){
    Write-Host "$version1 is less than $version2"
}


# but whats with crazy version numbers like 1.0.0-beta.1?
$version3 = [version]"1.0.0-beta.1"

# we can use the semver type (System.Management.Automation.SemanticVersion)
$semver1 = [semver] "1.0.0-beta.1"
$semver2 = [semver] "1.0.0-alpha.2"
if($semver1 -gt $semver2){
    Write-Host "$semver1 is greater than $semver2"
}
# ... you can prefix a string like starting with 0 and till 9 
# -> ToString options to name:
1..13 | Foreach-Object {

    $numberString = $_.ToString("D2") # D2 formats the number as a string with at least 2 digits, padding with zeros if necessary
    Write-Host $numberString
}

# but what if we dont need leading zeros but we need X instead of 0?

1..13 | Foreach-Object {
    $numberString = ([string]$_).PadLeft(2, 'X') # PadLeft formats the number as a string with at least 2 digits, padding with 'X' if necessary
    Write-Host $numberString
}

#... you can compare whole objects to find duplicates in an array?


$objects = @(
    [PSCustomObject]@{ Name = "Bob"; Age = 25 },
    [PSCustomObject]@{ Name = "Alice"; Age = 30 },
    [PSCustomObject]@{ Name = "Alice"; Age = 30 }
)

# Wont work
$objects | Select-Object -Unique
# Works but only for the properties we specify
$objects | Select-Object -Unique -Property Name, Age

# Method 1: Group-Object 

$objects | Group-Object -Property Name, Age | ForEach-Object { $_.Group[0] }

# Caution this only works for named properties, but what if we
# want to build a generic function?


# Method 2: Using a HashSet, as HashSet is a collection that contains no duplicate elements and is based on the hash code of the objects.
$hashSet = [System.Collections.Generic.HashSet[string]]::new()

$uniqueObjects = @()
$objects | ForEach-Object {
    $hash = ($_.PSObject.Properties | Sort-Object Name | ForEach-Object { "$($_.Name):$($_.Value)" }) -join ";"
    if($hashSet.Add($hash)){
        $uniqueObjects += $_
    }
}


$var1 = [PSCustomObject]@{ Name = "Bob"; Age = 25 } 
$var1.psobject.properties

# ...with ${} create crazy variable names that can even include emojis, 
# but be careful with those as they can be hard to read and maintain, and 
# be cautious by PSProviders 



${crazyVariableName💻} = 123

Get-Variable -Name "Crazy*"
Remove-Variable -Name crazyVariableName💻


$crazyVariableName💻2 = 1234


# While talking PSProviders, we can use ${} for more crazy stuff?
# like creating files?

test-path C:\Temp\PowerShellSummit

${c:\Temp\PowerShellSummit} = '2026'

test-path C:\Temp\PowerShellSummit

get-content C:\Temp\PowerShellSummit

${c:\Temp\PowerShellSummit} = 'See you in 2027'

get-content C:\Temp\PowerShellSummit

# We can Read as well 
${c:\Temp\PowerShellSummit} 


Remove-Item C:\Temp\PowerShellSummit


# But can we access the registry as well?

${HKLM:\Software\Microsoft\Windows\CurrentVersion\wsman\}

get-help about_variables -full

# Bummer, we cant but the error message is quite interesting, 
# the IcontentCmdLetProvider interface is not implemented here. 

# Looking into the future, maybe we can use this to create some
# kind of a PSProvider for a database or something like that,
# and then we could use ${} to access data in that database like we do with files

# ... you can use the comparison operator to act like filters 

'a','b','c' -eq 'b' # returns b
'a','b','c' -eq 'd' # returns $null


# as we are talking full throttle, match is the fastest way to filter in PowerShell. 

'a','b','c' -match 'b' # returns b

[string]::IsNullOrEmpty($('a','b','c' -eq 'b' ))

('a','b','c').Contains('b') # returns true

# ... you can have date objects as well like datetime objects?

$date1 = [datetime]"2024-01-01" # gives us minutes etc. as well
$date1 |fl

$date2 = [System.DateOnly]"2024-01-01" # only date, no time

[System.DateOnly]"2024-01-01" -gt [System.DateOnly]"2023-12-31" # we can compare them as well

# mixed comparisons wont work
[System.DateOnly]"2024-01-01" -gt [datetime]"2023-12-31"

# but we can cast them into a dateonly object and then compare them

[System.DateOnly]"2024-01-01" -gt [System.DateOnly]::FromDateTime([datetime]"2023-12-31")


# ... you can create a range with the .. operator for numbers, but also for Chars?

# Number range
1..10

# Char range
'a'..'z'

# You can also create ranges for uppercase letters
'A'..'Z'

# it uses the index of the ascii table 
'a'..'Z'

[int][char]'a'
[char]42
[char]96

# ... Attach "parameter" validation to any Variable

[ValidateRange(1, 100)] $Range = 50 # works
$Range = 150 # throws an error

# Also have an accurate variable with valid paths?
[ValidateScript({ Test-Path $_ })] $ValidPath = "C:\Temp" # works
$ValidPath = "C:\NonExistingPath" # throws an error


# ... instead of using get-CIMInstance with a query, we can use the WMISearcher class which is faster as it uses the WMI COM API directly
$query = "SELECT * FROM Win32_Process WHERE Name LIKE 'calc%'"
([WMISearcher] $query).Get()

Measure-Command {
    $query = "SELECT * FROM Win32_Process WHERE Name LIKE 'calc%'"
    Get-CimInstance -Query $query 
}

Measure-Command {
    ([WMISearcher] "SELECT * FROM Win32_Process WHERE Name LIKE 'calc%'").Get()
}









# using the eq operator is pretty handy if you need to work with
# the compared value further and dont rely on the boolean result.


#... you can trick the intellisense to give the user
# properties and methods of a specific type which are not the return type
# of the function?

function OutputTypeTest {
    [OutputType([system.int32])]

    Param(

    )
    return 'Hello'

}

(OutputTypeTest) # intellisense should give us int32 properties and methods via dotting
# bjompen.com https://bjompen.com/#/posts/pwsh.getmember
function ReturnTest {

    [CmdletBinding()]
    Param(

    )
    return 'Hello'

}
(ReturnTest). # intellisense should give us string properties and methods via dotting

# make sure that the outputtype attribute is alligned 
# with the actual return type of the function, 
# otherwise we can get some weird behavior in the intellisense 

# Due to TDD it is also handy to test this with pester like

(Get-Command OutputTypeTest).OutputType.Type.Name
(Get-Command ReturnTest).OutputType.Type.Name



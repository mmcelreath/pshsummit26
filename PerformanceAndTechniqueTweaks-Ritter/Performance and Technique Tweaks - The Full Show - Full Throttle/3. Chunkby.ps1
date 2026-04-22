# -----------------------------
# Step 1: Chunking data in "pure" PowerShell
# -----------------------------

$someArray = 1..5
$chunkSize = 2
$counter = @{ count = 0 }

# Use Group-Object and a counter to create chunks
$result = $someArray | Group-Object -Property {
    [math]::Floor( ($counter.count)++ / $chunkSize )
}

# Show the result
$result

# Access individual items
$result[0].Group[0]  # First item of first chunk

# -----------------------------
# Step 2: Chunking with .NET LINQ
# -----------------------------

$values = [int32[]]@(1..5)

# Use LINQ Chunk method
$Chunks = [System.Linq.Enumerable]::Chunk[int32]($values, 2)
$Chunks.GetType()
$Chunks.count
$chunks
$Chunks | get-member -inputobject $chunks

$ChunksArray = @($Chunks)

# Access first chunk
$ChunksArray[0][1]

# Simplified inline version
$Chunks = @([System.Linq.Enumerable]::Chunk[int32]([int32[]]@(5..1), 2))
$Chunks[1]  # Second chunk

# -----------------------------
# Step 3: Real-world example: batching Graph API calls
# -----------------------------

# Create 100 imaginary Graph calls
$GraphCalls = 1..100 | ForEach-Object { 
    [PSCustomObject]@{
        Id  = $_
        Url = "https://graph.microsoft.com/v1.0/users/$_"
    }
}

$ChunkSize = 20

# Chunk the calls and wrap each chunk into the "requests" property
$GraphCallsChunks = [System.Linq.Enumerable]::Chunk[object]($GraphCalls, $ChunkSize) | 
    ForEach-Object { 
        @{ requests = $_ }
    }

# Materialize into an array for easy indexing
$ArrayGraphCallsChunks = @($GraphCallsChunks)

# Convert the first chunk to JSON for submission to Graph
$ArrayGraphCallsChunks[0] | ConvertTo-Json -Depth 5
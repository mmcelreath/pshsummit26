# FiFo is nice and all, but sometimes you want to prioritize certain tasks. 
# Enter the PriorityQueue!

$taskQueue = New-Object 'System.Collections.Generic.PriorityQueue[string, int]'

$taskQueue.Enqueue("Go to PSHSummit 2026", 1) # Highest priority
$taskQueue.Enqueue("Have conversations with attendees", 3)
$taskQueue.Enqueue("Prep my Sessions", 1) # Highest priority
$taskQueue.Enqueue("Present Sessions", 2)

# Lets pop the tasks in order of priority
$taskQueue.Dequeue()
$taskQueue.Dequeue() 

# Due to the same priority, FiFo will be applied, so 
# I will get "Go to PSHSummit 2026" first and then "Prep my Sessions"
# But I wont do 'The Ben', we need a way to implement LIFO

# Entries are removed
$taskQueue.UnorderedItems





# Whats this? A comparer for the priority queue? Lets dig deeper into that!
$taskQueue.Comparer

##############################


class PriorityTupleComparer : System.Collections.Generic.IComparer[System.Tuple[int, datetime]] {
    [int] Compare([System.Tuple[int, datetime]] $x, [System.Tuple[int, datetime]] $y) {
        # Compare Priority descending
        if ($x.Item1 -lt $y.Item1) { return -1 }
        elseif ($x.Item1 -gt $y.Item1) { return 1 }

        # If Priority equal, compare Timestamp - Last in first out  (LIFO)
        if ($x.Item2 -gt $y.Item2) { return -1 }
        elseif ($x.Item2 -lt $y.Item2) { return 1 }

        return 0
    }
}

# Create the PriorityQueue
$comparer = [PriorityTupleComparer]::new()
$queue = [System.Collections.Generic.PriorityQueue[object, System.Tuple[int, datetime]]]::new($comparer)

# Add items
$queue.Enqueue([PSCustomObject]@{ Description="Go to PSHSummit 2026" }, [Tuple]::Create(1, [datetime]"2026-03-20 08:00"))
$queue.Enqueue([PSCustomObject]@{ Description="Present Sessions" }, [Tuple]::Create(2, [datetime]"2026-03-22 09:00"))
$queue.Enqueue([PSCustomObject]@{ Description="Prep my Sessions" }, [Tuple]::Create(1, [datetime]"2026-03-20 09:00"))
$queue.Enqueue([PSCustomObject]@{ Description="Have conversations with attendees" }, [Tuple]::Create(3, [datetime]"2026-03-19 12:00"))

# Dequeue in order
while ($queue.Count -gt 0) {
    $queue.Dequeue()
}
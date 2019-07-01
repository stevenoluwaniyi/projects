
# Hackerrank - https://www.hackerrank.com/challenges/migratory-birds/problem
def migratoryBirds(arr):
    arr.sort()
    tracker = {}
    list_val = {}
    new_min = 0
    count = 0
    for item in arr:
        if item not in tracker:
            tracker[item] = count+1
        else:
            tracker[item] += 1
    v=list(tracker.values())
    k=list(tracker.keys())
    val = k[v.index(max(v))]
    return val
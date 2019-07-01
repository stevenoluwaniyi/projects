#Hacckerrank problem :- https://www.hackerrank.com/challenges/sock-merchant/problem

def sockMerchant(n,ar):
  tracker = 0
  count = 0
  non_dupli = list(dict.fromkeys(ar))
  non_dupli.sort()
  for i in non_dupli:
    if i in ar:
      tracker = ar.count(i) / 2.0
      if tracker % 2.0 == 0.0:
        count += tracker
      else:
        count += math.floor(tracker)
  return int(count)
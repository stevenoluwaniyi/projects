# Hackerank algorithm: https://www.hackerrank.com/challenges/birthday-cake-candles/submissions/code/107514351
def birthdayCakeCandles(ar):
  ar.sort()
  max_val = ar[len(ar) - 1]
  count = 0
  for length in ar:
    if length == max_val:
      count += 1
  return count
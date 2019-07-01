#Gotten from Hackerrank exercise. https://www.hackerrank.com/challenges/electronics-shop/problem

def getMoneySpent(keyboard,drive,budget):
  highest_len = max(keyboard,drive)
  minimum_len = min(keyboard,drive)
  empty_array = [highest_len,minimum_len]
  cost_array = []
  if len(keyboard) == len(drive):
    highest_len = keyboard
  if min(keyboard) >= budget or min(drive) >= budget:
    return -1
  keyboard.sort(reverse=True)
  drive.sort(reverse=True)
  for i in empty_array[0]:
    b = 0
    while b != len(minimum_len):
      value = i + empty_array[1][b]
      if value <= budget:
        cost_array.append(value)
      else:
        cost_array.append(-1)
      b += 1
  return max(cost_array)

print getMoneySpent([8,8],[8,8,8],8)
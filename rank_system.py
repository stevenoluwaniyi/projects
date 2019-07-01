"""https://www.hackerrank.com/challenges/climbing-the-leaderboard/problem

    This is an incomplete solution due to its failure for 4 test cases. I will post a complete working solution soon enough :)
    """

def rank_people(arr):
  rank_count = 1
  rank_array = []
  new_people_list = []
  arr.sort(reverse=True)
  cur_max = arr[0]
  i = 0
  while i != len(arr):
    #if the max item in the list equals the current value in the index
    if cur_max == arr[i]:
      #append the rank_count to the rank list
      rank_array.append(rank_count)
      #append the value at that index to the new list to keep track of the index
      new_people_list.append(arr[i])
      i += 1
    else:
      rank_count += 1
      if i <= len(new_people_list):
        cur_max = arr[len(new_people_list)]
  return rank_array

def slot_rank(rank_array, pos_array):
  final_array = []
  new_rank_array = []
  
  for score,pos in enumerate(pos_array):
    rank_array.append(score)
    new_rank_array = rank_people(rank_array)
  
    final_array.append(new_rank_array[pos])
    print final_array
  return final_array
    
crc_rank = [100,100,90,80]
stevens_rank = [60,80,78,99]

print slot_rank(crc_rank,stevens_rank)
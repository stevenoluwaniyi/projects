public class Solution {

    // Hackkerank: https://www.hackerrank.com/challenges/compare-the-triplets/submissions/code/93631451
    static List<Integer> compareTriplets(List<Integer> a, List<Integer> b) {
        int a_point = 0;
        int b_point = 0;
        List<Integer> points = new ArrayList<>();
        if(a.size() == b.size()){
            for(int i =0; i < a.size(); i++){
                if((a.get(i)) != b.get(i)){
                    if((a.get(i) > b.get(i))){
                        a_point++;
                    }else{
                        b_point++;
                    }
                }
            }
            points.add(a_point);
            points.add(b_point);
        }
            return points;

    }
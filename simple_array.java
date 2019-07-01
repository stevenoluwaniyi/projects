
//Hackerrank ; https://www.hackerrank.com/challenges/simple-array-sum/submissions/code/93628587
public class Solution {

    /*
     * Complete the simpleArraySum function below.
     */
    static int simpleArraySum(int[] ar) {
        int sum =0;
        for(int i = 0; i < ar.length; i++){
            
            sum += ar[i];
        }
        return sum;
        /*
         * Write your code here.
         */

    }
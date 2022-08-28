import edu.princeton.cs.algs4.StdIn;
import edu.princeton.cs.algs4.StdOut;
import edu.princeton.cs.algs4.StdRandom;

public class RandomWord {

    public static void main(String[] args) {
        int count = 0;
        String champion = "";

        while (!StdIn.isEmpty()) {
            count++;
            String input = StdIn.readString();
            if (StdRandom.bernoulli((double) 1/count)) {
                champion = input;
            }
        }
        StdOut.println(champion);
    }
}


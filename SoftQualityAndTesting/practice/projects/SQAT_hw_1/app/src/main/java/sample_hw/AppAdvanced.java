package sample_hw;

import java.util.Random;

public class AppAdvanced {

    public int MagickNum() {
        return 42;
    }

    class Bar {
        private int num = 5;

        Bar() {
        }

        public int GetRandom() {
            Random rand = new Random();
            return rand.nextInt(1000) * num;
        }
    }

    public void Compute() {
        int res = new Bar().GetRandom();
        int correct_res = res / 2;
    }

}
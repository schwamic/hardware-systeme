public class Blinky {
  static final int delay = 4;
  native static void setLeds (int state); 

  // Blinky: Call setLeds 64 times
  public static int main(String[] args) {
    int n, k;
    int c = 0;
    for (n = 0; n < 8; n++) {
      for (k = 0; k < delay; k++) {
        setLeds (1 << n);
        c++;
      }
    }
    for (n = 7; n >= 0; n--){
      for (k = 0; k < delay; k++) {
        setLeds (1 << n);
        c++;
      }
    }
    return c;
  }
}

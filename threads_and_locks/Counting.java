public class Counting {  
  public static void main(String args[]) throws InterruptedException {
    class Counter {
      private int count = 0;
      public synchronized void increment() {
        count += 1;
      }

      public int getCount() { return count; }
    }

    final Counter counter = new Counter();

    class CountingThread extends Thread {
      public void run() {
        for(int x = 0; x<10000; ++x) {
          counter.increment();
        }
      }
    }

    CountingThread c1 = new CountingThread();
    CountingThread c2 = new CountingThread();
    c1.start(); c2.start();
    c1.join(); c2.join();
    System.out.println(counter.getCount()); 
  } 
}
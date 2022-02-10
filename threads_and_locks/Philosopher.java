import java.util.Random;

class Chopstick {
  private int id;

  public Chopstick(int id) {
    this.id = id;
  }

  public int getId() {
    return this.id;
  }
}

class Philosopher extends Thread {
  private String name;
  private Chopstick first, second;
  private Random random;

  public Philosopher(Chopstick left, Chopstick right, String name) {
    if(left.getId() < right.getId()) {
      this.first  = left;
      this.second = right;
    } else {
      this.first  = right;
      this.second = left;
    }
    random = new Random();
    this.name = name;
  }

  public void run() {
    try {
      while(true) {
        Thread.sleep(random.nextInt(1000));
        System.out.println("Thinking"); 
        System.out.println(name); 
        synchronized(first) {
          synchronized(second) {
            Thread.sleep(random.nextInt(1000));
            System.out.println("Eating"); 
            System.out.println(name); 
          }
        }
      }
    } catch(InterruptedException e) {}
  }
}

class Main {  
  public static void main(String args[]) throws InterruptedException { 
    
    System.out.println("Hello, world!"); 

    Chopstick one = new Chopstick(1);
    Chopstick two = new Chopstick(2);
    Chopstick three = new Chopstick(3);
    Chopstick four = new Chopstick(4);
    Chopstick five = new Chopstick(5);

    Philosopher p1 = new Philosopher(one, two, "p1");
    Philosopher p2 = new Philosopher(two, three, "p2");
    Philosopher p3 = new Philosopher(three, four, "p3");
    Philosopher p4 = new Philosopher(four, five, "p4");
    Philosopher p5 = new Philosopher(five, one, "p5");
    
    p1.start(); p2.start(); p3.start(); p4.start(); p5.start();
    p1.join(); p2.join(); p3.join(); p4.join(); p5.join();
  } 
}



class HelloWorld {  
  public static void main(String args[]) throws InterruptedException { 
    Thread myThread = new Thread() {
      public void run() {
        System.out.println("Threaded Hello!");
      }
    };
    myThread.start();
    Thread.yield();
    //Thread.sleep(1);
    System.out.println("Hello from main Thread!");
    myThread.join();
  } 
}
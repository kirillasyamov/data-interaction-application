package com.app;
import java.io.IOException;

public class Program {

    public static void main( String[] args ) throws IOException, InterruptedException {
        new ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor();
        
        String[] dragon = {"                \\\\||/    ", "                |  @___o0", "      /\\  /\\   / (__,,,,|", "     (  /  ) /^\\) /      ", "    (  \\ /^\\/   _)       ", "    (    /_ /  / _)      ", " /\\  ( / / ||  | )_)     ", " ||   \\/  |(,,) )__)     ", " ||    \\ /    \\)___)\\    ", " | \\____(      )___) )___", " \\______(_______;;; __;;;"};

        for (int i = 0; i < 11; i++ ) {
            
            System.out.println( " ".repeat(12) + dragon[i] );

        }
        System.out.print("\n MAIN MENU \n USERNAME: _______________\n PASSWORD: _______________");
    }
}

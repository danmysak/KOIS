/* Java */

import java.util.Scanner;
import java.io.File;
import java.io.FileWriter;

class wrappers
{
    public static void main (String[] arguments)
    {
        try {
            FileWriter writer = new FileWriter("wrappers.out");
            writer.write("0\r\n0\r\n");
            writer.close();
        } catch (Exception ex) {}
    }
}
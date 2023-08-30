# Blinky.class

## Disassembled Blinky.class

```bash
Compiled from "Blinky.java"
public class Blinky {
  static final int delay;

  public Blinky();
    Code:

       0: aload_0
       1: invokespecial #1                  // Method java/lang/Object."<init>":()V
       4: return

  static native void setLeds(int);

  public static void main(java.lang.String[]);
    Code:
       0: iconst_0
       1: istore_1
       2: iload_1
       3: bipush        8
       5: if_icmpge     33
       8: iconst_0
       9: istore_2
      10: iload_2

      11: iconst_4
      12: if_icmpge     27
      15: iconst_1
      16: iload_1
      17: ishl
      18: invokestatic  #3                  // Method setLeds:(I)V
      21: iinc          2, 1
      24: goto          10
      27: iinc          1, 1
      30: goto          2
      33: bipush        7
      35: istore_1
      36: iload_1
      37: iflt          65
      40: iconst_0
      41: istore_2
      42: iload_2
      43: iconst_4
      44: if_icmpge     59
      47: iconst_1
      48: iload_1
      49: ishl
      50: invokestatic  #3                  // Method setLeds:(I)V
      53: iinc          2, 1
      56: goto          42
      59: iinc          1, -1
      62: goto          36
      65: return
}
```

## Class Instance (ClassLoader)

```bash
{
  [
    // Const Pool
    {10 0 4 21 0 0 0 } 
    {7 22 0 0 0 0 0 } 
    {10 0 2 23 0 0 0 } 
    {7 24 0 0 0 0 0 } 
    {1 0 0 0 0 0 0 delay} 
    {1 0 0 0 0 0 0 I} 
    {1 0 0 0 0 0 0 ConstantValue} 
    {3 0 0 0 0 0 4 } 
    {1 0 0 0 0 0 0 <init>} 
    {1 0 0 0 0 0 0 ()V} 
    {1 0 0 0 0 0 0 Code} 
    {1 0 0 0 0 0 0 LineNumberTable} 
    {1 0 0 0 0 0 0 setLeds} 
    {1 0 0 0 0 0 0 (I)V} 
    {1 0 0 0 0 0 0 main} 
    {1 0 0 0 0 0 0 ([Ljava/lang/String;)I} 
    {1 0 0 0 0 0 0 StackMapTable} 
    {7 25 0 0 0 0 0 } 
    {1 0 0 0 0 0 0 SourceFile} 
    {1 0 0 0 0 0 0 Blinky.java} 
    {12 9 0 0 0 10 0 } 
    {1 0 0 0 0 0 0 Blinky} 
    {12 13 0 0 0 14 0 } 
    {1 0 0 0 0 0 0 java/lang/Object} 
    {1 0 0 0 0 0 0 [Ljava/lang/String;}]

    // Flags  
    33 [] 

    // Fields
    [{24 delay I [{ConstantValue [0 8]}]}] 

    // Methods
    [{1 <init> ()V [
      {Code [0 1 0 1 0 0 0 5 42 183 0 1 177 0 0 0 1 0 12 0 0 0 6 0 1 0 0 0 1]}
    ]} 
    {264 setLeds (I)V []} 
    {9 main ([Ljava/lang/String;)I[
      {Code [0 2 0 4 0 0 0 75 3 62 3 60 27 16 8 162 0 31 3 61 28 7 162 0 18 4 27 120 184 0 3 132 3 1 132 2 1 167 255 239 132 1 1 167 255 225 16 7 60 27 155 0 31 3 61 28 7 162 0 18 4 27 120 184 0 3 132 3 1 132 2 1 167 255 239 132 1 255 167 255 227 29 172 0 0 0 2 0 12 0 0 0 58 0 14 0 0 0 8 0 2 0 9 0 10 0 10 0 17 0 11 0 23 0 12 0 26 0 10 0 32 0 9 0 38 0 15 0 45 0 16 0 52 0 17 0 58 0 18 0 61 0 16 0 67 0 15 0 73 0 21 0 17 0 0 0 63 0 8 254 0 4 1 0 1 255 0 7 0 4 7 0 18 1 1 1 0 0 19 255 0 5 0 4 7 0 18 1 0 1 0 0 2 255 0 5 0 4 7 0 18 1 1 1 0 0 19 255 0 5 0 4 7 0 18 1 0 1 0 0]}
    ]}]

    // Attributes
    [{SourceFile [0 20]}]
  }
```

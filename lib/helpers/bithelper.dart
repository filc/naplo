import 'dart:math';

class BitHelper {
  static bool isBitSet(int number, int bitIndex) =>
      number & pow(2, bitIndex) != 0;
  static int toogleSingleBit(int number, int bitIndex) =>
      number ^ pow(2, bitIndex);
}

import 'dart:core';


  List<int> winningNumbers = [12, 6, 34, 41, 9];

  void main() {
    List<int> ticket1 = [45, 2, 9, 18, 33];
    List<int> ticket2 = [41, 17, 26, 32, 35];

    checkNumbers(ticket1);
    checkNumbers(ticket2);
  }

  void checkNumbers(List<int> myNumbers) {
    for (int tik in myNumbers) {
      for (int win in winningNumbers) {
        if (tik == win) {
          print('tik $tik == win $win');
          break;
        }
      }
    }
  }


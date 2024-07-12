import 'package:dars_73/controller/test_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class TestHelpers {
  static void checkAnswer(String answer, String correctAnswer, int control1,
      int control2, Function(int, int) updateControl) {
    if (answer == correctAnswer) {
      control1++;
    } else {
      control2++;
    }
    updateControl(control1, control2);
  }

  static Future<void> nextQuestion(
      BuildContext context,
      AnimationController controller,
      int currentIndex,
      Function(int) updateIndex) async {
    final snapshot =
        await Provider.of<TestControllers>(context, listen: false).list.first;
    final length = snapshot.docs.length;

    if (currentIndex < length - 1) {
      await controller.forward();
      updateIndex(currentIndex + 1);
      await controller.reverse();
    } else {
      updateIndex(currentIndex + 1);
    }
  }

  static void restartTest(Function(int, int, int) resetState) {
    resetState(0, 0, 0);
  }

  static void showErrorDialog1(BuildContext context, String s) {}





    static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Xatolik"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
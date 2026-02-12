import 'package:rive/rive.dart';

class RiveUtils {
  static StateMachineController? getRiveController(
    Artboard artboard, {
    required String stateMachineName,
  }) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      stateMachineName,
    );

    if (controller == null) {
      print('❌ State Machine "$stateMachineName" not found');
      return null;
    }

    artboard.addController(controller);
    return controller;
  }

  static SMIBool? getRiveInput(
    Artboard artboard, {
    required String stateMachineName,
  }) {
    StateMachineController? controller = StateMachineController.fromArtboard(
      artboard,
      stateMachineName,
    );

    if (controller == null) {
      print('❌ State Machine "$stateMachineName" not found');
      return null;
    }

    artboard.addController(controller);

    SMIBool? input = controller.findInput<bool>("active") as SMIBool?;

    if (input == null) {
      print('❌ Input "active" not found in State Machine');
    }

    return input;
  }

  static void chnageSMIBoolState(SMIBool input) {
    input.change(true);
    Future.delayed(const Duration(seconds: 1), () {
      input.change(false);
    });
  }
}

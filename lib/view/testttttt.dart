import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class testt extends StatefulWidget {
  const testt({super.key});

  @override
  State<testt> createState() => _testtState();
}

class _testtState extends State<testt> {
  late final SMITrigger _confettiAnim;

  void _onConfettiRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    _confettiAnim = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Wrap with Center widget
        child: GestureDetector( // Add GestureDetector to trigger animation
          onTap: () => _confettiAnim.fire(), // Fire the animation on tap
          child: SizedBox(
            width: 500,
            height: 500,
            child: Transform.scale(
              scale: 3,
              child: RiveAnimation.asset(
                "assets/svg/confetti.riv",
                onInit: _onConfettiRiveInit,
                fit: BoxFit.contain, // Add fit property
              ),
            ),
          ),
        ),
      ),
    );
  }
}
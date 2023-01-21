import 'dart:math';

import 'package:animation/src/screens/widgets/cat.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double>? catAnimation;
  AnimationController? catController;
  Animation<double>? boxAnimation;
  AnimationController? boxController;

  @override
  void initState() {
    super.initState();
    boxController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
      CurvedAnimation(parent: boxController!, curve: Curves.easeInOut),
    );
    boxAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController!.forward();
      }
    });
    boxController!.forward();

    catController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    catAnimation = Tween(begin: -50.0, end: -83.0).animate(
      CurvedAnimation(parent: catController!, curve: Curves.easeIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animation'),
      ),
      body: GestureDetector(
          onTap: onPressed,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                buildAnimation(),
                buildBox(),
                buildLeftFlap(),
                buildRightFlap(),
              ],
            ),
          )),
    );
  }

  onPressed() {

    if (catController!.isCompleted) {
      boxController!.forward();
      catController!.reverse();
    } else if (catController!.isDismissed) {
      boxController!.stop();
      catController!.forward();
    }
  }

  Widget buildAnimation() {
    return AnimatedBuilder(
      animation: catAnimation!,
      builder: (context, child) {
        return Positioned(
          right: 0.0,
          left: 0.0,
          top: catAnimation!.value,
          child: const Cat(),
        );
      },
    );
  }

  Widget buildBox() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation!,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: boxAnimation!.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation!,
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
        builder: (BuildContext context, Widget? child) {
          return Transform.rotate(
            angle: -boxAnimation!.value,
            alignment: Alignment.topRight,
            child: child,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      // color: Colors.red,
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _BlueBox(),
          const _HeaderIcon(),
          child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(
          top: 30,
        ),
        width: double.infinity,
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}

class _BlueBox extends StatelessWidget {
  const _BlueBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _blueBackground(),
      child: Stack(
        children: const [
          Positioned(child: _Bubble()),
          Positioned(
            child: _Bubble(),
            top: -40,
            left: 30,
          ),
          Positioned(
            child: _Bubble(),
            left: -20,
            top: 235,
          ),
          Positioned(
            child: _Bubble(),
            right: 20,
            top: -10,
          ),
          Positioned(
            child: _Bubble(),
            right: 80,
            bottom: -40,
          ),
          Positioned(
            child: _Bubble(),
            left: 10,
            top: 100,
          ),
          Positioned(
            child: _Bubble(),
            right: -20,
            bottom: 40,
          ),
        ],
      ),
    );
  }

  BoxDecoration _blueBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(0, 80, 206, 1),
          Color.fromRGBO(30, 118, 255, 1),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}

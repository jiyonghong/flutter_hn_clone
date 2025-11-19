import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double translateY;

  const LoadingWidget({super.key, this.translateY = -50});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: Offset(0, translateY),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

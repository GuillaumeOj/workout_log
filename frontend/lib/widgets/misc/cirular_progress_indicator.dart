import "package:flutter/material.dart";

class SizedCircularProgressIndicator extends StatelessWidget {
  const SizedCircularProgressIndicator({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

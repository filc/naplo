import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

abstract class BaseCard extends StatelessWidget {
  final DateTime compare;

  BaseCard({required this.compare});
}

class BaseCardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color color;
  final bool gradient;

  BaseCardWidget({
    required this.child,
    this.padding,
    this.color = Colors.transparent,
    this.gradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 6.0, right: 6.0),
      decoration: BoxDecoration(
        color: color,
        gradient: gradient
            ? LinearGradient(
                colors: [color, TinyColor(color).spin(20).darken(10).color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}

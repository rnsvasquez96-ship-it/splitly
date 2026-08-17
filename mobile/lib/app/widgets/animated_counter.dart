import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimatedCounter extends StatelessWidget {
  final double value;
  final String prefix;
  final int duration;
  final int decimals;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix = "",
    this.duration = 1200,
    this.decimals = 0,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: "en_PH",
      symbol: "",
      decimalDigits: decimals,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 0,
        end: value,
      ),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeOutCubic,
      builder: (_, animatedValue, _) {
        return Text(
          "$prefix${formatter.format(animatedValue)}",
          style: style ??
              const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
              ),
        );
      },
    );
  }
}
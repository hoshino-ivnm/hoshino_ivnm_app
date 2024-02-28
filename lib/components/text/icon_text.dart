import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String text;
  final TextStyle textStyle;
  final double interval;

  const IconText(
      {super.key,
      required this.icon,
      this.iconSize = 12,
      this.iconColor = Colors.black45,
      required this.text,
      this.interval = 1,
      this.textStyle = const TextStyle(color: Colors.black45, fontSize: 12)});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(width: interval), // 添加一些间距
        Expanded(
          child: Text(
            text,
            style: textStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

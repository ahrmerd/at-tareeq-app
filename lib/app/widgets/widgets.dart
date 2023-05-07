import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class HorizontalSpace extends StatelessWidget {
  final double width;
  const HorizontalSpace([this.width = 10, Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
    );
  }
}

class VerticalSpace extends StatelessWidget {
  final double height;
  const VerticalSpace([this.height = 10, Key? key]) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class MyButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final bool danger;
  final Color? color;
  final Color? bgColor;
  final EdgeInsets? padding;
  final bool maxWidth;
  final bool filled;
  const MyButton({
    Key? key,
    this.color,
    this.onTap,
    this.bgColor,
    required this.child,
    this.padding,
    this.danger = false,
    this.maxWidth = false,
    this.filled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: maxWidth ? double.maxFinite : null,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
        decoration: BoxDecoration(
          color: bgColor ?? (filled ? primaryColor : null),
          border: Border.all(
            color: danger
                ? Colors.red
                : color != null
                    ? color!
                    : primaryColor,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: DefaultTextStyle.merge(
          textAlign: TextAlign.center,
          child: child,
          style: danger
              ? buttonTextStyleWithColor(Colors.red)
              : buttonTextStyleWithColor(filled ? lightColor : null),
        ),
      ),
    );
  }
}

class TitleValue extends StatelessWidget {
  final String title;
  final String value;
  const TitleValue({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          "$title:",
          style: boldTextStyle,
        ),
        const HorizontalSpace(),
        Text(
          value,
          // style: semiBoldTextStyle,
        )
      ],
    );
  }
}

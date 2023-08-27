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
    // required Null Function() onPressed,
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

class BigText extends StatelessWidget {
  const BigText(
    this.text, {
    Key? key,
    this.fontSize = 24,
    this.color = CustomColor.appBlue,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
  }) : super(key: key);
  final int? maxLines;
  final String text;
  final double fontSize;
  final Color? color;
  final TextOverflow? overflow;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: 'Brand Bold',
        fontSize: fontSize,
        letterSpacing: 1,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}

class SmallText extends StatelessWidget {
  const SmallText(
    this.text, {
    Key? key,
    this.fontSize = 16,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.softWrap
  }) : super(key: key);

  final String text;
  final double fontSize;
  final Color? color;
  final TextAlign textAlign;
  final int? maxLines;
  final bool? softWrap;

  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      style: TextStyle(
        fontFamily: 'Brand-Regular',
        fontSize: fontSize,
        letterSpacing: 1,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    Key? key,
    required this.text,
    this.icon = Icons.arrow_forward,
    required this.onPressed,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 42),
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: CustomColor.appBlue,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        onPressed: onPressed,
        icon: Icon(icon),
        label: Align(alignment: alignment, child: Text(text)));
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.black,
    this.fontSize = 16,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          textStyle: TextStyle(fontSize: fontSize),
          foregroundColor: color,
        ),
        onPressed: onPressed,
        child: Text(text));
  }
}

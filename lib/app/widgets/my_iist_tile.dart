import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final Icon icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  icon,
                  // Icon(icon, color: Colors.black,),
                  const SizedBox(width: 8,),
                  SmallText(text)
                ],
              ),
              const Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,),
            ],
          ),
        ),
      ),
    );
  }
}
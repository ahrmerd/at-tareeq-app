import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextInput extends StatelessWidget {
  const MyTextInput(
      {super.key,
      required this.controller,
      required this.hintText,
      this.icon,
      this.obscureText = false});
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Container();
    // return Container(
    //   margin: const EdgeInsets.only(bottom: 9),
    //   width: double.infinity,
    //   height: 60,
    //   child: Stack(clipBehavior: Clip.none, children: [
    //     Positioned(
    //       top: 0,
    //       left: 0,
    //       child: Container(
    //         width: Get.width - 30,
    //         padding: const EdgeInsets.only(left: 5),
    //         decoration: BoxDecoration(
    //             border: Border.all(
    //               width: .8,
    //               color: Colors.grey,
    //             ),
    //             borderRadius: BorderRadius.circular(20)),
    //         child: TextField(
    //           obscureText: obscureText,
    //           controller: controller,
    //           decoration: InputDecoration(
    //             icon: icon,
    //             border: const UnderlineInputBorder(borderSide: BorderSide.none),
    //             // border: InputBorder.none,
    //             hintText: hintText,
    //             // label: Text(hintText),
    //           ),
    //         ),
    //       ),
    //     ),
    //     Positioned(
    //         top: -13,
    //         left: 50,
    //         child: Container(
    //           padding: const EdgeInsets.all(5),
    //           color: Colors.white,
    //           child: Text(hintText),
    //         ))
    //   ]),
    // );
  }

  SizedBox newwMethod() {
    return SizedBox(
      width: Get.width - 30,
      height: 60,
      child: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            // width: size.width - 30,
            padding: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
                border: Border.all(
                  width: .8,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(20)),
            child: TextField(
              obscureText: obscureText,
              controller: controller,
              decoration: InputDecoration(
                  icon: icon,
                  border:
                      const UnderlineInputBorder(borderSide: BorderSide.none),
                  // border: InputBorder.none,
                  hintText: hintText,
                  label: Text(hintText)),
            ),
          ),
        ),
        Positioned(
            top: -13,
            left: 50,
            child: Container(
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              child: Text(hintText),
            ))
      ]),
    );
  }

  Padding old() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
                icon: icon,
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                // border: InputBorder.none,
                hintText: hintText,
                label: Text(hintText)),
          ),
        ),
      ),
    );
  }
}

Container formWidget(
    Size size, String label, String hintText, String validator) {
  return Container(
    margin: const EdgeInsets.only(bottom: 9),
    width: size.width - 30,
    height: 60,
    child: Stack(clipBehavior: Clip.none, children: [
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: size.width - 30,
          padding: const EdgeInsets.only(left: 5),
          decoration: BoxDecoration(
              border: Border.all(
                width: .8,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(20)),
          child: TextFormField(
            validator: (value) => value!.isEmpty ? validator : null,
            decoration: InputDecoration(
              icon: const Icon(Icons.person),
              border: const UnderlineInputBorder(borderSide: BorderSide.none),
              hintText: hintText,
            ),
          ),
        ),
      ),
      Positioned(
          top: -13,
          left: 50,
          child: Container(
            padding: const EdgeInsets.all(5),
            color: Colors.white,
            child: Text(label),
          ))
    ]),
  );
}

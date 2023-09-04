import 'package:at_tareeq/app/data/enums/user_type.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/extentions/string_extensions.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectUserType extends StatelessWidget {
  const SelectUserType({super.key});

  final String imageAsset = 'assets/images/Asset4.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imageAsset),
                  // Container(
                  //   alignment: Alignment.center,
                  //   // padding: EdgeInsets.all(10),
                  //   width: 300,
                  //   height: 300,
                  // ),
                  const VerticalSpace(84),
                  const BigText('Who are you?'),
                  const VerticalSpace(),
                  ...List.generate(
                      FormUserType.values.length,
                      ((index) => Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: CustomIconButton(
                                text: FormUserType.values[index].name
                                    .toCapitalize,
                                onPressed: () {
                                  onSelect(FormUserType.values[index]);
                                }),
                          ))),
                  const VerticalSpace(),
                  // ...List.generate(
                  //     FormUserType.values.length,
                  //     ((index) => GestureDetector(
                  //           onTap: () {
                  //             onSelect(FormUserType.values[index]);
                  //           },
                  //           child: Container(
                  //             margin: const EdgeInsets.only(top: 14),
                  //             padding: const EdgeInsets.all(10),
                  //             decoration: BoxDecoration(
                  //                 color: primaryColor,
                  //                 borderRadius: BorderRadius.circular(9)),
                  //             child: Row(
                  //               children: [
                  //                 const Icon(
                  //                   Icons.arrow_forward,
                  //                   color: Colors.white,
                  //                 ),
                  //                 const HorizontalSpace(),
                  //                 Text(
                  //                   FormUserType.values[index].name
                  //                       .toCapitalize(),
                  //                   style: const TextStyle(
                  //                       color: Colors.white, fontSize: 18),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ))),
                ]),
          ),
        ),
      ),
    );
  }

  void onSelect(FormUserType userType) {
    Get.toNamed(Routes.REGISTER, arguments: {'userType': userType});
  }
}

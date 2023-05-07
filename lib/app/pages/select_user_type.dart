import 'package:at_tareeq/app/data/enums/user_type.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/extentions/string_extensions.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.all(10),
                width: 300,
                height: 300,
                child: Image.asset(imageAsset),
              ),
              Column(children: [
                Container(
                  // padding: const EdgeInsets.all(20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Who Are You ?",
                    style: biggerTextStyle,
                  ),
                ),
                VerticalSpace(),
                ...List.generate(
                    FormUserType.values.length,
                    ((index) => GestureDetector(
                          onTap: () {
                            onSelect(FormUserType.values[index]);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 14),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(9)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                                HorizontalSpace(),
                                Text(
                                  FormUserType.values[index].name
                                      .toCapitalize(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void onSelect(FormUserType userType) {
    Get.toNamed(Routes.REGISTER, arguments: {'userType': userType});
  }
}

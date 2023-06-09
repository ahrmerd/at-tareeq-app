import 'package:at_tareeq/app/controllers/register_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/widgets/my_text_input.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/screens/success_screen.dart';
import 'package:at_tareeq/app/widgets/social_media_signup.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/decorations.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';

import '../data/models/form_item.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Get.offAllNamed(Routes.LOGIN);
            },
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Obx(() {
            switch (controller.status) {
              case ProcessingStatus.initial:
                return RegisterForm(controller: controller);
              case ProcessingStatus.success:
                return const SuccessScreen();
              case ProcessingStatus.error:
                return ErrorScreen(onReturn: controller.restart);
              case ProcessingStatus.loading:
                return const LoadingScreen();
            }
          }),
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.controller,
  });

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Create Account',
            style: biggestTextStyle,
          ),
          const VerticalSpace(),
          Text(
            'Create a new account',
            style: bigTextStyle,
          ),
          FormBuilder(
            key: controller.formKey,
            child: Obx(() {
              return Column(
                children: [
                  ...List.generate(controller.formItems.length, (index) {
                    final item = controller.formItems[index];
                    return Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: item.type == TextInputType.phone
                            ? FormBuilderPhoneField(
                                name: item.field,
                                decoration: myInputDecoration(
                                    label: item.label, icon: item.icon),
                                priorityListByIsoCode: const ['NG'],
                                defaultSelectedCountryIsoCode: 'NG',
                                validator: item.validator,
                              )
                            : FormBuilderTextField(
                                controller: item.controller,
                                name: item.field,
                                keyboardType: item.type,
                                obscureText:
                                    item.type == TextInputType.visiblePassword,
                                decoration: myInputDecoration(
                                    label: item.label, icon: item.icon),
                                validator: item.validator,
                              ));
                  }),
                  VerticalSpace(20),
                  if (controller.states.length > 1)
                    FormBuilderDropdown(
                        decoration: myInputDecoration(label: 'Location'),
                        name: 'location',
                        items: controller.states
                            .map((element) => DropdownMenuItem(
                                value: element['name'],
                                child: Text(element['name'])))
                            .toList()),
                  VerticalSpace(20),
                  GestureDetector(
                    onTap: () {
                      // Get.toNamed(Routes.LOGIN);
                      // controller.register();
                      controller.onRegisterButtonClick();
                    },
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(9)),
                        child: const Text(
                          "Create Account",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ),
                  VerticalSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have an Account"),
                      const HorizontalSpace(),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.LOGIN);
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  VerticalSpace(25),
                  SocialMediaSignup(
                    onFacebookSignup: () {},
                    onGoogleSignup: () {},
                  )
                ],
              );
            }),
          ),
          // MyTextInput(
          // controller: controller.nameController, hintText: 'Full Name')
        ]);
  }
}

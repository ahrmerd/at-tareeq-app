import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/form_item.dart';
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

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              Get.offAllNamed(Routes.REGISTER);
            },
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Obx(() {
            switch (controller.status) {
              case ProcessingStatus.initial:
                return LoginForm(controller: controller);
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

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.controller,
  });
  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Welcome User',
            style: biggestTextStyle,
          ),
          VerticalSpace(20),
          Text(
            'Login to Continue',
            style: bigTextStyle,
          ),
          VerticalSpace(),

          FormBuilder(
            key: controller.formKey,
            child: Column(
              children: [
                ...List.generate(controller.formItems.length, (index) {
                  final item = controller.formItems[index];
                  return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: FormBuilderTextField(
                        controller: item.controller,
                        name: item.field,
                        keyboardType: item.type,
                        obscureText: item.type == TextInputType.visiblePassword,
                        decoration: myInputDecoration(
                            label: item.label, icon: item.icon),
                        validator: item.validator,
                      ));
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyButton(
                      color: Colors.grey,
                      child: Text('Forgot Password'),
                    ),

                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Text('Register'),
                    // ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: MyButton(
                    bgColor: primaryColor,
                    onTap: () {
                      controller.onLoginWithEmailButtonClick();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Dont Have an Account"),
                    HorizontalSpace(),
                    MyButton(
                      onTap: controller.onRegisterButtonClick,
                      color: Colors.grey,
                      child: Text('Register'),
                    ),
                  ],
                ),
                VerticalSpace(20),
                SocialMediaSignup(
                  onFacebookSignup: () {},
                  onGoogleSignup: () {},
                )
              ],
            ),
          ),
          // MyTextInput(
          // controller: controller.nameController, hintText: 'Full Name')
        ]);
  }
}

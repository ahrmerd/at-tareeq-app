import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/form_item.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/services/auth_service.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // late final TextEditingController _emailController;
  // late final TextEditingController _passwordController;
  final formKey = GlobalKey<FormBuilderState>();

  final AuthService _authService = Dependancies.authService();

  // TextEditingController get passwordController => _passwordController;
  // TextEditingController get emailController => _emailController;
  final _status = ProcessingStatus.initial.obs;
  ProcessingStatus get status => _status.value;

  List<FormItem> formItems = [
    FormItem('email',
        type: TextInputType.emailAddress,
        icon: const Icon(Icons.email_outlined),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.email(),
        ])),
    FormItem('password',
        icon: const Icon(Icons.lock_outline),
        type: TextInputType.visiblePassword,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ])),
  ];

  @override
  void onInit() {
    // _emailController = TextEditingController();
    // _passwordController = TextEditingController();
    super.onInit();
  }

  @override
  onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }

  onRegisterButtonClick() async {
    _status.value = ProcessingStatus.loading;
    Get.offAllNamed(Routes.REGISTER);
  }

  onLoginWithEmailButtonClick() async {
    if (!formKey.currentState!.validate()) {
      Get.snackbar("Error", "please recheak the fields",
          colorText: Colors.white, backgroundColor: Colors.red);
      return;
    }
    _status.value = ProcessingStatus.loading;
    try {
      await login();
      _status.value = ProcessingStatus.success;
    } on DioError catch (e) {
      print(e.response);
      // rethrow;
      _status.value = ProcessingStatus.error;
      final errorMessage = ApiClient.processError(e);
      Get.defaultDialog(title: "Error", middleText: errorMessage, actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Close"),
        ),
      ]);
    } catch (e) {
      print(e);
      // rethrow;
      _status.value = ProcessingStatus.error;
      Get.defaultDialog(
          title: "Error",
          middleText: "an error occured",
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Close"),
            ),
          ]);
    }
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      final data = {
        for (var e in formItems)
          e.field: formKey.currentState?.fields[e.field]?.value
      };
      data['device_name'] = await getDeviceName();

      // print(data);

      await _authService.loginFromData(data);
    }
    // restart();
  }

  void restart() {
    _status.value = ProcessingStatus.initial;
    // _emailController.clear();
    // _passwordController.clear();
  }
}

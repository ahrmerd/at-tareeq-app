import 'dart:convert';

import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/enums/user_type.dart';
import 'package:at_tareeq/app/data/models/form_item.dart';
import 'package:at_tareeq/app/data/models/user_type.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/services/auth_service.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Dependancies.authService();
  final formKey = GlobalKey<FormBuilderState>();
  final _passwordController = TextEditingController();

  bool isHost = tryMapCast(
          key: 'userType',
          map: Get.arguments,
          fallback: FormUserType.listener) ==
      FormUserType.host;

  List<FormItem> formItems = [];

  RxList states = [].obs;
  List<FormItem> getFormItems() {
    return [
      FormItem('name',
          label: 'full name',
          icon: const Icon(Icons.person_outline),
          type: TextInputType.name,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
          ])),
      FormItem('email',
          icon: const Icon(Icons.email_outlined),
          type: TextInputType.emailAddress,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ])),
      if (isHost)
        FormItem('organization',
            label: 'Mosque/Organization/Lecturer',
            icon: const Icon(Icons.people_outline),
            validator: FormBuilderValidators.compose([
              if (isHost) FormBuilderValidators.required(),
            ])),
      FormItem('phone',
          icon: const Icon(Icons.phone_outlined),
          type: TextInputType.phone,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ])),
      FormItem('password',
          icon: const Icon(Icons.lock_outline),
          type: TextInputType.visiblePassword,
          controller: _passwordController,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
          ])),
      FormItem('password_confirmation',
          label: 'confirm password',
          icon: const Icon(Icons.lock_outline),
          type: TextInputType.visiblePassword,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
            (val) {
              print(val);
              print(_passwordController.text);
              if (val != _passwordController.text) {
                return 'The Password and Password Confirmation must match';
              }
              return null;
            }
          ]))
    ];
  }

  RxBool validated = false.obs;

  final _status = ProcessingStatus.initial.obs;
  ProcessingStatus get status => _status.value;

  @override
  void onInit() {
    formItems = getFormItems();
    loadStates();
    super.onInit();
  }

  @override
  onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }

  onLoginButtonClick() async {
    _status.value = ProcessingStatus.loading;
    Get.offAllNamed(Routes.LOGIN);
  }

  Future onRegisterButtonClick() async {
    if (!validateData()) {
      Get.snackbar("Error", "the form is not completed",
          colorText: Colors.white, backgroundColor: Colors.red);
      return;
    }
    _status.value = ProcessingStatus.loading;
    try {
      await register();
      _status.value = ProcessingStatus.success;
    } on DioError catch (e) {
      _status.value = ProcessingStatus.error;
      ApiClient.showErrorDialogue(e);
    } catch (e) {
      print(e);
      _status.value = ProcessingStatus.error;
      showErrorDialogue();
    }
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      final data = {
        for (var e in formItems)
          e.field: formKey.currentState?.fields[e.field]?.value
      };

      data['type'] = isHost ? ServerUserTypes.host : ServerUserTypes.listener;
      data['location'] = formKey.currentState?.fields['location']?.value;
      data['device_name'] = await getDeviceName();
      print(data);
      await _authService.registerFromData(data: data);
      // ApiClient.getInstance().req.post('');
      // print(data);
    } else {
      // throw Exception();
    }
    restart();
  }

  void restart() {
    _status.value = ProcessingStatus.initial;
  }

  bool validateData() {
    return formKey.currentState!.validate();
  }

  Future loadStates() async {
    String data = await rootBundle.loadString('assets/json/states.json');
    states.addAll(json.decode(data) as List);
  }
}

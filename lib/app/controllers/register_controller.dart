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
import 'package:at_tareeq/core/utils/logger.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Dependancies.authService();
  final formKey = GlobalKey<FormBuilderState>();
  // final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _orgController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  var _selectedState = '';
  String get  selectedState => _selectedState;


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
          controller: _nameController,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(4),
          ])),
      FormItem('email',
          icon: const Icon(Icons.email_outlined),
          type: TextInputType.emailAddress,
          controller: _emailController,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ])),
      if (isHost)
        FormItem('organization',
            label: 'Mosque/Organization/Lecturer',
            icon: const Icon(Icons.people_outline),
            controller: _orgController,
            validator: FormBuilderValidators.compose([
              if (isHost) FormBuilderValidators.required(),
            ])),
      FormItem('phone',
          icon: const Icon(Icons.phone_outlined),
          type: TextInputType.phone,
          controller: _phoneController,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
          ])),
      FormItem('password',
          icon: const Icon(Icons.lock_outline),
          type: TextInputType.visiblePassword,
          // controller: _passwordController,
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
              // print(val);
              // print(_passwordController.text);
              if (val != formKey.currentState?.fields['password']?.value) {
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
    getApplicationDocumentsDirectory().then((value) => print(value));

    super.onInit();
  }

  @override
  onClose() {
    // _emailController.dispose();
    // _nameController.dispose();
    // _passwordController.dispose();
    // _phoneController.dispose();
    super.onClose();
  }

  onLoginButtonClick() async {
    _status.value = ProcessingStatus.loading;
    Get.offAllNamed(Routes.LOGIN);
  }

  Future onRegisterButtonClick() async {
    // formKey.currentState?.save();
    // print(formKey.currentState?.value.toString());
    // print(formKey.currentState?.fields.map((key, value) => value.value));
    // return;
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
      // print(e);
      _status.value = ProcessingStatus.error;
      ApiClient.showErrorDialogue(e);
      Logger.log(e.toString());
    } catch (e) {
      Logger.log(e.toString());
      _status.value = ProcessingStatus.error;
      showErrorDialogue(e.toString());
    }
  }

  Future<void> register() async {
    if (formKey.currentState!.saveAndValidate()) {
      final data = {
        for (var e in formItems)
          e.field: formKey.currentState?.fields[e.field]?.value
      };

      data['type'] = isHost ? ServerUserTypes.host : ServerUserTypes.listener;
      data['location'] = formKey.currentState?.fields['location']?.value;
      data['device_name'] = await getDeviceName();
      print(data);
      await _authService.registerFromData(data: data);
    } else {
      // throw Exception();
    }
    restart();
  }

  void restart() {
    _status.value = ProcessingStatus.initial;
  }

  bool validateData() {
    return formKey.currentState!.saveAndValidate();
  }

  Future loadStates() async {
    String data = await rootBundle.loadString('assets/json/states.json');
    states.addAll(json.decode(data) as List);
  }

  

  changeSelectedState(String? state) {
    _selectedState=state??'';
  }
}

List<String> getFromAutoFillHints(String field) {
    // return [AutofillHints.birthdayDay];
    switch (field) {
      case 'name':
        return [AutofillHints.name, AutofillHints.givenName];
      case 'email':
        return [AutofillHints.email];
      case 'password':
        return [AutofillHints.password];
      case 'password_confirmation':
        return [AutofillHints.password];
      case 'organization':
        return [AutofillHints.organizationName];
      case 'phone':
        return [AutofillHints.telephoneNumber];
      default:
        return [];
    }
  }
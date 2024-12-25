import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/utils/app_text_style.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import '../controllers/auth_controller.dart';

class PatientSignUpView extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

  PatientSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText('SignUp'.tr, fontSize: 20, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              
                CustomTextField(
                  hintText: 'FirstName'.tr,
                  controller: authController.firstNameController,
                  prefixIcon: Icons.person,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'LastName'.tr,
                  controller: authController.lastNameController,
                  prefixIcon: Icons.person_outline,
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Email'.tr,
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Password'.tr,
                  controller: authController.passwordController,
                  obscureText: true,
                  prefixIcon: Icons.lock,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'PhoneNumber'.tr,
                  controller: authController.phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Age'.tr,
                  controller: authController.ageController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.calendar_today,
                ),
                CustomText('Gender'.tr, fontSize: 16, fontWeight: FontWeight.bold),
                Row(
                  children: [
                    Obx(() => Radio(
                          value: 'Male',
                          groupValue: authController.gender.value,
                          onChanged: (value) => authController.gender.value = value.toString(),
                        )),
                    CustomText('Male'.tr),
                    Obx(() => Radio(
                          value: 'Female',
                          groupValue: authController.gender.value,
                          onChanged: (value) => authController.gender.value = value.toString(),
                        )),
                    CustomText('Female'.tr),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'SignUp'.tr,
                  color: AppColors.primary,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authController.signUp();
                    }
                  },
                ),
                20.height,
                  Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text('AlreadyHaveAccount'.tr),
                      TextButton(
                        onPressed: controller.toggleView,
                        child:  CustomText(
                          'SignIn'.tr,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

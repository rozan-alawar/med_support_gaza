import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import '../controllers/auth_controller.dart';

class PatientLoginView extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText('Login'.tr, fontSize: 20, fontWeight: FontWeight.bold),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                  
                      print('Forgot Password');
                    },
                    child: CustomText(
                      'ForgotPassword'.tr,
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              
                CustomButton(
                  text: 'Login'.tr,
                  color: AppColors.primary,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                    
                      print('User Logged In');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

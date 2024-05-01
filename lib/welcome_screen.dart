import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:password_app/const/app_string.dart';
import 'package:password_app/controller/auth_controller.dart';
import 'package:password_app/widgets/text_form_field.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF380835),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 200.h,
              width: double.infinity,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.r),
                      topLeft: Radius.circular(30.r)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        AppString.welcome,
                        style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        AppString.pleaseLoginToContinue,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black26),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Text(
                        AppString.enterPassword,
                        style: TextStyle(
                            fontSize: 29.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),

                      /// Password TextFormField
                      Obx(
                        () => CustomTextFormField(
                          prefixIcon: Icon(
                            Icons.lock_outlined,
                            color: Colors.black26,
                            size: 20.r,
                          ),
                          obscureText: controller.passwordVisible.value,
                          controller: controller.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            color: Colors.grey,
                            icon: Icon(controller.passwordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              controller.togglePassword();
                            },
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter Password';
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(
                        height: 100.h,
                      ),

                      ///Login Button
                      _buildLoginButton(),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///Login Button
  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: () async {
        final dateTime = DateTime.now();
        print(DateFormat("EEEE").format(dateTime));
        print("nnnnnnnnnnnnnnnnnnnn");
        print(controller.dateController.text);
        if (_formKey.currentState!.validate()) {
          controller.login(context);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
            color: const Color(0xFF380835),
            borderRadius: BorderRadius.circular(10.r)),
        child: Center(
          child: Text(
            AppString.login,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}

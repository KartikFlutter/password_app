import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:password_app/const/app_string.dart';
import 'package:password_app/controller/auth_controller.dart';
import 'package:password_app/model/home_model/home_model.dart';
import 'package:password_app/password_screen.dart';
import 'package:password_app/utils/hive_helper.dart';
import 'package:password_app/widgets/text_form_field.dart';

import 'controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());
  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    getBox();
    // controller.deleteDateAfterFiveDays();
    super.initState();
  }

  getBox() async {}

  /// Date Picker
  Future<DateTime> datePicker(
      BuildContext context, DateTime firstDate, lastDate,
      {DateTime? selectedDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      keyboardType: TextInputType.datetime,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, Widget? child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF380835),
            ),
          ),
          child: child!,
        );
      },
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );
    return pickedDate!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Text(
          AppString.dataList,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        actions: [
          // TextButton(
          //     onPressed: () {
          //       _showPrizeFactorDialog(context);
          //     },
          //     child: Text("Set Prize Factor")),

          /// Add Date Button
          _buildAddDateButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),

              ///Game Date List
              _buildGameDateList(),
              SizedBox(
                height: 20.h,
              ),

              SizedBox(
                height: 20.h,
              ),

              ///Set Limit Button
              // _buildSetLimitButton()
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showSetLimitDialog(context);
      //   },
      //   backgroundColor: const Color(0xFF380835),
      //   child: _buildSetLimitButton(),
      // ),
      // bottomSheet: ElevatedButton(
      //     onPressed: () {
      //       _showPrizeFactorDialog(context);
      //     },
      //     child: Text("Set Prize Factor")),
    );
  }

  /// Password Date List
  Widget _buildGameDateList() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<HomeModel>("dates").listenable(),
      builder: (context, value, child) {
        if (value.values.isEmpty) {
          return const Center(
            child: Text('Database Is Empty'),
          );
        } else {
          final data = value.values.toList();
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            reverse: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              var model = data[index];
              return InkWell(
                onLongPress: () {
                  authController.dateListScreenPasswordController.clear();
                  _buildDeleteAlertBox(
                      context,
                      HomeModel(
                        date: model.date,
                        password: [],
                      ));
                },
                onTap: () async {
                  // await HiveHelper.deleteDate(
                  //     DateModel(date: model.date, games: model.games));
                  Get.to(() => PasswordScreen(
                        dateName: model.date,
                      ));
                },
                child: Column(
                  children: [
                    Card(
                      elevation: 10,
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.date,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Text(
                                  AppString.totalPasswords,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Text(
                                  model.password.length.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  /// Add Date Button
  Widget _buildAddDateButton() {
    return GestureDetector(
      onTap: () {
        _buildAddDateAlertBox(context);
        controller.dateController.clear();
      },
      child: Container(
        margin: EdgeInsets.only(right: 15.w, left: 10.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xFF380835)),
        padding: EdgeInsets.all(8.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppString.addDate,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  /// Set Limit Button
  // Widget _buildSetLimitButton() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Icon(
  //         Icons.currency_exchange,
  //         color: Colors.white,
  //         size: 15.r,
  //       ),
  //       SizedBox(
  //         height: 5.h,
  //       ),
  //       Text(
  //         AppString.setLimit,
  //         style: TextStyle(
  //             fontWeight: FontWeight.w500, fontSize: 8.sp, color: Colors.white),
  //       )
  //     ],
  //   );
  // }

  ///set Limit Alert Box
  // Future<void> _showSetLimitDialog(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           AppString.setLimitAmount,
  //           style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
  //         ),
  //         content: _buildTextFormField(),
  //         actions: <Widget>[
  //           GestureDetector(
  //             onTap: () {
  //               if (_formKey.currentState?.validate() ?? false) {
  //                 controller.onLimitSaved();
  //               }
  //             },
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10.r),
  //                   color: const Color(0xFF380835)),
  //               child: Center(
  //                   child: Text(
  //                 AppString.save,
  //                 style: TextStyle(
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 14.sp,
  //                     color: Colors.white),
  //               )),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  /// prize factor Alert Box
  // Future<void> _showPrizeFactorDialog(BuildContext context) {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           "Prize Factor",
  //           style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
  //         ),
  //         content: Form(
  //           key: _prizeFactorFormKey,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 AppString.inOut,
  //                 style:
  //                     TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
  //               ),
  //               TextFormField(
  //                 keyboardType: TextInputType.number,
  //                 controller: controller.inOutPrizeET,
  //                 decoration: InputDecoration(
  //                   hintText: "In / Out Factor",
  //                   hintStyle: TextStyle(
  //                       color: Colors.black12,
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 14.sp),
  //                   contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
  //                   fillColor: Colors.grey.shade200,
  //                   filled: true,
  //                   border: OutlineInputBorder(
  //                     borderSide: const BorderSide(
  //                       color: Colors.white,
  //                     ),
  //                     borderRadius: BorderRadius.circular(10.r),
  //                   ),
  //                 ),
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return "Please enter a valid number";
  //                   }
  //
  //                   return null;
  //                 },
  //               ),
  //               SizedBox(
  //                 height: 20.h,
  //               ),
  //               Text(
  //                 AppString.doublingMulti,
  //                 style:
  //                     TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
  //               ),
  //               TextFormField(
  //                 keyboardType: TextInputType.number,
  //                 controller: controller.doublePrizeET,
  //                 decoration: InputDecoration(
  //                   hintText: "Doubling Factor",
  //                   hintStyle: TextStyle(
  //                       color: Colors.black12,
  //                       fontWeight: FontWeight.w400,
  //                       fontSize: 14.sp),
  //                   contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
  //                   fillColor: Colors.grey.shade200,
  //                   filled: true,
  //                   border: OutlineInputBorder(
  //                     borderSide: const BorderSide(
  //                       color: Colors.white,
  //                     ),
  //                     borderRadius: BorderRadius.circular(10.r),
  //                   ),
  //                 ),
  //                 validator: (value) {
  //                   if (value == null || value.isEmpty) {
  //                     return "Please enter a valid number";
  //                   }
  //                   return null;
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           GestureDetector(
  //             onTap: () {
  //               if (_prizeFactorFormKey.currentState?.validate() ?? false) {
  //                 controller.onPrizeFactorSaved();
  //               }
  //             },
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10.r),
  //                   color: const Color(0xFF380835)),
  //               child: Center(
  //                   child: Text(
  //                 AppString.save,
  //                 style: TextStyle(
  //                     fontWeight: FontWeight.w500,
  //                     fontSize: 14.sp,
  //                     color: Colors.white),
  //               )),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  /// Add Date alert box
  Future<void> _buildAddDateAlertBox(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              AppString.addDate,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
            ),
          ),
          content: _buildAddDateTextFormField(),
          actions: <Widget>[
            Obx(
              () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF380835),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      minimumSize: Size(double.infinity, 40.h)),
                  onPressed: controller.addDate.value
                      ? () async {
                          if (controller.dateController.text.isNotEmpty) {
                            await HiveHelper.createHome(HomeModel(
                                date: controller.dateController.text.trim(),
                                password: []));
                            controller.dateController.clear();
                            Get.back();
                          }
                        }
                      : null,
                  child: Text(
                    AppString.addDate,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.white),
                  )),
            ),
          ],
        );
      },
    );
  }

  /// Text Form Field
  Widget _buildTextFormField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: controller.amountLimitController,
        decoration: InputDecoration(
          hintStyle: TextStyle(
              color: Colors.black12,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a valid number";
          }

          return null;
        },
      ),
    );
  }

  /// Add Date TextFormField
  Widget _buildAddDateTextFormField() {
    return TextFormField(
      onTap: () async {
        /// before 30 days
        // final date = await datePicker(context,DateTime.now().subtract(Duration(days: 30)), DateTime(2100));

        /// Now date
        final date = await datePicker(context, DateTime.now(), DateTime(2100));
        controller.dateController.text = DateFormat("dd/MM/yyyy").format(date);
        controller.addDate.value = true;
      },
      readOnly: true,
      controller: controller.dateController,
      decoration: InputDecoration(
        suffixIcon: const Icon(
          Icons.calendar_month,
          color: Color(0xFF380835),
        ),
        hintStyle: TextStyle(
            color: Colors.black12,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
        fillColor: Colors.grey.shade200,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  ///  Delete Alert Box
  Future _buildDeleteAlertBox(context, HomeModel dateModel) {
    // final formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.areYouSureToDeleteTheDate,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),

                  /// Password TextFormField
                  Obx(
                    () => CustomTextFormField(
                      prefixIcon: Icon(
                        Icons.lock_outlined,
                        color: Colors.black26,
                        size: 20.r,
                      ),
                      obscureText: authController.passwordVisible.value,
                      controller:
                          authController.dateListScreenPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        icon: Icon(authController.passwordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          authController.togglePassword();
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
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        authController.dateListScreenPassword(context,
                            HomeModel(date: dateModel.date, password: []));
                        // Get.back();
                        // await HiveHelper.deleteDate(
                        // DateModel(date: dateModel.date, games: []));
                        // Get.back();
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
                          AppString.delete,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:password_app/const/app_string.dart';
import 'package:password_app/controller/home_controller.dart';
import 'package:password_app/controller/password_controller.dart';
import 'package:password_app/model/password_model/password_model.dart';
import 'package:password_app/widgets/text_form_field.dart';

import 'controller/auth_controller.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({
    Key? key,
    required this.dateName,
  }) : super(
          key: key,
        );

  final String dateName;

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final controller = Get.put(PasswordController());
  final homeController = Get.find<HomeController>();
  final authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.getGames(widget.dateName);
    super.initState();
    controller.gameList.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Column(
          children: [
            Text(
              AppString.passwordList,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
            ),
            Text(
              widget.dateName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
          ],
        ),
        actions: [
          /// Add password Button
          _buildAddPasswordButton(),
          SizedBox(
            width: 20.w,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                ///Game Date List
                _buildGameNameList(),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Game name List
  Widget _buildGameNameList() {
    return Obx(
      () => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // reverse: true,
        itemCount: controller.gameList.length,
        itemBuilder: (context, index) {
          var model = controller.gameList[index];
          return InkWell(
            onLongPress: () {
              // controller.deleteNewGame(
              //     date: widget.dateName,
              //     game: GameModel(gameName: model.gameName, teams: []));
              controller.gameListScreenPasswordController.clear();
              _buildDeleteAlertBox(
                  context,
                  PasswordModel(
                    passwordName: model.passwordName,
                  ));
            },
            child: Column(
              children: [
                Card(
                  elevation: 10,
                  surfaceTintColor: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   children: [
                        //     Text(
                        //       AppString.password,
                        //       style: TextStyle(
                        //           color: Colors.green,
                        //           fontSize: 16.sp,
                        //           fontWeight: FontWeight.w600),
                        //     ),
                        //     const Spacer(),
                        //     // Text(
                        //     //   model.teams.length.toString(),
                        //     //   style: TextStyle(
                        //     //       color: Colors.black,
                        //     //       fontSize: 16.sp,
                        //     //       fontWeight: FontWeight.w600),
                        //     // ),
                        //   ],
                        // ),
                        Expanded(
                          child: Text(
                            "${index + 1})  ${model.passwordName.toString()}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
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
      ),
    );
  }

  ///Add Game Button
  Widget _buildAddPasswordButton() {
    return GestureDetector(
      onTap: () {
        controller.addTime.value = false;
        controller.titleEditingController.clear();
        _buildAddGame(context);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xFF380835)),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add,
              size: 15,
              color: Colors.white,
            ),
            Text(
              AppString.addPassword,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  ///Add game alert box
  Future<void> _buildAddGame(
    BuildContext context,
  ) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              AppString.addPassword,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      keyboardType: TextInputType.text,
                      controller: controller.titleEditingController,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          controller.addTime.value = true;
                        } else {
                          controller.addTime.value = false;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
          actions: <Widget>[
            Obx(
              () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF380835),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      minimumSize: Size(double.infinity, 40.h)),
                  onPressed: controller.addTime.value
                      ? () async {
                          if (controller
                              .titleEditingController.text.isNotEmpty) {
                            controller.addNewGame(
                                date: widget.dateName,
                                password: PasswordModel(
                                  passwordName:
                                      controller.titleEditingController.text,
                                ));
                            Get.back();
                          }
                        }
                      : null,
                  child: Text(
                    AppString.addPassword,
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

  ///  Delete Alert Box
  Future _buildDeleteAlertBox(context, PasswordModel gameModel) {
    final _formKey = GlobalKey<FormState>();
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
                    AppString.areYouSureToDeleteTheGame,
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
                      controller: controller.gameListScreenPasswordController,
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
                        // authController.gameListScreenPassword(context);

                        controller.gameListScreenPassword(
                            context, gameModel, widget.dateName);

                        // controller.deleteNewGame(
                        //     date: widget.dateName,
                        //     game: GameModel(
                        //         gameName: gameModel.gameName, teams: []));
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

// /// AM
// Obx(
//   () => GestureDetector(
//     onTap: () {
//       controller.selectAmPm.value = true;
//     },
//     child: Container(
//       padding: EdgeInsets.all(10.r),
//       decoration: BoxDecoration(
//           color: controller.selectAmPm.value == true
//               ? Color(0xFF380835)
//               : Color(0xFF917C9D),
//           borderRadius: BorderRadius.circular(10.r),
//           border: Border.all(color: Color(0xFF380835))),
//       child: Column(
//         children: [
//           Text(
//             AppString.am,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16.sp),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
// SizedBox(
//   width: 5.w,
// ),
//
// /// PM
// Obx(
//   () => GestureDetector(
//     onTap: () {
//       controller.selectAmPm.value = false;
//     },
//     child: Container(
//       padding: EdgeInsets.all(10.r),
//       decoration: BoxDecoration(
//           color: controller.selectAmPm.value == false
//               ? Color(0xFF380835)
//               : Color(0xFF917C9D),
//           borderRadius: BorderRadius.circular(10.r),
//           border: Border.all(color: const Color(0xFF380835))),
//       child: Column(
//         children: [
//           Text(
//             AppString.pm,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16.sp),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),
// ///hive
// final gameListBox =
//     await Hive.openBox<GameModel>('GameTimeList');
// var data = GameModel(
//     gameName: controller.timeController.text,
//     noOfTeam: 2);
// gameListBox.add(data);
// // controller.timeController.clear();
// Get.back();

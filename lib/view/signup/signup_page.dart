import 'dart:io';

import 'package:chatapp/providers/auth_provider.dart';
import 'package:chatapp/providers/common_provider.dart';
import 'package:chatapp/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupPage extends ConsumerWidget {
  SignupPage({super.key});
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ref) {
    final isLogin = ref.watch(commonProvider);
    final valdator = ref.watch(autoValid);
    final image = ref.watch(imageProvider);
    ref.listen(
      authprovider,
      (previous, next) {
        if (next.isError) {
          SnackShow.showSnackbar(context, next.errMessage, true);
        } else if (next.isSuccess) {
          SnackShow.showSnackbar(context, "Sucess", false);
        }
      },
    );
    final auth = ref.watch(authprovider);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          autovalidateMode: valdator,
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              SizedBox(
                height: 10.h,
              ),
              TextFormField(
                controller: emailController,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Email field required";
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Invalid email";
                  }
                  return null;
                }),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Email",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10.h,
              ),
              if (!isLogin)
                TextFormField(
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Username field required";
                    } else if (value.length < 8) {
                      return "username mustbe atlease 8 characters";
                    }
                    return null;
                  }),
                  controller: usernameController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.man),
                      hintText: "Username",
                      border: OutlineInputBorder()),
                ),
              if (!isLogin)
                SizedBox(
                  height: 10.h,
                ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Password field required";
                  }
                  return null;
                }),
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10.h,
              ),
              if (!isLogin)
                InkWell(
                  onTap: () {
                    Get.defaultDialog(
                        title: "Select",
                        content: const Text("Select an image"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ref
                                    .read(imageProvider.notifier)
                                    .imagePick(true);
                              },
                              child: const Text("Camera")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ref
                                    .read(imageProvider.notifier)
                                    .imagePick(false);
                              },
                              child: const Text("Gallery"))
                        ]);
                  },
                  child: Container(
                      height: 80.h,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: image != null
                          ? Image.file(File(image.path))
                          : const Center(
                              child: Text("Upload Image"),
                            )),
                ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                onTap: auth.isLoad
                    ? null
                    : (() {
                        if (form.currentState!.validate()) {
                          form.currentState!.save();
                          if (isLogin) {
                            ref.read(authprovider.notifier).login(
                                emailController.text.trim(),
                                passwordController.text.trim());
                          } else {
                            if (image != null) {
                              ref.read(authprovider.notifier).signup(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                  usernameController.text.trim(),
                                  image);
                            } else {
                              SnackShow.showSnackbar(
                                  context, "Please select an image", true);
                            }
                          }
                        } else {
                          ref.read(autoValid.notifier).togle();
                        }
                      }),
                child: Container(
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: auth.isLoad
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isLogin ? "Login" : "Signup",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 40.sp),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !isLogin ? "Already a member?" : "Not a member?",
                    style: TextStyle(fontSize: 32.sp),
                  ),
                  TextButton(
                      onPressed: () {
                        ref.read(commonProvider.notifier).togle();
                      },
                      child: Text(
                        !isLogin ? "Login" : "Signup",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 32.sp),
                      ))
                ],
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

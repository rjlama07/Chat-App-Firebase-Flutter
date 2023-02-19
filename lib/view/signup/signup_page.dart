import 'package:chatapp/providers/common_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final form = GlobalKey<FormState>();
    final isLogin = ref.watch(commonProvider);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              if (!isLogin)
                ListTile(
                  onTap: () {
                    debugPrint("Photo Upload");
                  },
                  horizontalTitleGap: 20.w,
                  contentPadding: const EdgeInsets.all(0),
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                  title: const Text("Upload photo"),
                ),
              SizedBox(
                height: 10.h,
              ),
              TextFormField(
                controller: emailController,
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
                  controller: usernameController,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Username",
                      border: OutlineInputBorder()),
                ),
              if (!isLogin)
                SizedBox(
                  height: 10.h,
                ),
              TextFormField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    hintText: "Password",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                onTap: (() {
                  debugPrint(emailController.text);
                  debugPrint(passwordController.text);
                }),
                child: Container(
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: Text(
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

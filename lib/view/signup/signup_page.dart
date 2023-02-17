import 'package:chatapp/view/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
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
                  hintText: "Username",
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10.h,
            ),
            TextFormField(
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
            TextFormField(
              obscureText: true,
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: "Confirm Password",
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
                    "Signup",
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
                  "Already a member?",
                  style: TextStyle(fontSize: 32.sp),
                ),
                TextButton(
                    onPressed: () => Get.to(const LoginPage()),
                    child: Text(
                      "Login",
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
    );
  }
}

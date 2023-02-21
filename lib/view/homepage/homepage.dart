import 'package:chatapp/providers/auth_provider.dart';
import 'package:chatapp/resources/firebase_instance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final user = FirebaseInstances.firebaseAuth.currentUser;
  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                child: Column(
              children: [
                CircleAvatar(
                  radius: 22.h,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Center(child: Text(user!.email.toString()))
              ],
            )),
            InkWell(
              onTap: () {
                Get.defaultDialog(
                    title: "Alert?",
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancle")),
                      TextButton(
                          onPressed: () {
                            ref.read(authprovider.notifier).logout();
                            Navigator.pop(context);
                          },
                          child: const Text("Logout"))
                    ]);
              },
              child: const ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  color: Colors.red,
                ),
                title: Text("Signout"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

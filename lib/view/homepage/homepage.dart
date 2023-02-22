import 'package:chatapp/providers/auth_provider.dart';
import 'package:chatapp/resources/firebase_instance.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final user = FirebaseInstances.firebaseAuth.currentUser;

  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userStream(user!.uid));
    final userstreams = ref.watch(userstream);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text("ChatApp"),
      ),
      drawer: Drawer(
          child: userData.when(
        data: (data) => ListView(
          children: [
            DrawerHeader(
                child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(data.imageUrl.toString()),
                  radius: 18.h,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Center(child: Text(data.firstName.toString())),
                Center(child: Text(data.metadata!['email']))
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
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      )),
      body: Column(
        children: [
          SizedBox(
            height: 55.h,
            width: double.maxFinite,
            child: userstreams.when(
              data: (data) => ListView.builder(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.h, vertical: 12.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 16.w),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 18.h,
                            backgroundImage:
                                NetworkImage("${data[index].imageUrl}"),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            data[index].firstName.toString(),
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    );
                  }),
              error: (error, stackTrace) =>
                  const Center(child: Icon(Icons.error)),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

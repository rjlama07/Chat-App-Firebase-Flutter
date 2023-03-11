import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/providers/auth_provider.dart';
import 'package:chatapp/resources/firebase_instance.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/services/post_service.dart';
import 'package:chatapp/view/create_post/create_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final user = FirebaseInstances.firebaseAuth.currentUser;
  Widget bottomSheet(Function edit, Function delete) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      height: 60.h,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              edit();
            },
            child: Row(
              children: [
                const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                SizedBox(
                  width: 40.w,
                ),
                Text(
                  "Edit Post",
                  style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          InkWell(
            onTap: () => delete(),
            child: Row(
              children: [
                const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 40.w,
                ),
                Text(
                  "Delete Post",
                  style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userStream(user!.uid));
    final userstreams = ref.watch(userstream);
    final postData = ref.watch(postStream);
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
                Navigator.pop(context);
                Get.to(CreatePost());
              },
              child: const ListTile(
                leading: Icon(
                  Icons.add_to_photos,
                  color: Colors.red,
                ),
                title: Text("Add Post"),
              ),
            ),
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
            ),
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
                          ),
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
          ),
          Expanded(
              child: postData.when(
            data: (data) {
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data[index].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30.sp),
                            ),
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        bottomSheet(() {}, () {}),
                                  );
                                },
                                icon: const Icon(Icons.more_horiz))
                          ],
                        ),
                        CachedNetworkImage(
                            height: 150.h, imageUrl: data[index].imageUrl),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data[index].detail,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30.sp),
                            ),
                            if (data[index].userId != user?.uid)
                              IconButton(
                                  padding: const EdgeInsets.all(0),
                                  constraints: const BoxConstraints(),
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.thumb_up_outlined,
                                    color: Colors.black,
                                  ))
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => Center(child: Text("$error")),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ))
        ],
      ),
    );
  }
}

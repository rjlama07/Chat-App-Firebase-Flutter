import 'dart:io';
import 'package:chatapp/providers/common_provider.dart';
import 'package:chatapp/providers/post_provider.dart';
import 'package:chatapp/resources/firebase_instance.dart';
import 'package:chatapp/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

final user = FirebaseInstances.firebaseAuth.currentUser;

class CreatePost extends ConsumerWidget {
  CreatePost({super.key});
  final usernameController = TextEditingController();
  final titleController = TextEditingController();
  final detailController = TextEditingController();

  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, ref) {
    final valdator = ref.watch(autoValid);
    final image = ref.watch(imageProvider);
    ref.listen(
      postProvider,
      (previous, next) {
        if (next.isError) {
          SnackShow.showSnackbar(context, next.errMessage, true);
        } else if (next.isSuccess) {
          SnackShow.showSnackbar(context, "Sucess", false);
          Get.back();
        }
      },
    );
    final post = ref.watch(postProvider);
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
                controller: titleController,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Please Provider title";
                  }
                  return null;
                }),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: "Title",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFormField(
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Details field required";
                  }
                  return null;
                }),
                controller: detailController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.details),
                    hintText: "Details",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      title: "Select",
                      content: const Text("Select an image"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ref.read(imageProvider.notifier).imagePick(true);
                            },
                            child: const Text("Camera")),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ref.read(imageProvider.notifier).imagePick(false);
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
                onTap: post.isLoad
                    ? null
                    : (() {
                        if (form.currentState!.validate()) {
                          form.currentState!.save();

                          if (image != null) {
                            ref.read(postProvider.notifier).addPost(
                                title: titleController.text.trim(),
                                detail: detailController.text.trim(),
                                userID: user!.uid,
                                image: image);
                          } else {
                            SnackShow.showSnackbar(
                                context, "Please select an image", true);
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
                    child: post.isLoad
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Add Post",
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
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

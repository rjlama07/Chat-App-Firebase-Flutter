import 'package:chatapp/view/homepage/homepage.dart';
import 'package:chatapp/view/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/common_provider.dart';

class StatusPage extends ConsumerWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final statusprovider = ref.watch(statusProvider);
    return Scaffold(
      body: statusprovider.when(
        data: (data) => data != null ? HomePage() : SignupPage(),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

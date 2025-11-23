import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/all_task_controller.dart';

class AllTaskView extends GetView<AllTaskController> {
  const AllTaskView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllTaskView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AllTaskView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

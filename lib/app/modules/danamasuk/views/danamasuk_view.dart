import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/danamasuk_controller.dart';

class DanamasukView extends GetView<DanamasukController> {
  const DanamasukView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DanamasukView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DanamasukView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

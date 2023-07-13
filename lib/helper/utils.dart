// ignore_for_file: depend_on_referenced_packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/shimmer.dart';
import 'api.dart';
import 'constant.dart';

/////////////////////////////////////////////////////////////////
/// Utilities Lists - By Kennedy (https://iyinusa.com)
/// - Copy to Clipboard
/// - Read and Write Files
/// - Shimmer Loading
/// - Snackbar Notification
/// - Success Notification
/// - Failed Notification
/// - No Content
/////////////////////////////////////////////////////////////////

class Utils {
  final api = Api();

  /// copy to clipboard
  copy(String str) {
    return Clipboard.setData(ClipboardData(text: str));
  }

  /// read file
  Future<String> readFile(String filename) async {
    String contents = '';

    // get default directory
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$filename');

    // check if file exist
    await file.exists().then((e) async {
      if (e == true) contents = await file.readAsString();
    });

    return contents;
  }

  /// read files
  Future<List> readFiles() async {
    var response = [];

    // get default directory
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    response = Directory(path).listSync();

    return response;
  }

  /// write file
  Future<File> writeFile(String filename, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$filename');

    return file.writeAsString(content);
  }

  /// shimmer loading
  shimmer(context) {
    final screen = MediaQuery.of(context).size;
    return SizedBox(
      width: screen.width,
      height: screen.height,
      child: ShimmerWidget.rectangle(
        width: MediaQuery.of(context).size.width,
        height: 100,
      ),
    );
  }

  /// notity
  notify({
    required String msg,
    String? title,
    Color? backColor,
    Color? colorText,
    String? position,
    Icon? icon,
  }) {
    Get.snackbar(
      title ?? 'Notification',
      msg,
      borderRadius: 0,
      backgroundColor: backColor,
      colorText: colorText,
      icon: icon,
      shouldIconPulse: true,
      snackPosition:
          position == 'bottom' ? SnackPosition.BOTTOM : SnackPosition.TOP,
    );
  }

  /// successful notification
  successNotify({required String msg, String? title}) {
    return notify(
      title: title ?? 'Great!',
      msg: msg,
      backColor: successColor,
      colorText: whiteColor,
      icon: const Icon(Icons.check, color: whiteColor),
    );
  }

  /// failed notification
  failedNotify({required String msg, String? title}) {
    return notify(
      title: title ?? 'Sorry!',
      msg: msg,
      backColor: failedColor,
      colorText: whiteColor,
      icon: const Icon(Icons.close, color: whiteColor),
    );
  }

  /// no content
  noContent({
    double? height,
    Icon? icon,
    required String content,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          Text(
            content,
            style: const TextStyle(color: darkGreyColor),
          ),
        ],
      ),
    );
  }
}

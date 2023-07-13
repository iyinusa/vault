import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The above functions are used for navigating between screens in a Dart application, with the ability
/// to save the current screen and specify a transition animation.
///
/// Args:
///   context: The `context` parameter is the current build context of the widget tree. It is typically
/// passed down from the parent widget and is used to access various properties and methods related to
/// the current state of the app.
///   page: The "page" parameter refers to the screen or page that you want to navigate to. It can be
/// any valid widget that represents a screen in your application.
///   save: The "save" parameter is a boolean value that determines whether the current page should be
/// saved in the navigation stack or not. If set to true, the current page will be saved in the stack,
/// allowing the user to navigate back to it. If set to false, the current page will be removed.
/// Defaults to true
void navScreen({context, page, save = true}) {
  Future(() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page), (route) => save);
  });
}

void navTo({page, Transition? transition}) {
  Get.to(
    page,
    transition: transition ?? Transition.native,
  );
}

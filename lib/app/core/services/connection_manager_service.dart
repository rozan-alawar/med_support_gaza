import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class ConnectionManagerService extends GetxService {
  final RxBool isConnected = true.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final int retryInterval = 5;
  final int maxRetryAttempts = 5;

  final RxBool isCriticalOperation = false.obs;

  DateTime? _lastConnectivityCheck;

  Future<ConnectionManagerService> init() async {
    await _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(updateConnectionStatus);
    return this;
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Connectivity check failed: ${e.toString()}');
      return;
    }
    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    final now = DateTime.now();
    if (_lastConnectivityCheck != null &&
        now.difference(_lastConnectivityCheck!).inSeconds < 2) {
      return;
    }
    _lastConnectivityCheck = now;

    // Update connectivity status
    bool wasConnected = isConnected.value;
    isConnected.value = (result != ConnectivityResult.none);

    if (wasConnected != isConnected.value) {
      if (isConnected.value) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (Get.context != null) {
            if (Get.currentRoute == '/no-internet' || Get.currentRoute == '') {
              Get.offAllNamed(AppPages.INITIAL);
            }

            CustomSnackBar.showCustomSnackBar(
              title: 'Connection Restored',
              message: 'You are back online',
              position: SnackPosition.TOP,
            );
          }
          print("You are back online");

          if (isCriticalOperation.value) {
            Future.delayed(Duration(seconds: 1), () {
              if (Get.context != null) {
                CustomSnackBar.showCustomSnackBar(
                  title: 'Connection Restored',
                  message: 'Please retry your previous action',
                  position: SnackPosition.TOP,
                );
              }
            });
            isCriticalOperation.value = false;
          }
        });
      } else {
        print("Please check your internet connection");

        Future.delayed(Duration(milliseconds: 300), () {
          if (Get.context != null) {
            CustomSnackBar.showCustomErrorSnackBar(
              title: 'No Internet Connection',
              message: 'Please check your internet connection',
            );
          }
        });
        tryReconnect();
      }
    }
  }

  Future<void> tryReconnect() async {
    int attempts = 0;
    bool reconnected = false;

    while (attempts < maxRetryAttempts && !reconnected && !isConnected.value) {
      attempts++;
      await Future.delayed(Duration(seconds: retryInterval));

      ConnectivityResult result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        reconnected = true;
        // Check if we're currently on the NoInternetWidget
        if (Get.currentRoute == '/no-internet' || Get.currentRoute == '') {
          // Navigate back to the initial route if we're on the NoInternetWidget
          Get.offAllNamed(AppPages.INITIAL);
        }

        CustomSnackBar.showCustomSnackBar(
          title: 'Reconnected',
          message: 'Successfully reconnected to the internet',
          position: SnackPosition.TOP,
        );
        print("Successfully reconnected to the internet");
        break;
      }
    }

    if (!reconnected && !isConnected.value) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Connection Failed',
        message: 'Unable to reconnect after several attempts.',
      );
      print("Unable to reconnect after several attempts.");
    }
  }

  Future<bool> checkConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    bool previousState = isConnected.value;
    isConnected.value = (result != ConnectivityResult.none);

    // If connection is restored, navigate back to the main app
    if (isConnected.value && !previousState && Get.context != null) {
      if (Get.currentRoute == '/no-internet' || Get.currentRoute == '') {
        Get.offAllNamed(AppPages.INITIAL);
      }

      CustomSnackBar.showCustomSnackBar(
        title: 'Connection Restored',
        message: 'You are back online',
        position: SnackPosition.TOP,
      );
    }

    return isConnected.value;
  }

  void markCriticalOperation(bool isCritical) {
    isCriticalOperation.value = isCritical;
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';

class ConnectionManagerService extends GetxService {
  final RxBool isConnected = true.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final int retryInterval = 5;

  Future<ConnectionManagerService> init() async {
    await _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    bool wasConnected = isConnected.value;
    isConnected.value = (result != ConnectivityResult.none);

    if (wasConnected != isConnected.value) {
      if (isConnected.value) {
        // CustomSnackBar.showCustomSnackBar(
        //   title: 'Connection Restored',
        //   message: 'You are back online',
        //   position: SnackPosition.TOP,
        // );
        print("You are back online");
      } else {
        print("Please check your internet connection");
        //
        // CustomSnackBar.showCustomErrorSnackBar(
        //   title: 'No Internet Connection',
        //   message: 'Please check your internet connection',
        // );
        _tryReconnect();
      }
    }
  }

  Future<void> _tryReconnect() async {
    int attempts = 0;
    bool reconnected = false;

    while (attempts < 5 && !reconnected) {
      attempts++;
      await Future.delayed(Duration(seconds: retryInterval));

      ConnectivityResult result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        reconnected = true;
        // CustomSnackBar.showCustomSnackBar(
        //   title: 'Reconnected',
        //   message: 'Successfully reconnected to the internet',
        //   position: SnackPosition.TOP,
        // );
        print("Successfully reconnected to the internet");

        break;
      }
    }

    if (!reconnected) {
      // CustomSnackBar.showCustomErrorSnackBar(
      //   title: 'Connection Failed',
      //   message: 'Unable to reconnect after several attempts.',
      //
      // );
      print("Unable to reconnect after several attempts.");

    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}

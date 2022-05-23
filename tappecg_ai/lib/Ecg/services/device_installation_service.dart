import 'package:flutter/services.dart';

class DeviceInstallationService {
  static const deviceInstallation = MethodChannel(
      'com.smartheartmonitoring.pe.tappecg_ai/deviceinstallation');
  static const String getDeviceIdChannelMethod = "getDeviceId";
  static const String getDeviceTokenChannelMethod = "getDeviceToken";
  static const String getDevicePlatformChannelMethod = "getDevicePlatform";

  Future<String> getDeviceId() async {
    return await deviceInstallation.invokeMethod(getDeviceIdChannelMethod);
  }

  Future<String> getDeviceToken() async {
    return await deviceInstallation.invokeMethod(getDeviceTokenChannelMethod);
  }

  Future<String> getDevicePlatform() async {
    return await deviceInstallation
        .invokeMethod(getDevicePlatformChannelMethod);
  }
}

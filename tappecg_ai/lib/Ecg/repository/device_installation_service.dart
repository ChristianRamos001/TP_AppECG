import 'package:flutter/services.dart';

class DeviceInstallationService {
  static const deviceInstallation = const MethodChannel('smartheartmonitoring.pe.tappecg_ai/deviceinstallation');
  static const String getDeviceIdChannelMethod = "getDeviceId";
  static const String getDeviceTokenChannelMethod = "getDeviceToken";
  static const String getDevicePlatformChannelMethod = "getDevicePlatform";

  Future getDeviceId() {
    return deviceInstallation.invokeMethod(getDeviceIdChannelMethod);
  }

  Future getDeviceToken() {
    return deviceInstallation.invokeMethod(getDeviceTokenChannelMethod);
  }

  Future getDevicePlatform() {
    return deviceInstallation.invokeMethod(getDevicePlatformChannelMethod);
  }
}
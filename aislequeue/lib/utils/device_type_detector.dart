import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class DeviceTypeDetector {
  static String getDeviceType(BuildContext context) {
    // Improved device type detection
    if (kIsWeb) return 'Web';
    
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    if (shortestSide < 600) return 'Phone';
    if (shortestSide < 1200) return 'Tablet';
    return 'Desktop';
  }
}

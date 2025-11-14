// lib/src/core/rtc/tencent_rtc_initializer.dart

import 'dart:developer';
import 'package:rtc_room_engine/rtc_room_engine.dart';

class TencentRtcInitializer {
  static bool _loggedIn = false;

  // 👇 DEMO CONSTANTS (replace with your real values)
  static const int _sdkAppId = 20030422;
  static const String _demoUserId = 'dilan'; // must match userSig
  static const String _demoUserSig =
      'eJwtzE0LgkAUheH-ctdh1xnHUGghRFi5KU1atBHuFBc-Gk3Kiv57pi7Pc*D9QBLF1kM34IOwEGbDZtJVyxcemLjIqum4U54ZwwS*QJToCDG67gw3GnxbKdU-OGrL5d8WrrTREyinBl-76i2kg6ZiFZbNekcqT1w8RZu0Ds7zF9XPdntUe8fTXfqOcQnfHwhhMWU_';

  /// Call this before joining/starting any conference.
  static Future<bool> ensureLoggedIn() async {
    if (_loggedIn) return true;

    try {
      final result = await TUIRoomEngine.login(
        _sdkAppId,
        _demoUserId,
        _demoUserSig,
      );

      if (result.code == TUIError.success) {
        _loggedIn = true;
        log('TUIRoomEngine login success for $_demoUserId');
        return true;
      } else {
        log(
          'TUIRoomEngine login FAILED '
          'code=${result.code}, message=${result.message}',
        );
        return false;
      }
    } catch (e, st) {
      log('TUIRoomEngine login exception: $e', stackTrace: st);
      return false;
    }
  }
}

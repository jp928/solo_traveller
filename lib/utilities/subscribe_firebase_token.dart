import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'dart:io' show Platform;
import 'package:connectycube_sdk/connectycube_pushnotifications.dart';

class PushNotificationManager {
  Future<void> subscribe() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token;
    if (Platform.isAndroid) {
      token = await firebaseMessaging.getToken();
    } else if (Platform.isIOS) {
      token = await firebaseMessaging.getAPNSToken();
    }

    if (!isEmpty(token)) {
      await subscribeFirebaseToken(token!);
    }

    firebaseMessaging.onTokenRefresh.listen((newToken) {
      subscribeFirebaseToken(newToken);
    });
  }

  unsubscribe() {
    getSubscriptions()
        .then((subscriptionsList) {
          subscriptionsList.map((subscription) {
            if (subscription.id != null) {
              deleteSubscription(subscription.id!);
            }
          });
        })
        .then((voidResult) {})
        .catchError((error) {});
  }

  subscribeFirebaseToken(String token) async {
    log('[subscribe] token: $token');

    bool isProduction = bool.fromEnvironment('dart.vm.product');

    CreateSubscriptionParameters parameters = CreateSubscriptionParameters();
    parameters.environment =
        isProduction ? CubeEnvironment.PRODUCTION : CubeEnvironment.DEVELOPMENT;

    if (Platform.isAndroid) {
      parameters.channel = NotificationsChannels.GCM;
      parameters.platform = CubePlatform.ANDROID;
      parameters.bundleIdentifier = "com.example.solo_traveller";
    } else if (Platform.isIOS) {
      parameters.channel = NotificationsChannels.APNS;
      parameters.platform = CubePlatform.IOS;
      parameters.bundleIdentifier = "com.ionicframework.solotravellerapp837435";
    }

    String? deviceId = await PlatformDeviceId.getDeviceId;
    parameters.udid = deviceId;
    parameters.pushToken = token;

    createSubscription(parameters.getRequestParameters())
        .then((cubeSubscription) {})
        .catchError((error) {
      log('register token error', error.toString());
    });
  }
}

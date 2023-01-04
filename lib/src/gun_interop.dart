/// This module is the javascript interface of the dart library.
///
/// Those classes are not meant to be used directly by the user.
/// They are used by the dart library to call the javascript functions.

import 'package:js/js.dart';

import 'package:gun_dart/src/utils.dart';
import '../types.dart';

// ignore_for_file: public_member_api_docs

typedef OnceCallback = void Function(dynamic data, String key);
typedef OnCallback = void Function(
    dynamic data, String key, dynamic msg, dynamic ev);

@JS('Gun')
class GunJsImpl {
  external GunJsImpl(List<String>? peers);

  external GunJsImpl get(String sub);
  external GunJsImpl set(dynamic data);
  external GunJsImpl map();
  external GunJsImpl put(dynamic data);
  external GunJsImpl on(OnCallback sub);
  external GunJsImpl once(OnceCallback sub);
  external GunJsImpl off();

  external UserJsImpl user(String? userPublicKey);

  external GunJsImpl back(dynamic amount);
  external GunJsImpl opt(dynamic config);
  external static int state();
}

typedef DataCallback = void Function(Object data);

@JS('User')
class UserJsImpl {
  external UserJsImpl auth(dynamic username, dynamic password, [dynamic cb]);
  external UserJsImpl create(
      String username, String password, DataCallback? cb);
  external UserJsImpl recall(dynamic data);
  external UserJsImpl leave();
  external UserJsImpl delete(
      String username, String password, DataCallback? sub);
  external KeyPair pair();

  external UserJsImpl get(String sub);
  external UserJsImpl set(dynamic data);
  external UserJsImpl map();
  external UserJsImpl put(dynamic data);
  external UserJsImpl on(OnCallback sub);
  external UserJsImpl once(OnceCallback sub);
  external UserJsImpl off();
}

@JS('Gun.SEA')
class SeaJsImpl {
  external static Promise<KeyPair> pair();
  external static Promise<String?> sign(Object? data, KeyPair pair);
  external static Promise<String?> work(Object? data, dynamic pair,
      [Function? cb, dynamic opt]);
  external static Promise<Object?> verify(Object data, KeyPair pair);
  external static Promise<String?> encrypt(Object? data, dynamic pair);
  external static Promise<Object?> decrypt(Object data, dynamic pair);
  external static Promise<String?> secret(String data, KeyPair pair);
  external static String? get err;
}

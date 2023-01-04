import 'dart:async';

import 'package:js/js.dart';
import 'package:js/js_util.dart';

import 'src/gun_interop.dart';
import 'src/utils.dart';
import 'types.dart';

/// The core Gun class.
///
/// You can create a new instance of Gun by calling the constructor:
/// ```dart
/// final gun = Gun(peers: ['https://gun.example.com/gun']);
/// ```
/// and then use it to access the data:
/// ```dart
/// final node = gun.get('some/path');
///
/// node.put({'some': 'data'});
/// node.on((data, key) => print(data));
///
/// final user = gun.user();
/// ```
///
/// See also [User] for more information about user authentication.
class Gun {
  late final GunJsImpl _gun;

  /// Create an instance of Gun,
  /// [peers] represent the list of gun relay to connect to.
  Gun({List<String>? peers}) {
    _gun = GunJsImpl(peers);
  }

  /// Private constructor used to create a new instance of Gun
  /// from a [GunJsImpl] instance.
  Gun._(this._gun);

  /// Returns a the node at the given [sub].
  Gun get(String sub) {
    final gun = _gun.get(sub);
    return Gun._(gun);
  }

  /// Iterate on each property of a node.
  Gun map() {
    final gun = _gun.map();
    return Gun._(gun);
  }

  /// Apply the callback function to each change of the document.
  Gun on(Function(dynamic data, String key) cb) {
    final gun = _gun.on(allowInterop(
      (dynamic data, key, dynamic msg, dynamic ev) {
        cb(jsToDart(data), key);
      },
    ));
    return Gun._(gun);
  }

  /// Apply the callback function once without subscribing to changes.
  Gun once(Function(dynamic data, String key) cb) {
    final gun = _gun.once(allowInterop(
      (dynamic data, key) {
        cb(jsToDart(data), key);
      },
    ));
    return Gun._(gun);
  }

  /// Unsubscribe from changes.
  Gun off() {
    final gun = _gun.off();
    return Gun._(gun);
  }

  /// Integrates [data] in a node.
  Gun put(dynamic data) {
    final gun = _gun.put(dartToJs(data));
    return Gun._(gun);
  }

  /// Adds a unique [data] to a node.
  Gun set(dynamic data) {
    if (data is Map) {
      data = dartToJs(data);
    }
    final gun = _gun.set(data);
    return Gun._(gun);
  }

  /// Move up to the parent context on the chain.
  Gun back({int? amount}) {
    final gun = _gun.back(amount);
    return Gun._(gun);
  }

  /// Change the configuration of the gun database instance.
  Gun addPeers(List<String> peers) {
    final opt = dartToJs({'peers': peers});
    final gun = _gun.opt(opt);
    return Gun._(gun);
  }

  /// Returns the current timestamp.
  static int state() {
    return GunJsImpl.state();
  }

  /// Returns a new instance of [User] from the current instance of [Gun].
  User user([String? userPublicKey]) {
    final user = _gun.user(userPublicKey);
    return User._(user);
  }

  /// Returns the peers of the Gun instance.
  List<Peer> peers() {
    final object = _gun.back('root.opt.peers');
    final peers = values(object);
    return peers.map((e) => e as Peer).toList();
  }
}

/// The User class of Gun used for authentification.
///
/// You need a [Gun] instance to get the associated instance of [User].
/// ```dart
/// final user = gun.user();
/// ```
///
/// then you can use it to authenticate a user:
/// ```dart
/// user.auth('username', 'password');
/// ```
class User {
  final UserJsImpl _user;

  User._(UserJsImpl user) : _user = user;

  /// Returns properties (public/private keys) of the logged user.
  /// If the auth failed, returns null.
  Future<KeyPair?> auth(String username, String password) {
    final completer = Completer<KeyPair?>();
    _user.auth(username, password, allowInterop(
      (Object data) {
        final KeyPair? sea = getProperty(data, 'sea');
        completer.complete(sea);
      },
    ));
    return completer.future;
  }

  /// Returns properties (public/private keys) of the logged user.
  /// If the auth failed, returns null.
  Future<KeyPair?> authWithKeyPair(KeyPair pair) {
    final completer = Completer<KeyPair?>();
    _user.auth(pair, allowInterop(
      (Object data) {
        final KeyPair? sea = getProperty(data, 'sea');
        completer.complete(sea);
      },
    ));
    return completer.future;
  }

  /// Creates a new user with the [username] and [password] provided.
  /// Returns the public key of the user.
  Future<String?> create(String username, String password) {
    final completer = Completer<String?>();
    _user.create(username, password, allowInterop(
      (Object data) {
        completer.complete(getProperty(data, 'pub'));
      },
    ));
    return completer.future;
  }

  /// Use the local storage to save the user.
  User recall() {
    final opt = dartToJs({'localStorage': true});
    final user = _user.recall(opt);
    return User._(user);
  }

  /// Disconnect the user.
  User leave() {
    final user = _user.leave();
    return User._(user);
  }

  /// Delete the user.
  Future<bool> delete(String username, String password) {
    final completer = Completer<bool>();
    _user.delete(username, password, allowInterop((data) {
      completer.complete(!hasProperty(data, 'err'));
    }));
    return completer.future;
  }

  /// Returns the key pair of the user.
  @Deprecated('''Use user.auth(...) instead.''')
  KeyPair? pair() {
    final pair = _user.pair();
    if (getProperty<String?>(pair, 'pub') == null) {
      return null;
    }
    return pair;
  }

  /// Returns the information present on the [sub] node.
  User get(String sub) {
    final user = _user.get(sub);
    return User._(user);
  }

  /// Iterate on each property of a node.
  User map() {
    final user = _user.map();
    return User._(user);
  }

  /// Apply the callback function to each change of the document.
  User on(Function(dynamic data, String key) cb) {
    final user = _user.on(allowInterop(
      (dynamic data, key, dynamic msg, dynamic ev) {
        cb(jsToDart(data), key);
      },
    ));
    return User._(user);
  }

  /// Apply the callback function once without subscribing to changes.
  User once(Function(dynamic data, String key) cb) {
    final user = _user.once(allowInterop(
      (dynamic data, key) {
        cb(jsToDart(data), key);
      },
    ));
    return User._(user);
  }

  /// Unsubscribe from changes.
  User off() {
    final user = _user.off();
    return User._(user);
  }

  /// Integrates [data] (string or object) in a node and saves them to the User,
  /// synchronizing the peers of a network.
  User put(dynamic data) {
    final user = _user.put(dartToJs(data));
    return User._(user);
  }

  /// Adds a unique [data] object to a node.
  User set(dynamic data) {
    if (data is Map) {
      data = dartToJs(data);
    }
    final user = _user.set(data);
    return User._(user);
  }

  /// Returns the information about the user.
  /// If the user is not connected, it returns null.
  UserInfo? get info {
    return getProperty(_user, 'is');
  }

  /// Returns the public Keys of the user.
  /// If the user is not connected, it returns null.
  KeyPair? get keys {
    return getProperty(getProperty(_user, '_'), 'sea');
  }
}

/// The SAE  class used to encrypt and decrypt data.
///
/// Every method of this class is static.
///
/// ## Errors
///
/// If an error occurs, the method returns null. \\
/// The last error is stored in the [err] property.
///
/// ```dart
/// final encrypted = Sea.encrypt('Hello World', 'password');
/// if (encrypted == null) {
///  print(Sea.err);
/// }
/// ```
class Sea {
  /// Generate a new key pair.
  static Future<KeyPair> pair() => toFuture(SeaJsImpl.pair());

  /// Gives a Proof of Work by hasshing the [data] provided.
  static Future<String?> work(
    Object data,
    Object salt, {
    Algorithm? algorithm,
    Encoding? encoding,
  }) {
    final opt = dartToJs({
      'name': algorithm?.value,
      'encode': encoding?.value,
    });
    return toFuture(SeaJsImpl.work(dartToJs(data), salt, null, opt));
  }

  /// Sign the [data] with the [pair].
  static Future<String?> sign(Object data, KeyPair pair) =>
      toFuture(SeaJsImpl.sign(dartToJs(data), pair));

  /// Verify the [data] with the [pair].
  static Future<Object?> verify(Object data, KeyPair pair) =>
      toFuture(SeaJsImpl.verify(data, pair)).then(jsToDart);

  /// Encrypt the [data] with the [pair].
  static Future<String?> encrypt(Object data, KeyPair pair) =>
      toFuture(SeaJsImpl.encrypt(dartToJs(data)!, pair));

  /// Decrypt the [data] with the [pair].
  static Future<Object?> decrypt(Object data, KeyPair pair) =>
      toFuture(SeaJsImpl.decrypt(dartToJs(data)!, pair)).then(jsToDart);

  /// Encrypt the [data] with a [key].
  static Future<String?> encryptWithKey(Object data, String key) =>
      toFuture(SeaJsImpl.encrypt(dartToJs(data)!, key));

  /// Decrypt the [data] with a [key].
  static Future<Object?> decryptWithKey(Object data, String key) =>
      toFuture(SeaJsImpl.decrypt(dartToJs(data)!, key)).then(jsToDart);

  /// Create a secret between [data] (pub key) and [pair].
  static Future<String?> secret(String data, KeyPair pair) =>
      toFuture(SeaJsImpl.secret(data, pair));

  /// The error message if the any [Sea] function failed.
  static String? get err => SeaJsImpl.err;
}

extension on Algorithm {
  /// Convert the [Algorithm] to a string for gunjs.
  String get value {
    switch (this) {
      case Algorithm.sha256:
        return 'SHA-256';
      case Algorithm.pbkdf2:
        return 'PBKDF2';
    }
  }
}

extension on Encoding {
  /// Convert the [Encoding] to a string for gunjs.
  String get value {
    switch (this) {
      case Encoding.hex:
        return 'hex';
      case Encoding.base64:
        return 'base64';
      case Encoding.utf8:
        return 'utf8';
    }
  }
}

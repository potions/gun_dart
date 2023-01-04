import 'dart:html';

import 'package:js/js.dart';

export 'src/utils.dart' show log;

/// A javascript Object of a KeyPair.
///
/// To convert the object to a Dart [Map] use [KeyPairConverter].
@JS()
@anonymous
class KeyPair {
  /// The public key.
  external String get pub;

  /// The encryption public key.
  external String get epub;

  /// The private key.
  external String? get priv;

  /// The encryption private key.
  external String? get epriv;

  /// Constructor
  external factory KeyPair({
    required String pub,
    required String epub,
    String? priv,
    String? epriv,
  });
}

/// Utility function to convert between a [KeyPair] to a [Map].
extension KeyPairConverter on KeyPair {
  /// Convert the object to a Dart Map.
  ///
  /// The [priv] and [epriv] properties are included.
  Map<String, String> toMap() {
    final map = <String, String>{
      'pub': pub,
      'epub': epub,
    };
    if (priv != null) {
      map['priv'] = priv!;
    }
    if (epriv != null) {
      map['epriv'] = epriv!;
    }
    return map;
  }

  /// Convert a Dart Map to a KeyPair.
  KeyPair? fromMap(Map<String, String> map) {
    if (map['pub'] == null || map['epub'] == null) {
      return null;
    }
    return KeyPair(
      pub: map['pub']!,
      epub: map['epub']!,
      priv: map['priv'],
      epriv: map['epriv'],
    );
  }
}

/// A javascript Object of a Gun Peer.
@JS()
class Peer {
  /// The unique id of the peer.
  external String get id;

  /// The url of the peer.
  external String get url;

  /// The websocket of the peer.
  external WebSocket? get wire;
}

/// A javascript Object with a user informations.
@JS()
class UserInfo {
  /// The username of the user.
  external String get alias;

  /// The public key of the user.
  external String get pub;

  /// The encryption public key of the user.
  external String get epub;
}

/// Utility function to convert a [UserInfo] to a [KeyPair].
extension AsKeyPair on UserInfo {
  /// Convert the object to a Dart KeyPair.
  ///
  /// ```dart
  /// final user = gun.user("some_user_public_key");
  /// final userInfo = await user.info;
  ///
  /// final keyPair = userInfo.asKeyPair();
  /// ```
  KeyPair asKeyPair() {
    return this as KeyPair;
  }
}

/// The algorithm used for the Proof of Work.
enum Algorithm {
  /// The SHA-256 algorithm.
  sha256,

  /// The PBKDF2 algorithm.
  pbkdf2,
}

/// The encoding used for the Proof of Work.
enum Encoding {
  /// The hexademical encoding.
  hex,

  /// The base64 encoding.
  base64,

  /// The UTF-8 encoding.
  utf8,
}

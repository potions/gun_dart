@TestOn('browser')

import 'package:test/test.dart';

import 'package:gun_dart/gun.dart';

void main() {
  test('Create a user instance', () {
    final gun = Gun();
    final user = gun.user();
    expect(user, isNotNull);
  });

  test('Authentification', () async {
    final gun = Gun();
    final user = gun.user();

    final pubKey = await user.create('username', 'password');
    expect(pubKey, isNotNull);

    final auth = await user.auth('username', 'password');
    expect(auth, isNotNull);

    expect(user.info, isNotNull);
    expect(user.keys?.epriv, isNotNull);
  });
}

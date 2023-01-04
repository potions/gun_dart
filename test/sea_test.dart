@TestOn('browser')

import 'package:test/test.dart';

import 'package:gun_dart/gun.dart';

void main() {
  test('Generate a key pair', () async {
    final keyPair = await Sea.pair();
    expect(keyPair, isNotNull);
    expect(keyPair.pub, isNotNull);
    expect(keyPair.epub, isNotNull);
    expect(keyPair.priv, isNotNull);
    expect(keyPair.epriv, isNotNull);
  });

  test('Encrypt and decrypt a string', () async {
    final pair = await Sea.pair();

    final encrypted = await Sea.encrypt('some data', pair);
    expect(encrypted, isNotNull);

    final decrypted = await Sea.decrypt(encrypted!, pair);
    expect(decrypted, 'some data');
  });

  test('Encrypt and decrypt an abject', () async {
    final pair = await Sea.pair();

    final data = {
      'some': 'data',
      'list': [1, 2, 3],
    };
    final encrypted = await Sea.encrypt(data, pair);
    expect(encrypted, isNotNull);

    final decrypted = await Sea.decrypt(encrypted!, pair);
    expect(decrypted, data);
  });

  test('Sign and verify a string', () async {
    final pair = await Sea.pair();

    final signed = await Sea.sign('some data', pair);
    expect(signed, isNotNull);

    final verified = await Sea.verify(signed!, pair);
    expect(verified, 'some data');
  });

  test('Sign and verify an abject', () async {
    final pair = await Sea.pair();

    final data = {
      'some': 'data',
      'list': [1, 2, 3],
    };
    final signed = await Sea.sign(data, pair);
    expect(signed, isNotNull);

    final verified = await Sea.verify(signed!, pair);
    expect(verified, data);
  });

  test('Encrypt and decrypt with string key', () async {
    final secretKey = 'secret key';

    final data = {
      'some': 'data',
      'list': [1, 2, 3],
    };
    final encrypted = await Sea.encryptWithKey(data, secretKey);
    expect(encrypted, isNotNull);

    final decrypted = await Sea.decryptWithKey(encrypted!, secretKey);
    expect(decrypted, data);
  });

  test('Fail to decrypt', () async {
    final pair = await Sea.pair();

    final encrypted = await Sea.encrypt('some data', pair);
    expect(encrypted, isNotNull);
    expect(Sea.err, isNull);

    final decrypted = await Sea.decryptWithKey(encrypted!, 'some key');
    expect(decrypted, isNull);
    expect(Sea.err, isNotNull);
  });
}

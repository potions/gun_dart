@TestOn('browser')

import 'package:test/test.dart';

import 'package:gun_dart/types.dart';

void main() {
  test('Create a KeyPair instance', () {
    final keyPair = KeyPair(
      pub: 'pubKey',
      epub: 'epubKey',
    );
    expect(keyPair, isNotNull);
    expect(keyPair.pub, 'pubKey');
    expect(keyPair.epub, 'epubKey');
    expect(keyPair.priv, isNull);
    expect(keyPair.epriv, isNull);

    final keyPair2 = KeyPair(
      pub: 'pubKey',
      epub: 'epubKey',
      priv: 'privKey',
      epriv: 'eprivKey',
    );
    expect(keyPair2, isNotNull);
    expect(keyPair2.pub, 'pubKey');
    expect(keyPair2.epub, 'epubKey');
    expect(keyPair2.priv, 'privKey');
    expect(keyPair2.epriv, 'eprivKey');
  });
}

@TestOn('browser')

import 'package:test/test.dart';

import 'package:gun_dart/gun.dart';

void main() {
  test('Create a gun instance', () {
    final gun = Gun();
    expect(gun, isNotNull);
  });

  test('Create a gun instance with peers', () {
    final gun = Gun(peers: ['https://gun.example.com/gun']);
    expect(gun, isNotNull);
  });

  test('Get a node', () {
    final gun = Gun();
    final node = gun.get('some/path');
    expect(node, isNotNull);
  });
}

import 'package:gun_dart/gun.dart';

void main(List<String> args) async {
  final gun = Gun();
  final node = gun.get('node').get('subnode');

  node.on((data, key) {
    print(data);
  });

  node.put('Hello World');

  final user = gun.user();
  await user.create('username', 'password');
  final pair = await user.auth('username', 'password');

  if (pair == null) {
    print(Sea.err);
    throw Exception('Auth failed');
  }

  final encrypted = await Sea.encrypt("Hello world 2", pair);

  node.put(encrypted);

  node.once((data, key) async {
    final decrypted = await Sea.decrypt(data, pair);
    print(decrypted);
  });
}

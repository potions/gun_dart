# Gun Dart

Gun Dart is a Dart wrapper around the [Gun JS](https://gun.eco/) library.

This library is almost a 1:1 port of the JS library, with some minor changes to
make it more Dart-like. Gun JS is a disctributed database that can be used to
build decentralized applications.

* Web support only.
* Null safety.
* SEA encryption.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  gun_dart: ^0.1.0
```

**Important** : Add the following to your `web/index.html`:

```html
<head>
  <!-- ... -->

  <!-- import gun js -->
  <script src="https://cdn.jsdelivr.net/npm/gun/gun.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/gun/sea.min.js"></script>

  <!-- import gun js with a tested version -->
  <script src="https://cdn.jsdelivr.net/npm/gun@0.2020.1238/gun.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/gun@0.2020.1238/sea.min.js"></script>

  <!-- ... -->
</head>
```


## Getting Started

```dart
import 'package:gun_dart/gun.dart';

void main() {
  final gun = Gun(peers: ['https://a_gun_server.com/gun']);
  final node = gun.get('node').get('subnode');

  node.on((data, key) {
    print(data);
  });

  node.put('value');
}
```

For more examples, see :

* the `example/example.dart` demo file.
* the `example/` a flutter demo project.

## Authors and acknowledgment

Made by [INSA Rouen Normandie](https://www.insa-rouen.fr) students
for a research project on the decentralized web. \
The project was supervised by **Julien VINCKEL**, CEO of [Potions](https://get-potions.com).

Made by:

* **Julie ALLAIS**
* **Paul BRIDIER**
* **Louis DEVAUD**
* **Louis DISPA**
* **Damien GENS**
* **Sarah LE MÉE**

Thanks to [Gun JS](https://gun.eco/) for their work.

# A Gun dart example

This example is a simple **chat app** that uses the **Gun dart** plugin.  
It is only working on the web platform.

## How to run

Install flutter : [Installation guide](https://flutter.dev/docs/get-started/install)

```bash
flutter pub get
flutter run
```

## Were to look

**Simple examples** of Gun dart are in the `lib/app_bar.dart` file.

* **The Title** uses dart streams to update the title of the app bar.
* **The peer status** uses flutter StatefullWidget to update the peer status.

**A more complex example** is in the `lib/chat.dart` file. \
It uses a **Gun dart** node to store and retrieve messages.

import 'package:flutter/material.dart';
import 'package:gun_dart/gun.dart';

import 'app_bar.dart';
import 'chat.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

/// The main widget of the app.
///
/// It contains a [CustomAppBar] and a [ChatList] that each demonstrate
/// how to use the Gun API.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Connect to the Gun server
    final gun = Gun(peers: ['https://gunjs.herokuapp.com/gun']);
    // Get the chat node
    final node = gun.get('converse/test');

    return MaterialApp(
      title: 'Test GunJS',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(node: node),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.node}) : super(key: key);

  final Gun node;

  @override
  Widget build(BuildContext context) {
    final messageNode = node.get('messages');

    return Scaffold(
      appBar: CustomAppBar(titleNode: node.get("title")),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Expanded(
                child: ChatList(node: messageNode),
              ),
              ChatInput(node: messageNode),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gun_dart/gun.dart';

/// A widget that displays a list of messages.
///
/// The messages are stored in the Gun node passed in the constructor.
class ChatList extends StatefulWidget {
  const ChatList({Key? key, required this.node}) : super(key: key);

  /// The node that contains the messages
  final Gun node;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Message> messages = [];

  @override
  void initState() {
    // At the widget creation, we create a listener on the Gun node
    // and we push every new message in the state of the widget

    // The .map() method is used to iterate over every property of the node
    widget.node.map().once((data, key) {
      if (data is! Map) {
        return;
      }
      final msg = Message.fromMap(data);
      if (msg == null) {
        return;
      }

      setState(() {
        final index = messages.indexWhere((e) => msg.when > msg.when);
        if (index == -1) {
          messages.add(msg);
        } else {
          messages.insert(index, msg);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(10),
      children: messages.map(_buildCard).toList(),
    );
  }

  Widget _buildCard(Message msg) {
    final when = DateTime.fromMillisecondsSinceEpoch(msg.when);
    return Align(
      alignment: Alignment.centerLeft,
      child: Tooltip(
        message: 'Sent at $when',
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('${msg.who}: ${msg.what}'),
          ),
        ),
      ),
    );
  }
}

/// A widget that allows the user to send a message
///
/// The message is stored in the Gun node passed in the constructor
class ChatInput extends StatelessWidget {
  ChatInput({Key? key, required this.node}) : super(key: key);

  /// The node that contains the messages
  final Gun node;

  final controlerWhat = TextEditingController();
  final controlerWho = TextEditingController();

  _sendMessage() async {
    var obj = Message(
      controlerWho.text,
      controlerWhat.text,
      Gun.state(),
    ).toMap();

    /// Add the message to a set in the Gun node
    node.set(obj);
    controlerWhat.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: controlerWho,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 3,
              child: TextField(
                controller: controlerWhat,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: 'Message',
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

/// A data class for a message.
class Message {
  Message(this.who, this.what, this.when);

  /// Creates a [Message] from a [Map].
  ///
  /// Returns `null` if the [Map] is not a valid [Message].
  static Message? fromMap(Map map) {
    if (map['who'] == null || map['what'] == null || map['when'] == null) {
      return null;
    }
    return Message(map['who'], map['what'], map['when']);
  }

  Map<String, dynamic> toMap() {
    return {'who': who, 'what': what, 'when': when};
  }

  final String who;
  final String what;
  final int when;
}

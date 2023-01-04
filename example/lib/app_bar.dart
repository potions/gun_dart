import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gun_dart/gun.dart';
import 'package:gun_dart/types.dart';

import 'components/editable_title.dart';

/// A custom app bar with a title that can be edited
///
/// The title is stored in the Gun node passed in the constructor
/// and is updated in real time. A [StreamBuilder] is used to only
/// rebuild the text widget when the title changes.
/// See the [StatusIndicator] widget for a example with a stateful widget.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// The Gun node where the title is stored
  final Gun titleNode;
  final StreamController<String> _titleController = StreamController<String>();

  CustomAppBar({
    Key? key,
    required this.titleNode,
  }) : super(key: key) {
    // At the widget creation, we create a listener on the Gun node
    // and we push every new title to a dart stream
    titleNode.on((data, key) {
      if (data is String) {
        _titleController.add(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      // We use a stream builder to rebuild only the title and not the whole app bar
      title: StreamBuilder(
        stream: _titleController.stream,
        builder: (context, snapshot) => EditableTitle(
          title: snapshot.data ?? 'No title',
          // When the title is edited, we save it in the Gun node
          onChange: titleNode.put,
        ),
      ),
      actions: [
        StatusIndicator(node: titleNode),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// A widget that displays the status of the connection to a Gun peer
///
/// This widget is stateful because it stores the status of the connection
/// in its state. setState() is called when the connection status changes
/// and the widget is rebuilt.
class StatusIndicator extends StatefulWidget {
  final Gun node;

  const StatusIndicator({Key? key, required this.node}) : super(key: key);

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> {
  bool? _connected;
  String? _url;

  @override
  void initState() {
    super.initState();

    // We also listen to the connection status
    final peers = widget.node.peers();

    // If no peers where passed to the Gun constructor,
    // the boolean is null
    if (peers.isNotEmpty) {
      final peer = peers.first;
      setState(() {
        _connected = peer.wire?.readyState == 1;
        _url = peer.url;
      });

      peer.wire?.onOpen.listen((_) {
        print('Connected to Gun peer: ${peer.url}');
        setState(() {
          _connected = true;
        });
      });

      peer.wire?.onClose.listen((_) {
        print('Disconnected from Gun peer: ${peer.url}');
        setState(() {
          _connected = false;
        });
      });

      peer.wire?.onError.listen((event) {
        print('Error with Gun peer: ${peer.url}');
        log(event);
        setState(() {
          _connected = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connected == null) {
      return const SizedBox.shrink();
    }

    final color = _connected! ? Colors.green : Colors.red;
    final icon = _connected! ? Icons.cloud_done : Icons.cloud_off;

    return Tooltip(
      message: _url,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(icon, color: color),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EditableTitle extends StatefulWidget {
  final String title;
  final Function(String) onChange;
  final TextStyle? style;

  const EditableTitle({
    Key? key,
    required this.title,
    required this.onChange,
    this.style,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditableTitleState createState() => _EditableTitleState();
}

class _EditableTitleState extends State<EditableTitle> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isEditing ? _buildEditing(context) : _buildTitle(context);
  }

  Widget _buildTitle(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        children: [
          const SizedBox(width: 40),
          Text(
            widget.title,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            iconSize: 15,
            hoverColor: Colors.transparent,
            onPressed: () {
              setState(() {
                _controller.text = widget.title;
                _isEditing = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditing(BuildContext context) {
    return IntrinsicWidth(
      child: TextField(
        controller: _controller,
        autofocus: true,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
        ),
        onSubmitted: (value) {
          setState(() {
            _isEditing = false;
          });
          widget.onChange(value);
        },
      ),
    );
  }
}

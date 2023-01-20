import 'package:flutter/material.dart';

class PlayedImg extends StatelessWidget {
  const PlayedImg({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      color: Colors.indigo,
      alignment: Alignment.center,
      child: const Text(
        'Audio Player',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    );
  }
}

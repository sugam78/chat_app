import 'package:flutter/material.dart';

class ReusuableButton extends StatelessWidget {
  String title;
  bool loading;
  final VoidCallback onTap;
  ReusuableButton(
      {super.key,
        required this.title,
        required this.onTap,
        this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.purpleAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
            color: Colors.white,
          )
              : Text(title),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WhereAreYouGoingButton extends StatelessWidget {
  const WhereAreYouGoingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 35,
      left: 20,
      right: 20,
      child: SafeArea(
        child: CupertinoButton(
          onPressed: () {},
          padding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'A donde quieres ir',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

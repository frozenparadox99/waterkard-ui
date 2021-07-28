import 'package:flutter/material.dart';

Future<String> successMessageDialogue({BuildContext context, Widget child}){
  return showDialog(context: context,
      barrierDismissible: false,
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: child
              ),
            ),
          ),
        );
      });
}
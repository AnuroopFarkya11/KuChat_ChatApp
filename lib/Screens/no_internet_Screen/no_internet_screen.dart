import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:kuchat/Services/internet_manager/internet_manager.dart';
import 'package:kuchat/Widgets/snack_bar.dart';
import '../../Widgets/custom_elevated_button.dart';
import 'dart:async';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  final InternetManager _internetManager = InternetManager();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/kuuuu/boring.png",
          height: 200,
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Turn on your internet connection.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: KuButton(
            onPressed: () async {
              isLoading = true;
              setState(() {});
              Timer(const Duration(seconds: 1), ()  {
                _internetManager.checkInternetSourceStatus(context);
              });
            },
            buttonText: "Try again!",
            isLoading: isLoading,
          ),
        )
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:kuchat/Widgets/appbar.dart';
import 'package:kuchat/Widgets/kudrawer.dart';
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: KuDrawer(),
      body: CustomScrollView(
        slivers: [
          KuAppBar(kuTitle: "Help", kuPath: "flowers.png")
        ],
      ),
    );
  }
}

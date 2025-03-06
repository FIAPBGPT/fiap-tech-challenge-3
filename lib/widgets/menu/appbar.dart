import 'package:bytebank/widgets/menu/drawer.dart';
import 'package:flutter/material.dart';

class AppBarComponent extends StatelessWidget {
  const AppBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "",
                  textAlign: TextAlign.center,
                ),
                const Icon(
                  Icons.account_circle_outlined,
                  size: 35,
                ),
              ],
            ),
          ),
          drawer: DrawerComponent()),
    );
  }
}

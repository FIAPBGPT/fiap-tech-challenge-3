import 'package:bytebank/routes.dart';
import 'package:bytebank/utils/constants.dart';
import 'package:bytebank/widgets/menu/hover_menu.dart';
import 'package:flutter/material.dart';

class DrawerComponent extends StatelessWidget {
  const DrawerComponent({super.key});

  Widget _navigateLink(String label, void Function() onTap) {
    return HoverMenu(
      label: label,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 225,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  color: AppConstants.baseBackgroundBytebank,
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _navigateLink(
                            "Início",
                            () => Navigator.of(context)
                                .pushReplacementNamed(Routes.home)),
                        _navigateLink(
                            "Transações",
                            () => Navigator.of(context)
                                .pushReplacementNamed(Routes.transactions)),
                        _navigateLink(
                            "Investimentos",
                            () => Navigator.of(context)
                                .pushReplacementNamed(Routes.investments)),
                        _navigateLink(
                            "Outros serviços",
                            () => Navigator.of(context)
                                .pushReplacementNamed(Routes.outros)),
                      ],
                    ),
                  )),
            ),
          ]),
    );
  }
}

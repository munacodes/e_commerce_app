import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_app/provider/providerExports.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    ProductProvider productProvider = Provider.of<ProductProvider>(context);
    return badges.Badge(
      badgeAnimation: const badges.BadgeAnimation.fade(),
      position: badges.BadgePosition.bottomEnd(bottom: 25, end: 5),
      badgeContent: Text(
        productProvider.getNotificationIndex.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      badgeStyle: const badges.BadgeStyle(
        badgeColor: Colors.red,
      ),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.notifications_none,
          color: Colors.black,
        ),
      ),
    );
  }
}

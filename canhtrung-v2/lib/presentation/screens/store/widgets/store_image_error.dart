import 'package:flutter/material.dart';

class StoreImageError extends StatelessWidget {
  const StoreImageError({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo/logo_store.png',
      scale: 3,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mapa_1/src/ui/page/splash/splash_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class SplasPage extends StatefulWidget {
  const SplasPage({Key? key}) : super(key: key);

  @override
  State<SplasPage> createState() => _SplasPageState();
}

class _SplasPageState extends State<SplasPage> {
  final _controller = SplashController(Permission.locationWhenInUse);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.checkPermission();
    });
    _controller.addListener(() {
      if (_controller.routeName != null) {
        Navigator.pushReplacementNamed(context, _controller.routeName!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

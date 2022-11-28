import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapa_1/src/ui/page/request_permission/request_permission_controller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../route/route.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({Key? key}) : super(key: key);

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage>
    with WidgetsBindingObserver {
  final _controller = RequestPermissionController(Permission.locationWhenInUse);
  late StreamSubscription _subscription;
  bool _formSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.onStatusChanged.listen((status) {
      switch (status) {
        case PermissionStatus.granted:
          _goToHome();
          break;
        case PermissionStatus.permanentlyDenied:
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('Info'),
                    content:
                        const Text('Ingresar para dar permisos manualmente'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          _formSettings = await openAppSettings();
                        },
                        child: const Text('Go to settings'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      )
                    ],
                  ));
          break;
        case PermissionStatus.denied:
          break;
        case PermissionStatus.restricted:
          break;
        case PermissionStatus.limited:
          break;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _formSettings) {
      final status = await _controller.check();
      if (status == PermissionStatus.granted) {
        _goToHome();
      }
    }
    _formSettings = false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.pushReplacementNamed(context, Routes.HOME);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: ElevatedButton(
            child: const Text('Allow'),
            onPressed: () {
              _controller.request();
            },
          ),
        ),
      ),
    );
  }
}

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:signova/core/data/user.dart';
import 'package:signova/core/routing/app_router.dart';
import 'package:signova/core/routing/routes.dart';
import 'package:sizer/sizer.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await User().load();
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => SafeArea(
        top: false,
        child: MaterialApp(
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          title: 'Signova',
          initialRoute: Routes.splashScreen,
          theme: ThemeData(fontFamily: 'inter'),
          onGenerateRoute: appRouter.generateRoute,
        ),
      ),
    );
  }
}

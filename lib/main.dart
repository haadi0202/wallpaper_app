//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:wallpaper_app/business_logic/picture.dart';
import 'package:wallpaper_app/business_logic/shared.dart';
import 'package:wallpaper_app/presentation/category_page.dart';
import 'package:wallpaper_app/presentation/main_page.dart';
import 'package:wallpaper_app/presentation/scroll_page.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  Hive.registerAdapter(PictureAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  var appDir = await getApplicationDocumentsDirectory().toString();
  await Hive.initFlutter(appDir);
  var box = await Hive.openBox('box');

  if (box.isNotEmpty) {
    likedpictures = box.get("key").cast<Picture>();
  }

  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //initialRoute: "/categoryPage",
      routes: {
        "/": (context) => MainPage(),
        "/scrollPage": (context) => ScrollPage(),
        "/categoryPage": (context) => CategoryPage()
      },
    );
  }
}

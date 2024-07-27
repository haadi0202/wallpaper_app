//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallpaper_app/presentation/catogaries_page.dart';
import 'package:wallpaper_app/presentation/home_page.dart';
import 'package:wallpaper_app/presentation/liked_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
            elevation: 1,
            backgroundColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            height: 70,
            destinations: [
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.house,
                      size: 20,
                      color:
                          (currentPageIndex == 0) ? Colors.pink : Colors.grey),
                  label: ""),
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.boxesStacked,
                      size: 20,
                      color:
                          (currentPageIndex == 1) ? Colors.pink : Colors.grey),
                  label: ""),
              NavigationDestination(
                  icon: FaIcon(FontAwesomeIcons.solidHeart,
                      size: 20,
                      color:
                          (currentPageIndex == 2) ? Colors.pink : Colors.grey),
                  label: "")
            ],
            selectedIndex: currentPageIndex,
            onDestinationSelected: (index) => setState(() {
                  currentPageIndex = index;
                })),
        body: SafeArea(
            child: [
          HomPage(),
          CatogariesPage(),
          LikedPage()
        ][currentPageIndex]));
  }
}

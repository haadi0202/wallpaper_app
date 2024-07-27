//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:wallpaper_app/business_logic/picture.dart';
import 'package:wallpaper_app/business_logic/shared.dart';
import 'package:http/http.dart' as http;

int loadingNumber = 2;

class ScrollPage extends StatefulWidget {
  const ScrollPage({super.key});

  @override
  State<ScrollPage> createState() => ScrollPageState();
}

class ScrollPageState extends State<ScrollPage> {
  PageController controller = PageController();
  int _currentPage = 0;

  ScrollPageState();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onPageChanged);
    controller.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    int newPage = controller.page?.round() ?? 0;
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
      // Perform your functionality here
      if ((_currentPage + 1) % loadingNumber == 0) {
        loadRest(_currentPage + 1);
      }
    }
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPage == 0) {
      loadRest(_currentPage);
    }
    return SafeArea(
        child: PageView(
      scrollDirection: Axis.vertical,
      controller: controller,
      children: pictures
          .map((element) =>
              post(picture: element, refresh: refresh, context: context))
          .toList(),
    ));
  }

  void loadRest(int start) async {
    if (start + (loadingNumber + loadingNumber) < pictures.length) {
      for (var i = start + loadingNumber;
          i < start + loadingNumber + loadingNumber;
          i++) {
        if (mounted) {
          await precacheImage(NetworkImage(pictures[i].large), context);
        }
      }
    }
  }
}

Widget post(
    {required Picture picture,
    required Function refresh,
    required BuildContext context}) {
  return Container(
    color: hexToColor(picture.avgColor),
    child: Stack(alignment: Alignment.bottomCenter, children: [
      Positioned.fill(child: Image.network(picture.large, fit: BoxFit.cover)),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //download
            ElevatedButton(
                style: ButtonStyle(
                    elevation: WidgetStatePropertyAll(20),
                    shape: WidgetStatePropertyAll(CircleBorder()),
                    backgroundColor: WidgetStatePropertyAll(Colors.pink)),
                onPressed: () {
                  downloadSnackBar(context: context, message: "downloading...");
                },
                child: Icon(Icons.download, color: Colors.white)),
            //set as wallpaper
            ElevatedButton(
                style: ButtonStyle(
                    elevation: WidgetStatePropertyAll(20),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(46))),
                    backgroundColor: WidgetStatePropertyAll(Colors.pink)),
                onPressed: () {
                  bottomSheet(context: context, picture: picture);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text("SET AS", style: TextStyle(color: Colors.white)),
                )),
            //like
            ElevatedButton(
                style: ButtonStyle(
                    elevation: WidgetStatePropertyAll(20),
                    shape: WidgetStatePropertyAll(CircleBorder()),
                    backgroundColor: WidgetStatePropertyAll(Colors.white)),
                onPressed: () async {
                  if (!isLiked(picture: picture)) {
                    addToLiked(picture: picture);
                    var box = await Hive.openBox("box");
                    box.put("key", likedpictures);
                  } else {
                    removeFromLiked(picture: picture);
                    var box = await Hive.openBox("box");
                    box.put("key", likedpictures);
                  }
                  refresh();
                },
                child: FaIcon(
                    (!isLiked(picture: picture))
                        ? FontAwesomeIcons.heart
                        : FontAwesomeIcons.solidHeart,
                    color: Colors.pink)),
          ],
        ),
      ),
      Positioned(
          top: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.white,
                  size: 26,
                )),
          ))
    ]),
  );
}

void bottomSheet(
    {required BuildContext context, required Picture picture}) async {
  String imageUrl = 'https://example.com/your_image.jpg';
  var filePath;

  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //home screen
              GestureDetector(
                onTap: () async {},
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FaIcon(
                      FontAwesomeIcons.house,
                      color: Colors.pink,
                    ),
                  ),
                  Text("Set to home screen")
                ]),
              ),
              Divider(color: Colors.grey),
              //lock screen
              GestureDetector(
                onTap: () async {},
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FaIcon(
                      FontAwesomeIcons.lock,
                      color: Colors.pink,
                    ),
                  ),
                  Text("Set to lock screen")
                ]),
              ),
              Divider(color: Colors.grey),
              //set to both
              GestureDetector(
                onTap: () async {},
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FaIcon(
                      FontAwesomeIcons.paintRoller,
                      color: Colors.pink,
                    ),
                  ),
                  Text("Set to both")
                ]),
              )
            ],
          ),
        );
      });
}

void downloadSnackBar(
    {required BuildContext context, required String message}) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 50,
          color: Colors.white,
          child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(message),
              )),
        );
      });
}

bool isLiked({required Picture picture}) {
  bool flag = false;
  for (var i = 0; i < likedpictures.length; i++) {
    if (likedpictures[i].id == picture.id) {
      flag = true;
      break;
    }
  }
  return flag;
}

void removeFromLiked({required Picture picture}) {
  for (var i = 0; i < likedpictures.length; i++) {
    if (likedpictures[i].id == picture.id) {
      likedpictures.remove(likedpictures[i]);
      break;
    }
  }
}

void addToLiked({required Picture picture}) {
  likedpictures.insert(0, picture);
}

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('FF');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wallpaper_app/business_logic/shared.dart';

late bool isLoaded;

class LikedPage extends StatefulWidget {
  const LikedPage({super.key});

  @override
  State<LikedPage> createState() => HomePageState();
}

class HomePageState extends State<LikedPage> {
  HomePageState() {
    loadImages(refresh: refresh);
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check the condition and show the Snackbar if true
    if (isNetWorkError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showGlobalSnackbar(context, 'Check Internet Connectivity!');
      });
    }
    //initialize binary set list
    binarySetList = initializeBinarySetList(list: pictures);
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //topBar
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Icon(Icons.menu, color: Colors.grey),
                Text("Liked",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black)),
                Padding(padding: EdgeInsets.all(10))
              ]),

              feed(context: context, isLoaded: isLoaded)
            ]));
  }
}

List<BinarySet<T>> initializeBinarySetList<T>({required List<T> list}) {
  List<BinarySet<T>> returnList = [];
  for (var i = 0; i < list.length - 1; i = i + 2) {
    returnList.add(BinarySet(val1: list[i], val2: list[i + 1]));
  }
  return returnList;
}

void loadImages({required refresh, String? query}) async {
  isLoaded = false;
  pictures = likedpictures;
  isLoaded = true;
  refresh();
}

//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:wallpaper_app/business_logic/picture.dart';
import 'package:flutter/material.dart';

List<Picture> pictures = [];
List<Picture> likedpictures = [];

bool isNetWorkError = false;

void showGlobalSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.pink,
      content: Text(message),
    ),
  );
}

List<BinarySet<Picture>> binarySetList = [];

class BinarySet<T> {
  late T val1;
  late T val2;
  BinarySet({required this.val1, required this.val2});
}

void sortMainList(int id) {
  for (var i = 0; i < pictures.length; i++) {
    if (pictures[i].id == id) {
      List<Picture> second = pictures.sublist(i, pictures.length).toList();
      List<Picture> first = pictures.sublist(0, i).toList();
      pictures = [...second, ...first];
    }
  }
}

List<BinarySet<T>> initializeBinarySetList<T>({required List<T> list}) {
  List<BinarySet<T>> returnList = [];
  for (var i = 0; i < list.length - 1; i = i + 2) {
    returnList.add(BinarySet(val1: list[i], val2: list[i + 1]));
  }
  return returnList;
}

Widget feed({required BuildContext context, required bool isLoaded}) {
  return (isLoaded)
      ? Expanded(
          child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 9 / 16,
              children: pictures
                  .map((element) =>
                      listTitleCustom(picture: element, context: context))
                  .toList()),
        )
      : Expanded(
          child: Column(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  color: Colors.pink,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text("loading", style: TextStyle(color: Colors.white)),
                  )),
            ],
          ),
        );
}

Widget listTitleCustom(
    {required Picture picture, required BuildContext context}) {
  return GestureDetector(
    onTap: () {
      sortMainList(picture.id);
      Navigator.pushNamed(context, "/scrollPage");
    },
    child: Card(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(picture.smallUrl, fit: BoxFit.cover)),
    ),
  );
}

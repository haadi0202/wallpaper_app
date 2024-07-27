//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallpaper_app/business_logic/api_handeling.dart';
import 'package:wallpaper_app/business_logic/shared.dart';
import 'package:wallpaper_app/presentation/catogaries_page.dart';

late bool isLoaded;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => CategoryPageState();
}

class CategoryPageState extends State<CategoryPage> {
  CategoryPageState();
  @override
  void initState() {
    super.initState();
    loadImages(refresh: refresh, context: context, query: selectedCategory);
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isNetWorkError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showGlobalSnackbar(context, 'Check Internet Connectivity!');
      });
    }
    binarySetList = initializeBinarySetList(list: pictures);
    return SafeArea(
        child: Container(
      color: selectedColor,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: FaIcon(FontAwesomeIcons.arrowLeft,
                              color: Colors.white)),
                      Text(selectedCategory.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                              decoration: TextDecoration.none)),
                      Padding(padding: EdgeInsets.all(10))
                    ]),
              ),
              //feed
              feed(context: context, isLoaded: isLoaded)
            ],
          )),
    ));
  }
}

void loadImages(
    {required refresh, String? query, required BuildContext context}) async {
  isLoaded = false;
  pictures = await getImages(query: query);
  isLoaded = true;
  refresh();
}

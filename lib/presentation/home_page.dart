//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:wallpaper_app/business_logic/shared.dart';
import 'package:wallpaper_app/business_logic/api_handeling.dart';

int currentTabIndex = 0;
late bool isLoaded;
late bool isSearchFocused;
late FocusNode myFocusNode;
TextEditingController controller = TextEditingController();

class HomPage extends StatefulWidget {
  const HomPage({super.key});

  @override
  State<HomPage> createState() => HomePageState();
}

class HomePageState extends State<HomPage> {
  HomePageState() {
    loadImages(refresh: refresh);
    isSearchFocused = false;
    myFocusNode = FocusNode();
  }

  void refresh() {
    setState(() {});
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
              (!isSearchFocused)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Icon(Icons.menu, color: Colors.grey),
                          Text("Wallpaper",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSearchFocused = true;
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Future.delayed(Duration(milliseconds: 100),
                                        () {
                                      FocusScope.of(context)
                                          .requestFocus(myFocusNode);
                                    });
                                  });
                                });
                              },
                              child: Icon(Icons.search, color: Colors.grey))
                        ])
                  //alternate
                  : GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 250,
                            child: TextField(
                              controller: controller,
                              focusNode: myFocusNode,
                              onSubmitted: (value) {
                                setState(() {
                                  String query = controller.text;
                                  loadImages(refresh: refresh, query: query);
                                });
                              },
                              onTapOutside: (event) {
                                if (controller.text == "") {
                                  setState(() {
                                    isSearchFocused = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.pink, width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))),
                                  hintText: "search",
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40))),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 15)),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  String query = controller.text;
                                  loadImages(refresh: refresh, query: query);
                                });
                              },
                              child: Icon(Icons.search, color: Colors.grey))
                        ],
                      ),
                    ),
              //space
              // Container(
              //   height: 15,
              // ),
              //bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              loadImages(refresh: refresh);
                              currentTabIndex = 0;
                            });
                          },
                          child: Text("NATURE",
                              style: TextStyle(
                                  color: currentTabIndex != 0
                                      ? Colors.grey
                                      : Colors.pink,
                                  fontWeight: FontWeight.bold))),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              loadImages(refresh: refresh, query: "pixel Art");
                              currentTabIndex = 1;
                            });
                          },
                          child: Text("PIXEL ART",
                              style: TextStyle(
                                  color: currentTabIndex != 1
                                      ? Colors.grey
                                      : Colors.pink,
                                  fontWeight: FontWeight.bold))),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              loadImages(
                                  refresh: refresh, query: "photography");
                              currentTabIndex = 2;
                            });
                          },
                          child: Text("CAPTURES",
                              style: TextStyle(
                                  color: currentTabIndex != 2
                                      ? Colors.grey
                                      : Colors.pink,
                                  fontWeight: FontWeight.bold)))
                    ]),
              ),

              feed(context: context, isLoaded: isLoaded)
            ]));
  }
}

void loadImages({required refresh, String? query}) async {
  isLoaded = false;
  pictures = await getImages(query: query);
  isLoaded = true;
  refresh();
}

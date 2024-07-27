//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

late String selectedCategory;
late Color selectedColor;

class CatogariesPage extends StatefulWidget {
  const CatogariesPage({super.key});

  @override
  State<CatogariesPage> createState() => CatogariesSPagetate();
}

class CatogariesSPagetate extends State<CatogariesPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //topBar
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Icon(Icons.menu, color: Colors.grey),
              Text("Categories",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              Padding(padding: EdgeInsets.all(10))
            ]),
            //grid
            Expanded(
              child: GridView.count(
                  childAspectRatio: 1.2,
                  crossAxisCount: 2,
                  children: categories
                      .map((element) => categoryTile(category: element))
                      .toList()),
            )
          ],
        ));
  }

  Widget categoryTile({required Category category}) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        child: GestureDetector(
          onTap: () {
            selectedCategory = category.label;
            selectedColor = category.color;
            Navigator.pushNamed(context, "/categoryPage");
          },
          child: Card(
            color: category.color,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(category.label,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ));
  }
}

class Category {
  late String label;
  late Color color;
  Category({required this.label, required this.color});
}

List<Category> categories = [
  Category(label: "Food", color: Colors.pink),
  Category(label: "Cars", color: Colors.brown),
  Category(label: "Tech", color: Colors.blue),
  Category(label: "Sports", color: Colors.deepOrange),
  Category(label: "Beach", color: Colors.black),
  Category(label: "Rular", color: Colors.deepPurple),
  Category(label: "Music", color: Colors.green),
  Category(label: "Movies", color: Colors.red),
  Category(label: "Travel", color: Colors.teal),
  Category(label: "Study", color: Colors.indigo),
  Category(label: "Health", color: Colors.amber),
  Category(label: "Nature", color: Colors.lightGreen),
  Category(label: "Games", color: Colors.cyan),
  Category(label: "Art", color: Colors.orange),
];

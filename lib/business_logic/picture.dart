import 'package:hive/hive.dart';

part 'picture.g.dart';

@HiveType(typeId: 1)
class Picture {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late int width;

  @HiveField(2)
  late int height;

  @HiveField(3)
  late String photographer;

  @HiveField(4)
  late String url;

  @HiveField(5)
  late String smallUrl;

  @HiveField(6)
  late String large;

  @HiveField(7)
  late String avgColor;

  @HiveField(8)
  bool liked = false;

  Picture({
    required this.id,
    required this.width,
    required this.height,
    required this.photographer,
    required this.url,
    required this.smallUrl,
    required this.large,
    required this.avgColor,
  });

  @override
  String toString() => "$id $url";
}

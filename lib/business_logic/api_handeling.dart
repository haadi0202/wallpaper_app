//ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart';
import 'package:retry/retry.dart';
import 'package:wallpaper_app/business_logic/picture.dart';
import 'package:wallpaper_app/business_logic/shared.dart';

Future<List<Picture>> getImages({String? query}) async {
  String apiKey = "qkfQOHIlddSQ0ARn29Vcp6dKPYWU6q46HuY1rhoIOzmaOZarXXHVQVD6";
  String orientation = "portrait";
  String size = "medium";
  int min = 1;
  int max = 100;
  int page = min + Random().nextInt(max - min + 1);
  int perPage = 100;

  final r = RetryOptions(
    maxAttempts: 3,
    delayFactor: Duration(seconds: 2),
  );
  try {
    final response = await r.retry(
      () => get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=${query ?? 'nature'}&orientation=$orientation&size=$size&per_page=$perPage&page=$page"),
        headers: {'Authorization': apiKey},
      ).timeout(Duration(seconds: 10)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load images: ${response.statusCode}');
    }

    Map<String, dynamic> map = jsonDecode(response.body);
    List<Map<String, dynamic>> picturesInMapFormat =
        List<Map<String, dynamic>>.from(map["photos"]);
    List<Picture> pictures = picturesInMapFormat
        .map((element) => mapToPicture(pictureInMapFormat: element))
        .toList();

    return pictures;
  } catch (e) {
    // Handle error (e.g., show a snackbar, alert dialog, etc.)
    isNetWorkError = true;
    return [];
  } finally {
    if (pictures.isNotEmpty) {
      isNetWorkError = false;
    }
  }
}

Picture mapToPicture({required Map<String, dynamic> pictureInMapFormat}) {
  return Picture(
      id: pictureInMapFormat["id"],
      width: pictureInMapFormat["width"],
      height: pictureInMapFormat["height"],
      photographer: pictureInMapFormat["photographer"],
      avgColor: pictureInMapFormat["avg_color"],
      url: pictureInMapFormat["src"]["original"],
      smallUrl: pictureInMapFormat["src"]["medium"],
      large: pictureInMapFormat["src"]["large2x"]);
}

void main() {
  getImages(query: "technology");
}

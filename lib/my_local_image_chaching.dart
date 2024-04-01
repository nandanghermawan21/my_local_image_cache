library my_local_image_chaching;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class LocalImageCache extends StatelessWidget {
  final String imageUrl;
  final String folderName = "local_image_cache";
  final String name;
  final double height;
  final double width;
  final BoxDecoration? decoration;

  const LocalImageCache({
    super.key,
    required this.name,
    this.height = 100,
    this.width = 100,
    this.imageUrl =
        "https://enerren.com/wp-content/uploads/2016/04/logo-enerren.png",
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: decoration,
      child: FutureBuilder(
        future: saveAndLoadImage(imageUrl, folderName, name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Image.file(
              snapshot.data!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                color: Colors.grey,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  //buat function untuk mengecek apakah gambar sudah ada di dalam file
  //jika sudah ada maka tampilkan gambar tersebut
  //jika belum ada maka download gambar tersebut dan simpan ke dalam file
  //lalu tampilkan gambar tersebut
  Future<File> saveAndLoadImage(
      String imageUrl, String folderName, String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final folder = Directory('$path/$folderName');
    if (!folder.existsSync()) {
      folder.createSync();
    }
    final file = File('${folder.path}/$name');
    if (file.existsSync()) {
      return file;
    } else {
      final response = await http.get(Uri.parse(imageUrl));
      await file.writeAsBytes(response.bodyBytes);
      return file;
    }
  }

  //buat function untuk menghapus gambar dari
  static Future<void> deleteImage(String folderName, String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final folder = Directory('$path/$folderName');
    if (folder.existsSync()) {
      final file = File('${folder.path}/$name');
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
  }

  //buat function untuk menghapus semua gambar dari folder
  static Future<void> deleteAllImage(String folderName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final folder = Directory('$path/$folderName');
    if (folder.existsSync()) {
      folder.deleteSync(recursive: true);
    }
  }
}

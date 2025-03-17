import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
class Reciptscanner extends StatefulWidget {
  const Reciptscanner({super.key});

  @override
  State<Reciptscanner> createState() => _ReciptscannerState();
}

class _ReciptscannerState extends State<Reciptscanner> {
  File? _image;
  String _ocrText = "";
  // Wybierz zdjęcie z galerii
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() async {
        _image = File(pickedFile.path);
        _image = await preprocessImage(_image!);
      });
      _performOCR();
      print(_ocrText);
    }
  }
  Future<File> preprocessImage(File imageFile) async {
    // Załaduj obraz z pliku
    img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;

    // Konwersja na odcienie szarości
    img.Image grayscaleImage = img.grayscale(image);

    // Zapisz przetworzony obraz
    File processedFile = File('processed_image.png')
      ..writeAsBytesSync(img.encodePng(grayscaleImage));

    return processedFile;
  }
  // Wykonaj OCR
  Future<void> _performOCR() async {
    print("start");
    if (_image == null) return;

    try {
      final text = await FlutterTesseractOcr.extractText(_image!.path,  language: 'pol');
      setState(() {
        _ocrText = text;
      });

      // Wyciąganie danych z rozpoznanego tekstu
      /*final parsedData = _parseReceiptData(_ocrText);
      print(parsedData);*/
    } catch (e) {
      print("Błąd OCR: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR Paragon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*if (_image != null)
              Image.file(_image!)*//*
            else
              Center(child: Text("Wybierz obraz paragonu")),*/

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Wybierz zdjęcie paragonu"),
            ),
            SizedBox(height: 20),
            if (_ocrText.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rozpoznany tekst: $_ocrText",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: 20),/*
                      Text(
                        "Produkty: ${_parseReceiptData(_ocrText)['products']}",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Suma paragonu: ${_parseReceiptData(_ocrText)['total_sum']}",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),*/
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

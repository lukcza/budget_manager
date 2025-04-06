import 'dart:io';
import 'package:budget_manager/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/enum/page_index.dart';

class ReceiptScanner extends StatefulWidget {
  const ReceiptScanner({super.key});

  @override
  State<ReceiptScanner> createState() => _ReceiptScannerState();
}

class _ReceiptScannerState extends State<ReceiptScanner> {
  String recognizedText = 'Zrób zdjęcie paragonu! 📸';
  PageIndex? pageIndex;
  //TODO dopracować ocr dzieli na bloki co oddziela sume od kwoty
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageIndex = PageIndex.receiptPhoto;
  }
  String extractTotalAmount(String text) {
    List<String> lines = text.split('\n');

    final RegExp keywordRegex = RegExp(
      r'(suma|razem|total|do zapłaty|kwota)',
      caseSensitive: false,
    );

    final RegExp amountRegex = RegExp(
      r'\d{1,5}[.,]\d{2}',
    );

    for (String line in lines) {
      if (keywordRegex.hasMatch(line)) {
        final Match? amountMatch = amountRegex.firstMatch(line);

        if (amountMatch != null) {
          return '${amountMatch.group(0)} zł';
        }
      }
    }

    final Match? fallbackAmount = amountRegex.firstMatch(text);
    if (fallbackAmount != null) {
      return '${fallbackAmount.group(0)} zł';
    }

    return 'Nie znaleziono sumy 😔';
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    final File imageFile = File(pickedFile.path);

    //final processedImage = await preprocessImage(imageFile);

    final inputImage = InputImage.fromFilePath(imageFile.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognized =
        await textRecognizer.processImage(inputImage);

    print(recognized.text);
    setState(() {
      recognizedText = extractTotalAmount(recognized.text);
    });

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skaner Paragonów 🧾')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              recognizedText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Zrób zdjęcie 📸'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(index: pageIndex!),
    );
  }
}

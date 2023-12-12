import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'pdf_screen.dart';
import '../../../style/color_guide.dart';
import '../../../style/text_style.dart';
import 'dart:io';

class CustomTextButtonForPDF extends StatelessWidget {
  final String url;
  final String fileName;

  const CustomTextButtonForPDF(
      {Key? key, required this.url, required this.fileName})
      : super(key: key);

  Future<File> _downloadFile(String url, String filename) async {
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/$filename');
    await file.writeAsBytes(response.data);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return
        Container(
          margin: const EdgeInsets.only(top:5, bottom: 25),
          child: Align(
            alignment: Alignment.center,
            child: GestureDetector(
            child: const Text(
            '자세한 행동요령 보기',
            style: TextStyle(color: primaryOrange, fontSize: 16),
            ),
            onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: FutureBuilder<File>(
                  future: _downloadFile(url, fileName),
                  builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 90, // Adjust to your need
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                color: primaryOrange,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Loading...',
                              style: kLoadingTextStyle,
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final file = snapshot.data!;
                      Future.delayed(Duration.zero, () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PDFScreen(key: const Key('pdfScreen'), path: file.path),
                          ),
                        );
                      });
                      return const SizedBox.shrink(); // Empty widget
                    }
                  },
                ),
              ),
            );
      },
    ),
          ),
        );
  }
}

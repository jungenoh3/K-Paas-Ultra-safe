import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';

class BoxContainer extends StatelessWidget {
  final String imageUrl;
  final String boxTitle;
  final String interpretataion;
  final Color colorForBox;

  const BoxContainer(
      {Key? key,
      required this.imageUrl,
      required this.boxTitle,
      required this.interpretataion,
      required this.colorForBox})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          width: double.infinity,
          padding: const EdgeInsets.only(top: 5),
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: lightGray2),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: colorForBox,
          ),
          alignment: Alignment.center,
          child: Text(boxTitle, style: kBoxContainerTitleTextStyle),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: lightGray2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15), // 색상
                  spreadRadius: 20, // 그림자 확산 거리
                  blurRadius: 100, // 그림자 흐림 정도
                  offset: const Offset(0, 3), // 그림자 위치
                )
              ]),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: FutureBuilder<File>(
                  future: DefaultCacheManager().getSingleFile(imageUrl),
                  builder:
                      (BuildContext context, AsyncSnapshot<File> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: primaryOrange);
                    } else if (snapshot.error != null) {
                      // Handle error
                      return const Icon(Icons.error);
                    } else if (snapshot.data != null) {
                      return Image.file(snapshot.data!, fit: BoxFit.fill);
                    } else {
                      // Handle the case when data is null
                      return const Text('No data');
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              Align(
                  alignment: Alignment.centerLeft, // Left alignment
                  child: Text(
                    interpretataion,
                    style: const TextStyle(fontSize: 18),
                  ))
            ],
          ),
        ),
      ],
    );
  }
}

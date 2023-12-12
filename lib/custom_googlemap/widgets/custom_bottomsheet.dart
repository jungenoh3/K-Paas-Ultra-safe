import 'package:eqms_test/api/google_map_model.dart';
import 'package:eqms_test/api/sse.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheets {
  static void showItemBottomSheet(BuildContext context, int mode, String bottomTitle,
      SensorSSE? sensorSSE, String? name, String location,) {

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              color: Colors.white,
            ),
            height: 140,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 12, bottom: 2),
                  child: Text(
                    bottomTitle,
                    style: kCustomScrollableSheetTitleTextStyle,
                  ),
                ),
                Divider(color: Colors.grey[400], thickness: 0.5),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 2),
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    strutStyle: const StrutStyle(fontSize: 15.0),
                    text: TextSpan(
                        text: name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 2),
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    strutStyle: const StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        text: location,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 13)),
                  ),
                ),
                Visibility(
                  visible: mode == 1,
                  child: StreamBuilder(
                      stream: sensorSSE?.dataStream,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 13,
                                  height: 13,
                                  child: Text(
                                    "X: ",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  height: 13,
                                  child: Text(
                                    snapshot.data!['x'].toString(),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                const SizedBox(
                                  width: 13,
                                  height: 13,
                                  child: Text(
                                    "Y: ",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  height: 13,
                                  child: Text(
                                    snapshot.data!['y'].toString(),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                                const SizedBox(
                                  width: 13,
                                  height: 13,
                                  child: Text(
                                    "Z: ",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                SizedBox(
                                  width: 40,
                                  height: 13,
                                  child: Text(
                                    snapshot.data!['z'].toString(),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const Padding(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 13,
                                height: 13,
                                child: Text(
                                  "X: ",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                height: 13,
                                child: Text(
                                  "-",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              SizedBox(
                                width: 13,
                                height: 13,
                                child: Text(
                                  "Y: ",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                height: 13,
                                child: Text(
                                  "-",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              SizedBox(
                                width: 13,
                                height: 13,
                                child: Text(
                                  "Z: ",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                                height: 13,
                                child: Text(
                                  "-",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.2),
      // isScrollControlled: true,
      // useRootNavigator: false,
      useSafeArea: true,
    ).whenComplete(() {
      print("Modal BottomSheet close");
      if (mode == 1 && sensorSSE != null) {
        sensorSSE.stopListening();
      }
    });
  }
}

import 'package:eqms_test/api/google_map_model.dart';
import 'package:eqms_test/custom_googlemap/models/google_maps_models.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:eqms_test/widgets/common_widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CustomScrollableSheet extends StatelessWidget {
  final List<ScrollableSheetData> sheetItems;
  final String sheetTitle;
  final String iconAsset;

  const CustomScrollableSheet(
      {Key? key,
      required this.sheetItems,
      required this.sheetTitle,
      required this.iconAsset})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // 이걸 변수로 받아오게 설정
    // final itemValue = context.watch<GoogleMapModel>();

    return Visibility(
      visible: sheetItems.isNotEmpty,
      maintainState: false,
      child: DraggableScrollableSheet(
          initialChildSize: 0.11,
          minChildSize: 0.05,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: ListView.separated(
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemCount: sheetItems.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = sheetItems[index];
                  if (index == 0) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(iconAsset),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                sheetTitle,
                                style: kCustomScrollableSheetTitleTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 15),
                      leading: data.leading == null
                          ? null
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data.leading!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                      title: Text(data.title),
                      subtitle: Text(
                        data.subtitle,
                        maxLines: 2,
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      trailing: data.trailing == null
                          ? IconButton(onPressed: () {alertMessage('추가 예정입니다.');}, icon: Icon(Icons.double_arrow))
                          : Text(
                              data.trailing!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                      dense: false,
                      isThreeLine: false,
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}

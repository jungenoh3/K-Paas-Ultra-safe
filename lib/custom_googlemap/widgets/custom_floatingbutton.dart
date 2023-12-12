import 'package:eqms_test/api/google_map_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eqms_test/style/color_guide.dart';

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onMoveCamera;
  const CustomFloatingButton({required this.onMoveCamera, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      FloatingActionButton(
        heroTag: 'tag1',
        mini: true,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(side: const BorderSide(width: 2,color: primaryNewOrange),borderRadius: BorderRadius.circular(100)),
        elevation: 3,
        onPressed: () {
          onMoveCamera();
        },
        child: const Icon(Icons.location_pin, color: primaryNewOrange,),
      ),
      const SizedBox(
        height: 5,
      ),
      // FloatingActionButton(
      //   heroTag: 'tag2',
      //   mini: true,
      //   backgroundColor: Colors.white,
      //   shape: RoundedRectangleBorder(side: const BorderSide(width: 2,color: primaryNewOrange),borderRadius: BorderRadius.circular(100)),
      //   elevation: 3,
      //   child: const Icon(Icons.refresh, color: primaryNewOrange,),
      //   onPressed: () {},
      //   // onPressed: () {
      //   //   switch (context.read<GoogleMapModel>().sheetTitle) {
      //   //     case "내 주변 대피소":
      //   //       context.read<GoogleMapModel>().ShelterItems();
      //   //       break;
      //   //     case "최근 발생 지진":
      //   //       context.read<GoogleMapModel>().EarthQuakeItems();
      //   //       break;
      //   //     case "센서":
      //   //       context.read<GoogleMapModel>().SensorItems();
      //   //       break;
      //   //     default:
      //   //       break;
      //   //   }
      //   // },
      // ),
    ]);
  }
}

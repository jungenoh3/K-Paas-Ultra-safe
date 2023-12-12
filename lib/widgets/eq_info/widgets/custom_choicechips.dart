import 'package:eqms_test/api/google_map_model.dart';
import 'package:eqms_test/style/color_guide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';



class CustomCategory extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int?> onSelected;

  const CustomCategory({
    required this.selectedIndex,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  List<Widget> choiceChips() {
    List<Widget> chips = [];
    for (int i = 0; i < _choiceChipsList.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 2.5, right: 2.5),
        child: ChoiceChip(
          label: Row(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  selectedIndex == i ? Colors.white : primaryDark,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(
                  _choiceChipsList[i].iconPath,
                  width: 20,
                  height: 20,
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Text(_choiceChipsList[i].label),
            ],
          ),
          backgroundColor: Colors.white,
          selected: selectedIndex == i,
          selectedColor: primaryNewOrange,
          labelStyle: TextStyle(
            color: selectedIndex == i ? Colors.white : Colors.black,
          ),
          onSelected: (bool selected) {
            onSelected(selected ? i : null);
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: choiceChips(),
        ),
      ),
    );
  }
}


// class CustomCategory extends StatefulWidget {
//   const CustomCategory({super.key});
//
//   @override
//   State<CustomCategory> createState() => _CustomCategoryState();
// }
//
// class _CustomCategoryState extends State<CustomCategory> {
//   int? _selectedIndex;
//   bool isSelected = false;
//
//   List<Widget> choiceChips() {
//     List<Widget> chips = [];
//     for (int i = 0; i < _choiceChipsList.length; i++) {
//       Widget item = Padding(
//         padding: const EdgeInsets.only(left: 2.5, right: 2.5),
//         child: ChoiceChip(
//           label: Row(
//             children: [
//               ColorFiltered(
//                 colorFilter: ColorFilter.mode(
//                     _selectedIndex == i ? Colors.white : primaryDark,
//                     BlendMode.srcIn),
//                 child: SvgPicture.asset(_choiceChipsList[i].iconPath,
//                     width: 20, height: 20),
//               ),
//               const SizedBox(
//                 width: 7,
//               ),
//               Text(_choiceChipsList[i].label),
//             ],
//           ),
//           backgroundColor: Colors.white,
//           selected: _selectedIndex == i,
//           selectedColor: primaryNewOrange,
//           labelStyle: TextStyle(
//             color: _selectedIndex == i ? Colors.white : Colors.black,
//           ),
//           onSelected: (bool selected) async {
//             setState(() {
//               _selectedIndex = selected ? i : null;
//             });
//             _handleSelection(_selectedIndex);
//           },
//         ),
//       );
//       chips.add(item);
//     }
//     return chips;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: choiceChips(),
//         ),
//       ),
//     );
//   }
//
//   void _handleSelection(int? selectedIndex) {
//     final mapModel = context.read<GoogleMapModel>();
//
//     switch (_selectedIndex) {
//       case null:
//       case 0:
//         mapModel.EarthQuakeItems();
//         break;
//       case 1:
//         print('mapModel.ShelterItems();');
//         mapModel.ShelterItems();
//         break;
//       case 2:
//         print('mapModel.EmergencyInstItems();');
//         mapModel.EmergencyInstItems();
//       default:
//         mapModel.RemoveItems();
//         break;
//     }
//   }
// }

class ChipData {
  String label;
  String iconPath;

  ChipData(this.label, this.iconPath);
}

final List<ChipData> _choiceChipsList = [
  ChipData("지진 정보", "assets/earthquake.svg"),
  ChipData("내 주변 대피소", "assets/shelter.svg"),
  ChipData("응급시설", "assets/emergeInst.svg")
];

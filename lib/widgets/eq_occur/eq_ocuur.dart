import 'package:eqms_test/widgets/root_screen.dart';
import 'package:eqms_test/style/color_guide.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:flutter/material.dart';


class EqOccur extends StatefulWidget {
  final Map<String, dynamic>? messageData;
  const EqOccur({Key? key, required this.messageData}) : super(key: key);

  @override
  State<EqOccur> createState() => _EqOccurState();
}

class _EqOccurState extends State<EqOccur> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primaryOrange,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/siren.gif',height: screenHeight * 0.1),
                const SizedBox(height: 10),
                Text(
                  '${widget.messageData?['date']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                RichText(
                  text: const TextSpan(
                    style: kEqOccurTextStyle,
                    children: <TextSpan>[
                      TextSpan(text: '추정 규모 '),
                      TextSpan(
                        text: 'N',
                        style: kEqOccurMagnituteTextStyle,
                      ),
                    ],
                  ),
                ),
                const Text(
                  '지진 발생!',
                  style: kEqOccurTextStyle,
                ),
                Text(
                  '임의 위치: (${widget.messageData?['lat']}, ${widget.messageData?['lng']})',
                  // '대구 북구 대학로 80길 15KM (임의 주소)', // 여기에 위도 경도
                  style: kEqOccurLocationTextStyle,
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex:3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('images/Drop.png',fit: BoxFit.cover),
                        Text('숙이고!',style: kEqOccurOrderTextStyle)
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  Expanded(
                    flex:3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('images/Cover.png',fit: BoxFit.cover),
                        Text('보호하고!',style: kEqOccurOrderTextStyle)
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  Expanded(
                    flex:3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('images/HoldOn.png', fit:BoxFit.cover),
                        Text('지탱하세요!',style: kEqOccurOrderTextStyle)
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(primaryOrange),
                          elevation: MaterialStateProperty.all<double>(0),
                          minimumSize: MaterialStateProperty.all<Size>(const Size(
                              double.infinity,
                              50)), // Width will be as wide as possible within the container
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  horizontal: 5)), // Horizontal padding
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => RootScreen()),
                                (route) => false,
                          );
                        },
                        child: const Text('지진 안전 정보', style: kButtonTextStyle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

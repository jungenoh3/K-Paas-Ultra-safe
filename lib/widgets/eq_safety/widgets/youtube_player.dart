import 'package:cached_network_image/cached_network_image.dart';
import 'package:eqms_test/style/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeModel {
  final int id;
  final String youtubeId;

  const YoutubeModel({required this.id, required this.youtubeId});
}


class YoutubePlayerDemo extends StatefulWidget {
  YoutubePlayerDemo({Key? key,}) : super(key: key);

  @override
  _YoutubePlayerDemoState createState() => _YoutubePlayerDemoState();
}

class _YoutubePlayerDemoState extends State<YoutubePlayerDemo> {
  late YoutubePlayerController _ytbPlayerController;
  List<YoutubeModel> videosList = [
    YoutubeModel(id: 1, youtubeId: 'kdkcKESgRaU'),
    YoutubeModel(id: 2, youtubeId: 'QRVofqxkm5I'),
    YoutubeModel(id: 3, youtubeId: '5p4r8hBPfuY'),
    YoutubeModel(id: 4, youtubeId: 'pp5dZguIVj8'),
    // YoutubeModel(id: 5, youtubeId: 'qoDPvFAk2Vg'),
  ];

  @override
  void initState() {
    super.initState();

    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _ytbPlayerController = YoutubePlayerController(
      params: YoutubePlayerParams(
        showFullscreenButton: true,
      ),
    );
    _ytbPlayerController.loadVideoById(videoId: videosList[0].youtubeId);

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   setState(() {
    //
    //   });
    // });
  }

  @override
  void dispose() {
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _ytbPlayerController.close();
    super.dispose();
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지진안전영상', style: kAppBarTitleTextStyle),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildYtbView(),
            _buildMoreVideoTitle(),
            _buildMoreVideosView(),
          ],
        ),
      ),
    );
  }

  _buildYtbView() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: _ytbPlayerController != null
          ? YoutubePlayer(controller: _ytbPlayerController)
          : Center(child: CircularProgressIndicator()),
    );
  }

  _buildMoreVideoTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 182, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "추가 영상",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  _buildMoreVideosView() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
            itemCount: videosList.length,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final _newCode = videosList[index].youtubeId;
                  _ytbPlayerController.stopVideo();
                  _ytbPlayerController.loadVideoById(videoId: _newCode);
                  // _ytbPlayerController.load(_newCode);
                  // _ytbPlayerController.stop();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 4,
                  margin: EdgeInsets.symmetric(vertical: 7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Positioned(
                          child: CachedNetworkImage(
                            imageUrl:
                            "https://img.youtube.com/vi/${videosList[index].youtubeId}/0.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(Icons.arrow_circle_right_rounded)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
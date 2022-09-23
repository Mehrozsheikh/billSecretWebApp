import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatbill/utils/color_constant.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:wakelock/wakelock.dart';

class CustomVideoPlayer extends StatefulWidget {
  String url;
  CustomVideoPlayer({required this.url});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  String url = '';
  String convertUrlToId(String url, {bool trimWhitespaces = true}) {
    String _url;
    if (!url.contains('http') && (url.length == 11)) return url;
    if (trimWhitespaces) {
      _url = url.trim();
    } else {
      _url = url;
    }
    for (final exp in [
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(
          r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$'),
      RegExp(r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$')
    ]) {
      final RegExpMatch? match = exp.firstMatch(_url);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }

    return '';
  }

  _initiateVideoController() async {
    final extractor = YoutubeExplode();
    if (convertUrlToId(widget.url).isNotEmpty) {
      final videoId = convertUrlToId(widget.url);
      final streamManifest =
          await extractor.videos.streams.getManifest(videoId);
      final streamInfo = streamManifest.muxed.sortByVideoQuality();
      extractor.close();
      url = streamInfo.first.url.toString();
    } else {
      url = widget.url;
    }
    _videoPlayerController = VideoPlayerController.network(
      url,
    );
    _androidController = ChewieController(
      placeholder: Center(
        child: CircularProgressIndicator(),
      ),
      autoInitialize: true,
      showControlsOnInitialize: false,
      allowPlaybackSpeedChanging: false,
      allowMuting: true,
      allowedScreenSleep: false,
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      aspectRatio: 16 / 9,
    );

    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _videoPlayerController!.play();
    });
  }

  VideoPlayerController? _videoPlayerController;
  ChewieController? _androidController;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions();

  @override
  void initState() {
    _initiateVideoController();
    Wakelock.enable();

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _androidController?.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            dispose();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "App Explanation",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColor.kprimeryColor,
      ),
      body: Center(
        child: Container(
            height: 300,
            color: Colors.white,
            child: _androidController != null
                ? Chewie(controller: _androidController!)
                : Center(child: CircularProgressIndicator())),
      ),
    );
  }
}

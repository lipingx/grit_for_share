import 'package:flutter/material.dart';
import 'package:grit/bloc/home_bloc.dart';
import 'package:grit/bloc/user_bloc.dart';
import 'package:grit/pages/home/side_drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:grit/models/chewie_list_item.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:dospace/dospace.dart' as dospace;
//import 'package:flutter_amazon_s3/flutter_amazon_s3.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatefulWidget {
  final HomeBloc homeBloc;
  final VoidCallback onSignedOut;
  final String userId;
  final UserBloc userBloc;

//  final RecordBloc recordBloc;
//  final LabelBloc labelBloc;
  const HomePage({this.homeBloc, this.userBloc, this.onSignedOut, this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _selectedImage;
  File _test_video;
  FlutterVideoCompress _flutterVideoCompress = FlutterVideoCompress();
  Uint8List _imageThumbnail;
  File _thumbnailFile;
  File _compressed_video_file;
  Subscription _subscription;
  bool _doneUploadImage;
  bool _doneUploadVideo;
  String _uploadVideo_key;

  @override
  void initState() {
    super.initState();
    _subscription =
        _flutterVideoCompress.compressProgress$.subscribe((progress) {
      print('progress: $progress');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask A Question'),
      ),
      body: _buildBody(),
      drawer: SideDrawer(
          homeBloc: widget.homeBloc,
          userId: widget.userId,
          onSignedOut: widget.onSignedOut),
//      floatingActionButton: FloatingActionButton(
//        onPressed: uploadImage,
//        tooltip: 'Pick Image',
//        child: Icon(Icons.add_a_photo),
//      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Text(
              'Ask a question by uploading an image.',
              style: TextStyle(fontSize: 17.0),
            )),
        //RaisedButton(onPressed: uploadImage, child: new Text('uploadImage')),
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: uploadImage,
          tooltip: 'Pick Image',
          iconSize: 50,
        ),

//        Container(
//            child: CachedNetworkImage(
//          imageUrl: "http://via.placeholder.com/350x150",
//          //imageUrl: "http://pqg5dw4fg.bkt.clouddn.com/1556171863637.png",
//          placeholder: (context, url) => new CircularProgressIndicator(),
//          errorWidget: (context, url, error) => new Icon(Icons.error),
//        )),
        Container(
            child: _selectedImage == null
                ? Container()
                : Image.file(
                    _selectedImage,
                    scale: 0.5,
                    width: 200,
                    height: 200,
                  )),

        Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Text('Answer the question by uploading a video.',
                style: TextStyle(fontSize: 17.0))),
//        RaisedButton(onPressed: uploadVideo, child: new Text('uploadVideo'),
//        color: Colors.lightBlue[300], padding: Padding(child: EdgeInsets.all(20),),),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 130),
          child: RaisedButton(
            child: const Text('Upload Video'),
            color: Theme.of(context).accentColor,
            elevation: 4.0,
            splashColor: Colors.blueGrey,
            onPressed: uploadVideo,
            //padding:  EdgeInsets.,
          ),
        ),
//        Padding(
//          padding: EdgeInsets.all(15.0),
//          child: LinearPercentIndicator(
//            width: 140.0,
//            lineHeight: 14.0,
//            percent: 0.5,
//            center: Text(
//              "50.0%",
//              style: new TextStyle(fontSize: 12.0),
//            ),
//            trailing: Icon(Icons.mood),
//            linearStrokeCap: LinearStrokeCap.roundAll,
//            backgroundColor: Colors.grey,
//            progressColor: Colors.blue,
//          ),
//        ),
//        Container(
//            child: _thumbnailFile == null
//                ? Container()
//                : Image.file(
//                    _thumbnailFile,
//                    scale: 0.5,
//                    width: 100,
//                    height: 100,
//                  )),

//        _compressed_video_file == null
//            ? Container()
//            : ChewieListItem(
//                videoPlayerController: VideoPlayerController.file(
//                  _compressed_video_file,
//                ),
//                looping: true,
//              ),
        _doneUploadVideo == true
            ? Container(child: Text('Upload is done. This is the video you just uploaded.'))
            : Container(),

        //Container(child: Text('This is the video you just uploaded.'),),
        _doneUploadVideo == true
            ? ChewieListItem(
                videoPlayerController: VideoPlayerController.network(
                'https://grit.sgp1.digitaloceanspaces.com/${_uploadVideo_key}',
                //'https://grit.sgp1.digitaloceanspaces.com/selected_video_1559573443178.mp4',
              ))
            : Container(),
//        Container(child: Text('Test video'),),
//        ChewieListItem(
//            videoPlayerController: VideoPlayerController.network(
//          'https://grit.sgp1.digitaloceanspaces.com/selected_video_1559573443178.mp4',
//        )),
      ],
    );
  }

  Future uploadVideo() async {
    print('call getVideo');
    if (mounted) {
//      File file = await ImagePicker.pickVideo(source: ImageSource.camera);
      File file = await ImagePicker.pickVideo(source: ImageSource.gallery);
      var key =
          'selected_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      print('key $key');
      uploadFile(key, file, 'mp4');
      new Future.delayed(Duration.zero, () => setState(() {
        _compressed_video_file = file;
        _uploadVideo_key = key;
      }));

      return;

      if (file?.path != null) {
//        final thumbnail = await _flutterVideoCompress.getThumbnail(
//          file.path,
//          quality: 50,
//          position: -1,
//        );
//
//        setState(() {
//          _imageThumbnail = thumbnail;
//        });

        final resultFile = await _flutterVideoCompress.getThumbnailWithFile(
          file.path,
          quality: 50,
          position: -1,
        );
        print('getThumbnailWithFile,resultFile.path: ${resultFile.path}');

        assert(resultFile.existsSync());

        print('file Exists: ${resultFile.existsSync()}');
        setState(() {
          _thumbnailFile = resultFile;
        });

        final MediaInfo info = await _flutterVideoCompress.startCompress(
          file.path,
          quality: VideoQuality.HighestQuality,
          deleteOrigin: true,
        );
        print(info.toJson());
        setState(() {
          _compressed_video_file = info.file;
        });
        //uploadFile('compressed_video.mp4', info.file, 'video');
      }
    }
  }

  Future uploadImage() async {
    print('call getImage');
    var imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 300, maxWidth: 300);
    uploadFile('image.png', imageFile, 'png');
    new Future.delayed(Duration.zero, () => setState(() {
      _selectedImage = imageFile;
      _doneUploadImage = true;
    }));

//    final tempDir = await getTemporaryDirectory();
//    final path = tempDir.path;
//    int rand = new Math.Random().nextInt(10000);
//
//    print('Start to compress');
//    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
//    Im.Image smallerImage = Im.copyResize(image,
//        width: 120); // choose the size here, it will maintain aspect ratio
//
//    var jpgImage = new File('$path/img_$rand.jpg')
//      ..writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 100));
//    //uploadFile('image.jpg', jpgImage, 'jpg');
//    var pngImage = new File('$path/img_$rand.png')
//      ..writeAsBytesSync(Im.encodePng(smallerImage));
//    //uploadFile('image.png', pngImage, 'png');
//    var gifImage = new File('$path/img_$rand.gif')
//      ..writeAsBytesSync(Im.encodeGif(smallerImage));
//    //uploadFile('image.gif', gifImage, 'gif');
//    var tgaImage = new File('$path/img_$rand.tga')
//      ..writeAsBytesSync(Im.encodeTga(smallerImage));
//    uploadFile('image.tga', tgaImage, 'tga');
//
//    print('Done compress');
//    setState(() {
//      _selectedImage = gifImage;
//    });
  }

  Future uploadFile(String key, File file, String type) async {
    dospace.Spaces spaces = new dospace.Spaces(
      region: "sgp1",
      accessKey: "5BJYB5ETKBNE3MG5E2NU",
      secretKey: "vBAsBGxcMGzDA/+OsJDcQDdgSH79g/7NTkoKMRnrU6o",
    );
    print('Start to upload file');
    String etag = await spaces
        .bucket('grit')
        .uploadFile(key, file, type, dospace.Permissions.public);

    print('upload: $etag');
    new Future.delayed(Duration.zero, () => setState(() {
      _doneUploadVideo = true;
    }));

    print(_doneUploadVideo);
    await spaces.close();
  }

  Widget _buildBody2(File image) {
    var cachedImage = new CachedNetworkImage(
      imageUrl: "http://via.placeholder.com/350x150",
      //imageUrl: "http://pqg5dw4fg.bkt.clouddn.com/1556171863637.png",
      placeholder: (context, url) => new CircularProgressIndicator(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
    return Column(
      children: <Widget>[
        //Container(child: cachedImage),
        image == null ? Container() : Container(child: Image.file(image)),
      ],
    );
  }
}

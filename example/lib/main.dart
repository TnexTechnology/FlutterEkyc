import 'dart:math';

import 'package:flutter/material.dart';

import 'package:tnexekyc/ekyc_camera_view.dart';
import 'package:tnexekyc/tnexekyc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "My Demo Media Query",
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  String selectType = '';
  List<String> detectType = [];


  @override
  void initState() {
    super.initState();
    setState(() {
      detectType = ["blink_eye", "smile", "turn_right", "turn_left"];

      //detectType = randomListDetectType();
    });
  }


  String getTitle(String eventType) {
    switch (eventType) {
      case 'NO_PERMISSION':
        return 'Không có quyền';
      case 'FAILED':
        return 'Nhận diện lỗi';
      case 'LOST_FACE':
        return 'Khuôn mặt không tốt';
      case 'DETECTION_EMPTY':
        return 'Không có danh sách nhận diện';
      case 'MULTIPLE_FACE':
        return 'Nhiều khuôn mặt';
      case 'SUCCESS':
        return 'Nhận diện thành công';
      case 'FAKE_FACE':
        return 'Khuôn mặt ảo';
      case 'NO_FACE':
        return 'Không có khuôn mặt';
      default:
        return '';
    }
  }

  String getMss(String eventType) {
    switch (eventType) {
      case 'NO_PERMISSION':
        return 'Không có quyền truy cập bộ nhớ hoặc camera. Bạn vui lòng cấp quyền và thử lại';
      case 'FAILED':
        return 'Nhận diện khuôn mặt xảy ra lỗi, bạn vui lòng thử lại';
      case 'LOST_FACE':
        return 'Khuôn mặt của bạn có vấn đề, bạn vui lòng thử lại';
      case 'DETECTION_EMPTY':
        return 'Không có danh sách nhận diện, bạn vui lòng thử lại';
      case 'MULTIPLE_FACE':
        return 'Nhiều hơn 1 khuôn mặt. Bạn vui lòng chỉ giữ 1 khuôn mặt khi nhận diện';
      case 'SUCCESS':
        return 'Nhận diện thành công. Bạn có muốn thử lại';
      case 'FAKE_FACE':
        return 'Có vẻ đây không phải 1 khuôn mặt thật. Bạn vui lòng thử lại';
      case 'NO_FACE':
        return 'Không tìm thấy khuôn mặt của bạn. Bạn vui lòng thử lại';
      default:
        return '';
    }
  }

  void ekycResults(Map<dynamic, dynamic> map) {
    debugPrint("ekycEventBIENNT ekycResults Main $map");
    Tnexekyc.onStopEkyc();
    var eventType = map['eventType'];
    var title = getTitle(eventType);
    var mss = getMss(eventType);
    _showMyDialog(title, mss);
  }

  void ekycStartDetectType(String detectType){
    debugPrint("ekycEventBIENNT detectType $detectType");
    setState(() {
      selectType = detectType;
    });
  }

  Future<void> _showMyDialog(String title, String mess) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(mess)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Tnexekyc.onStartEkyc();
              },
            ),
          ],
        );
      },
    );
  }

  List<String> randomListDetectType(){
    List<String> detectType = ["turn_right", "blink_eye", "turn_left", "smile"];
    List<String> listType =[];
    Random random = Random();
    while(listType.length<4){
      int randomNumber = random.nextInt(4);
      String type = detectType[randomNumber];
      debugPrint('randomListDetectType randomNumber = $randomNumber type = $type');
      if (!listType.contains(type)){
        listType.add(type);
      }
    }

    debugPrint('randomListDetectType listType = $listType');

    return listType;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double hCamera = width;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(children: [
        SizedBox(
          width: width,
          height: 100,
          child: Row(children: [
            const Spacer(flex: 1,),
            Text(detectType[0], style: TextStyle(color: selectType == detectType[0] ? const Color(
                0xff00d178) : const Color(0xff000000)),),
            const Spacer(flex: 1,),
            Text(detectType[1], style: TextStyle(color: selectType == detectType[1] ? const Color(
                0xff00d178) : const Color(0xff000000)),),
            const Spacer(flex: 1,),
            Text(detectType[2], style: TextStyle(color: selectType == detectType[2] ? const Color(
                0xff00d178) : const Color(0xff000000)),),
            const Spacer(flex: 1,),
            Text(detectType[3], style: TextStyle(color: selectType == detectType[3] ? const Color(
                0xff00d178) : const Color(0xff000000)),),
            const Spacer(flex: 1,),
          ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),),
        Container(
          color: const Color(0xff000000),
          height: height,
          width: width,
          child: detectType.isEmpty ? null : CameraView(hCamera.round(), width.round(), detectType, ekycResults, ekycStartDetectType),
        ),
        const Expanded(child: SizedBox())
      ],),
    );
  }
}
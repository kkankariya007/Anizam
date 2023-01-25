import 'dart:async';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http_parser/http_parser.dart';

import 'package:permission_handler/permission_handler.dart';

void main()=>runApp(const MaterialApp(
  home:Anizam(),
),
);

bool _hasp=true;

class Anizam extends StatefulWidget {
  const Anizam({Key? key}) : super(key: key);

  @override
  State<Anizam> createState() => _AnizamState();
}

class _AnizamState extends State<Anizam> {
  @override
  void initState() {
    initRecorder();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    recorder.closeRecorder();
    // TODO: implement dispose
    super.dispose();
  }
  final recorder=FlutterSoundRecorder();
  Future initRecorder() async {
    final status=await Permission.microphone.request();
    // final status2=await Permission..request();

    if(status != PermissionStatus.granted){
      throw 'Permission not given';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: 'audio');
  }
  var file;
  Future stopRecord() async {
  final filePath= await recorder.stopRecorder();
  final file = File(filePath!);
  print('Recording file path: $file');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,

        title: const Text(
            'ANIZAM',
            style:TextStyle(
              fontSize: 32,
              color:Colors.white,
            ),
        ),

        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),

      body:
        Center(
        child:
        Container(decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
        Colors.black,
        Colors.deepPurple,
          ],
        ),
        ),

          child:Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                SizedBox(height: 190.0),

                Text(
                    'Tap to Anizam',
                    style:TextStyle(
                      color:Colors.white,
                      fontSize: 38,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.bold,
                    )
                ),

                SizedBox(height: 20.0),

            AvatarGlow(
             animate:!_hasp,
               glowColor: Colors.red,
             // glowColor: Theme.of(context).primaryColor,
              startDelay: const Duration(milliseconds: 0),
             endRadius: 150.0,
             duration: const Duration(milliseconds: 2500),
             repeatPauseDuration: const Duration(milliseconds:30),
             repeat: true,
             child:
                RawMaterialButton(

                  fillColor:_hasp?Colors.lightBlue:Colors.redAccent,
                  onPressed: () async {
                    if (recorder.isRecording){
                      await stopRecord();
                      setState(() {
                      });
                    }
                    else{
                      await startRecord();
                      setState(() {
                      });
                    }
                    setState(() {
                        _hasp=!_hasp;
                    });
                  },
                  elevation: 10.0,
                  child:
                  Icon( // <-- Icon
                    recorder.isRecording?Icons.stop:Icons.mic_none_outlined,
                    size: 100.0,
                    color:Colors.white,
                  ),
                  padding: EdgeInsets.all(30.0),
                  shape: CircleBorder(),
                ),
          ),
                SizedBox(height: 10),


                SizedBox(
                  height:40,
                  width:105,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 25,
                      // Background color
                    ),
                    onPressed:() {
                      // postdata();
                        //var req=
                        upload4();
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Predict()));

                    },
                    child:Text("Predict",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
        ),

      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
    );
  }
}

upload3() async{
  var request2;
  File ib=File('assets/voice1.wav'.toString());
  try {
    request2 = http.MultipartRequest(
        'POST', Uri.parse("https://anizam.up.railway.app/name/"))
      ..files.add(await http.MultipartFile.fromPath(
          'audio', ib.toString(),
          contentType: MediaType('audio', 'audio/wav')));
  }
  catch(e){
    print(e);
  }
  print(request2);

}
// upload2() async{
//   final uri = Uri.parse('https://myendpoint.com');
//   var request = new http.MultipartRequest('POST', uri);
//   final httpImage = http.MultipartFile.fromBytes('files.myimage', bytes,
//       contentType: MediaType.parse(mimeType), filename: 'myImage.png');
//   request.files.add(httpImage);
//   final response = await request.send();
// }
upload4() async{
  var request=await http.post(Uri.parse('https://anizam.up.railway.app/simple/?name=vs'),
  // headers:<String,String> {
  //   'accept': 'application/json'
  // },
  // body: {
  //   "name": "jd"
  // }
  );

print(request.body);
}

upload() async{
  try {
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://anizam.up.railway.app/name/"));
    var audio = await http.MultipartFile.fromBytes('audio',
        (await rootBundle.load('assets/voice1.wav')).buffer.asUint8List(),
        filename: 'voice1.wav',
        contentType: MediaType.parse('audio/wav')//'audio', 'wav')
    );


    request.files.add(audio);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);

    print(response);
    print("JHI");
    print(responseData);
    print("YO");
    print(result);
  }
  catch(e)
  {
    print(e);
  }

}

class Predict extends StatefulWidget {
  const Predict({Key? key}) : super(key: key);

  @override
  State<Predict> createState() => _PredictState();
}

class _PredictState extends State<Predict> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        title: const Text(
          'ANIZAM',
          style:TextStyle(
            fontSize: 32,
            color:Colors.black,
          ),
        ),

        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body:
      Center(
      child:
      Text("Hello"),
      ),
    );
  }
}

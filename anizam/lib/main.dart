import 'dart:async';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
// import 'dart:html' as html;

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

  String filePath='';
  final recorder=FlutterSoundRecorder();
  Future initRecorder() async {
    filePath = '/storage/emulated/0/Download/Anizam/temp.wav';

    final status=await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    // final status2=await Permission..request();

    if(status != PermissionStatus.granted){
      throw 'Permission not given';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    Directory dir = Directory(path.dirname(filePath));
    if (!dir.existsSync()) {
      dir.createSync();
    }
    await recorder.startRecorder(toFile: filePath,codec: Codec.pcm16WAV);
  }
  var file;
  Future stopRecord() async {
  final fdd= await recorder.stopRecorder();
  // final file = File(fdd!);
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
            Container(decoration: const BoxDecoration(
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

                const SizedBox(height: 190.0),

                const Text(
                    'Tap to Anizam',
                    style:TextStyle(
                      color:Colors.white,
                      fontSize: 38,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.bold,
                    )
                ),

                const SizedBox(height: 20.0),

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
                    padding: const EdgeInsets.all(30.0),
                    shape: const CircleBorder(),
                    ),
                      ),
                const SizedBox(height: 10),


                SizedBox(
                  height:40,
                  width:105,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 25,
                      // Background color
                    ),
                    onPressed:() async {
                        showDialog(
                        context: context,
                        builder: (context){
                          return const Center(child: CircularProgressIndicator());
                        },
                      );
                        await upload();
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Predict()));
                        setState(() {
                          _hasp=true;
                        });
                    },
                    child:const Text("Predict",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    ),
                  ),
                ),
                SizedBox(height:35),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      // color: Colors.grey.withOpacity(0.10),
                        borderRadius: BorderRadius.all(Radius.circular(7))
                    ),
                    // color: Colors.white.withOpacity(0.3),
                    padding: EdgeInsets.all(10.0),
                    child:
                    Text("Examples\n1. If You Win You Live If You Lose You Die If You Dont Fight You Can t Win"
                        "\n2. If You Don’t Like your destiny don’t accept it, Instead have the courage to change it the way you want it to be",
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    height: 1.4,
                  )
                    ),
                  ),
                ),

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


String charac="",anime="";
Future upload() async{

  try {
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://anizam.up.railway.app/name/"));
    var audio = await http.MultipartFile.fromBytes('file',
        await File.fromUri(Uri.parse("/storage/emulated/0/Download/Anizam/temp.wav")).readAsBytes(),
        filename: 'temp.wav',
        contentType: MediaType.parse('audio/wav')//'audio', 'wav')
    );


    request.files.add(audio);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);

    String predict=result.toString();
    int idx=predict.indexOf('":"');
    charac=predict.substring(2,idx);
    anime=predict.substring(idx+3,predict.length-2);

  }
  catch(e)
  {
    // print(e);
  }
  // _hasp=true;

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
            color:Colors.white,
          ),
        ),

        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body:
      Center(
        child:
        Container(decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.black,
              Colors.deepPurple,
            ],
          ),
        ),
          child: Center(
            child: Text(charac+"\n\n"+anime,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
            ),
          ),
        ),
      ),




      extendBodyBehindAppBar: true,

      );
  }
}

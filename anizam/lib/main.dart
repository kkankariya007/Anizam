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

                const SizedBox(height: 170.0),

                const Text(
                    'Tap to Anizam',
                    style:TextStyle(
                      color:Colors.white,
                      fontSize: 38,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.bold,
                    )
                ),

                const SizedBox(height: 10.0),

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
                SizedBox(height:55),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      // color: Colors.grey.withOpacity(0.10),
                        borderRadius: BorderRadius.all(Radius.circular(7))
                    ),
                    // color: Colors.white.withOpacity(0.3),
                    padding: EdgeInsets.all(10.0),
                    child:
                    Column(
                      children: [
                        Text("Examples : \n1. If You Win You Live If You Lose You Die."
                            "\n2. If You Don’t Like your destiny don’t accept it, Instead have the courage to change it.",
                  style:TextStyle(
                        color: Colors.white,
                        fontSize: 14.2,
                        height: 1.5,
                  )
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.4),
                            ),
                          onPressed:() async{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Examples()));
                          },
                              child:
                          Text("More Examples ->"),
                          ),
                        ),
                      ],
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
class Examples extends StatelessWidget {
  const Examples({Key? key}) : super(key: key);

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
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.black,
              Colors.deepPurple,
            ],
          ),
        ),

              child: Column(
                children: [
                  SizedBox(height:AppBar().preferredSize.height+kToolbarHeight),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.20),
                        borderRadius: BorderRadius.all(Radius.circular(7))
                    ),
                    width: MediaQuery.of(context).size.width,
                      child: Text("More Examples...\n\n"
                          "1. If you don’t take risks you can’t create a future\n\n"
                        "2. People become stronger because they have memories they can’t forget\n\n"
                        "3. The ticket to the future is always open\n\n"
                        "4. There are some flowers you only see when you take detours\n\n"
                        "5. If you re gonna hit it, hit it until it breaks",
                        style: const TextStyle(
                          fontSize: 21,
                          // fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          height: 1.4,
                          color: Colors.white,
                        ),
                      ),
                  ),
                ],
              ),
        ),
      ),
      extendBodyBehindAppBar: true,
    );
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
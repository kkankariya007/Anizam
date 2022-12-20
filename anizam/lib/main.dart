import 'dart:async';

import 'package:flutter/material.dart';

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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // leading: Icon(
        //   Icons.menu,
        //   size:40,
        // ),
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
          ],),),
          child:Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                SizedBox(height: 210.0),

                Text(
                    'Tap to Anizam',
                    style:TextStyle(
                      color:Colors.white,
                      fontSize: 38,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.bold,
                    )
                ),

                SizedBox(height: 100.0),

                RawMaterialButton(
                  onPressed: () => {
                    setState(() {
                      Timer(Duration(milliseconds:100), () {
                        _hasp=!_hasp;
                      });
                    })
                  },
                  fillColor:_hasp?Colors.lightBlue:Colors.redAccent,
                  elevation: 10.0,
                  child: Icon( // <-- Icon
                    Icons.mic_none_outlined,
                    size: 100.0,
                    color:Colors.white,
                  ),
                  padding: EdgeInsets.all(30.0),
                  shape: CircleBorder(),
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

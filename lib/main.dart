import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rogerapp/model/signaldata.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Roger'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _ws = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.18:3030/rtc')
  ).stream.listen((event) {
    Map<String, dynamic> signalDataMap = jsonDecode(event);
    var signalData = SignalData.fromJson(signalDataMap);
  
    print(event);
    if (signalData.type == SignalType.Welcome) {
      print(signalData.data);
    }
  });

  final int maxBroadcastDuration = 5 * 1000;

  bool _isBroadcasting = false;
  int _elapsedBroadcastingTime = 0;
  Timer? _timer;

  _updateTimer() {
    if (_isBroadcasting) {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_elapsedBroadcastingTime >= maxBroadcastDuration) {
          _stopBroadcast();
          return;
        }

        setState(() {
          _elapsedBroadcastingTime += 100;
        });
      });
    } else {
      _timer?.cancel();
      _elapsedBroadcastingTime = 0;
    }
  }

  void _startBroadcast() {
    setState(() {
      _isBroadcasting = true;
      _updateTimer();
    });
  }

  void _stopBroadcast() {
    setState(() {
      _isBroadcasting = false;
      _updateTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            GestureDetector(
              onTapDown: (details) {
                _startBroadcast();
              },
              onTapUp: (details) {
                _stopBroadcast();
              },
              onTapCancel: () {
                _stopBroadcast();
              },
              child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(minWidth: 250, maxWidth: 250),
                  // Change button text when light changes state.
                  child: Container(
                      color: Colors.yellow.shade600,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isBroadcasting
                                ? Icons.mic_none_outlined
                                : Icons.mic_off_outlined,
                            color: _isBroadcasting
                                ? Colors.red.shade600
                                : Colors.black,
                            size: 60,
                          ),
                          Text(_isBroadcasting ? 'Release to end' : 'Push To Talk'),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                              child: LinearProgressIndicator(
                                value: _elapsedBroadcastingTime /
                                    maxBroadcastDuration,
                                semanticsLabel: 'Broadcast time',
                              ))
                        ],
                      ))),
            ),
          ],
        ),
      ),
      // floatingActionButton:
      // FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // )
      // , // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

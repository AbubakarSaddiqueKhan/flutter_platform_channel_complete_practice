import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberPageStreamDesign extends StatefulWidget {
  const NumberPageStreamDesign({super.key});

  @override
  State<NumberPageStreamDesign> createState() => _NumberPageStreamDesignState();
}

class _NumberPageStreamDesignState extends State<NumberPageStreamDesign> {
  String eventData = "No Event Received";

  int number = 0;
  static const EventChannel eventChannel =
      EventChannel("number_stream_event_channel");

  // Stream<int> get numbers {
  //   return eventChannel.receiveBroadcastStream().map(
  //     (event) {
  //       number = event as int;
  //       return event;
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Number Page Design"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              eventData,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
                onPressed: () {
                  eventChannel.receiveBroadcastStream().listen((event) {
                    setState(() {
                      eventData = "Received Event : $event";
                    });
                  });
                },
                child: const Text("Start Stream"))
          ],
        ),
      ),
    );
  }
}

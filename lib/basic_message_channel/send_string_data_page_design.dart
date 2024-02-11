import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SendStringDataPageDesign extends StatefulWidget {
  const SendStringDataPageDesign({super.key});

  @override
  State<SendStringDataPageDesign> createState() =>
      _SendStringDataPageDesignState();
}

class _SendStringDataPageDesignState extends State<SendStringDataPageDesign> {
  String message = "Oops !! No Data";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
              onPressed: () async {
                print("Entered to send data");
// The first type of the  platform channel is message channel that is used to communicate between native and dart with message's in basic data types .

// A named channel for communicating with platform plugins using asynchronous message passing .

// Must give the template type to the basic message channel same as the data type you are going to communicate between native and flutter .
                BasicMessageChannel<String> basicMessageChannel =
// The logical channel on which communication happens, not null .

                    const BasicMessageChannel<String>(
                        "basicMessageChannelName",
                        //  The message codec used by this channel, not null.
                        StringCodec());

                String? result = await basicMessageChannel
                    .send("Assalam O Alaikum from Flutter");

                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Result : $result")));

                basicMessageChannel.setMessageHandler((message) async {
                  setState(() {
                    this.message = message ?? 'No message received';
                  });
                  print(
                      'Message received from android to flutter is : $message');
                  return 'Message received from android to flutter is : $message';
                });
                print("Left after send data");
              },
              child: const Text("Send String data")),
        ],
      )),
    );
  }
}

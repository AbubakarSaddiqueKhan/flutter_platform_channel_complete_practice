import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ToastPageDesign extends StatefulWidget {
  const ToastPageDesign({super.key});

  @override
  State<ToastPageDesign> createState() => _ToastPageDesignState();
}

class _ToastPageDesignState extends State<ToastPageDesign> {
  String data = "";
  static const MethodChannel methodChannel = MethodChannel("medium_article");

  Future<void> showToast() async {
    print("show toast process started");
    try {
      String result = await methodChannel.invokeMethod(
          "show_toast", {"data": "Assalam O Alaikum from Flutter"});
      setState(() {
        data = result;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Result : $result")));
    } on PlatformException catch (e) {
      print("Exception is : $e");
    } catch (e) {
      print("Error is : $e");
      print(e);
    }
    print("show toast process ended");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toast Page Design"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  showToast();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Data : $data")));
                },
                child: const Text("Show Toast"))
          ],
        ),
      ),
    );
  }
}

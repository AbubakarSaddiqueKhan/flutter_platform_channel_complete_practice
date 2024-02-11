import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryPageDesign extends StatefulWidget {
  const BatteryPageDesign({super.key});

  @override
  State<BatteryPageDesign> createState() => _BatteryPageDesignState();
}

class _BatteryPageDesignState extends State<BatteryPageDesign> {
  static const MethodChannel methodChannel = MethodChannel("medium_article");

  String batteryLevel = "";

  Future<void> getBatteryLevel() async {
    print("Enter to fetch battery level");
    String level;

    try {
      final int result = await methodChannel.invokeMethod("getBatteryLevel");
      level = "Battery Level : $result";
    } on PlatformException catch (e) {
      level = "Failed to get battery level";
      print("Failed to get battery level");
    } catch (e) {
      level = "Error is : ${e.toString()}";
      print("Error is : ${e.toString()}");
    }
    setState(() {
      batteryLevel = level;
    });
    print("Battery level is fetched successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Battery Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              batteryLevel,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
                onPressed: () {
                  getBatteryLevel();
                },
                child: const Text("Fetch Battery Data"))
          ],
        ),
      ),
    );
  }
}

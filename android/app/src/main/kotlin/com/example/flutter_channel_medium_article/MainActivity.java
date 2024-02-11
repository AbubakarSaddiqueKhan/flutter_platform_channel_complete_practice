package com.example.flutter_channel_medium_article;


import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;

import android.os.HandlerThread;
import android.os.Looper;
import android.widget.Toast;

import androidx.annotation.NonNull;

import java.sql.Time;
import java.util.HashMap;
import java.util.Timer;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StringCodec;

//package com.example.flutter_channel_medium_article
//
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity()
public class MainActivity extends FlutterActivity {




    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "medium_article")
                .setMethodCallHandler(
                        (call, result) -> {
                             if (call.method.equals("getBatteryLevel")) {
                                int batteryLevel = getBatteryLevel();
                                if (batteryLevel != -1) {
                                    result.success(batteryLevel);
                                } else {
                                    result.error("UNAVAILABLE", "Battery level not available.", null);
                                }
                            } else if(call.method.equals("show_toast")){
                                
                                 //                    The data must be send or received by the Key value pair
                                 //                    or in the form of map
                                 HashMap<String,String> resultMap = (HashMap<String, String>) call.arguments;
                                 //               message is the key name that we sent from the flutter
                                 String message = resultMap.get("data");
                                 Toast.makeText(MainActivity.this, message, Toast.LENGTH_SHORT).show();
//                    now we use th map to send data to the flutter in the form of key value pair
                                //  HashMap<String,String> map = new HashMap<>();
                                //  map.put("result" , "Assalam O Alaikum from java android to dart flutter");
                                 result.success("Assalam O Alaikum from java android to dart flutter");
                                 
                             }

                             else {
                                result.notImplemented();
                            }
                        }
                );



        class CustomStreamHandler implements EventChannel.StreamHandler {
            private final HandlerThread handlerThread = new HandlerThread("EventChannelHandler");
            private final Handler handler;
            private boolean isListening = false;
            private int counter = 0;

            CustomStreamHandler() {
                handlerThread.start();
                handler = new Handler(handlerThread.getLooper());
            }

            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                if (events != null) {
                    isListening = true;
                    handler.post(new Runnable() {
                        @Override
                        public void run() {
                            while (isListening) {
                                try {
                                    Thread.sleep(1000); // Delay for 1 second
                                } catch (InterruptedException e) {
                                    e.printStackTrace();
                                }

                                final int value = counter++;
                                // Switch back to main thread to send events
                                new Handler(Looper.getMainLooper()).post(new Runnable() {
                                    @Override
                                    public void run() {
                                        events.success(value);
                                    }
                                });
                            }
                        }
                    });
                }
            }

            @Override
            public void onCancel(Object arguments) {
                isListening = false;
            }

            // Clean up resources when no longer needed
            void dispose() {
                handlerThread.quitSafely();
            }
        }


//        class CustomStreamHandler implements EventChannel.StreamHandler {
//
//            private  boolean isListening = false;
//            private int currentNumber = 0;
//
//
//
//
//            @Override
//            public void onListen(Object arguments, EventChannel.EventSink events) {
//                System.out.println("Stream Start Listening");
//                int i;
//
//                for ( i = 0 ; i<= 100 ; i++){
//                    final Handler handler = new Handler();
//                    int finalI = i;
//                    handler.postDelayed(new Runnable() {
//                        @Override
//                        public void run() {
//                            // Do something after 1s = 5000ms
//
//                            events.success(finalI);
//
//
//                        }
//                    }, 1000);
//
//                }
//
//                System.out.println("Stream Start Completed");
//
//
//
//            }
//
//            @Override
//            public void onCancel(Object arguments) {
//                System.out.println("Stream Listening Canceled");
//            }
//        }

        EventChannel eventChannel = new EventChannel(
                flutterEngine.getDartExecutor(),
                "number_stream_event_channel");

        CustomStreamHandler customStreamHandler = new CustomStreamHandler();

        eventChannel.setStreamHandler(customStreamHandler);


        BasicMessageChannel<String> basicMessageChannel = new BasicMessageChannel<>(
        flutterEngine.getDartExecutor().getBinaryMessenger(),
                "basicMessageChannelName",
                StringCodec.INSTANCE
        );

        basicMessageChannel.setMessageHandler((message, reply) -> {
            Log.d("Tag","The data received from flutter is : " + message);
            System.out.println("The data received from flutter is : " + message);
            reply.reply("Assalam O Alaikum From Java Android");
        });





    }

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }
}

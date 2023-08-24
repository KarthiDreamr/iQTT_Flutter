import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:math';
import 'global_variable.dart';
import 'board1_page.dart';
import 'board2_page.dart';
import 'board3_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iQTT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 69, 137, 225)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MqttServerClient? client;
  String broker = '10.1.76.75';
  int port = 1883;
  List<String> topics = ['iqkct/b1/stat', 'iqkct/b2/stat', 'iqkct/b3/stat'];

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() async {
    var random = Random();
    var number = random.nextInt(1000000000);
    client = MqttServerClient.withPort(broker, 'ClientID_$number', port);
    if (client == null) {
      return;
    }
    client!.logging(on: true);

    try {
      await client!.connect('iqube', 'iQube@2023');
      setState(() {
        mqttStatus[0] = 'Connected to the broker';
      });

      client!.subscribe('iqkct/b1/stat', MqttQos.atMostOnce);
      client!.subscribe('iqkct/b2/stat', MqttQos.atMostOnce);
      client!.subscribe('iqkct/b3/stat', MqttQos.atMostOnce);
      client!.updates!
          .listen((List<MqttReceivedMessage<MqttMessage?>> messages) {
        final MqttPublishMessage message =
            messages[0].payload as MqttPublishMessage;
        final String payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        // print('Received Message : $payload');
        String topic = payload[6];
        // print(topic);
        String data = payload.substring(9).split(':').join('');
        // print(data);
        setState(() {
          if (topic == '1') {
            mqttStatus[1] = '$topic $data';
          } else if (topic == '2') {
            mqttStatus[2] = '$topic $data';
          } else if (topic == '3') {
            mqttStatus[3] = '$topic $data';
          }
        });
      });
    } catch (e) {
      setState(() {
        mqttStatus[0] = 'Error connecting: $e';
      });
    }
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    client!.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  @override
  void dispose() {
    client?.disconnect();
    super.dispose();
  }

  Widget customButton(int boardNumber, Size size) {
    Widget targetPage;

    switch (boardNumber) {
      case 1:
        targetPage = const Board1Page();
        break;
      case 2:
        targetPage = const Board2Page();
        break;
      case 3:
        targetPage = const Board3Page();
        break;
      default:
        targetPage = const SizedBox(); // Placeholder, you can change this
    }

    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        padding: const EdgeInsets.all(0),
      ),
      child: Container(
        alignment: Alignment.center,
        height: size.height * 0.065,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'Board $boardNumber',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // BuildContext localContext = context;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.35,
            alignment: Alignment.center,
            child: const Text(
              'iQTT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 45),
                    child: Text(
                      // 'Select your board',
                      mqttStatus[0],
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      customButton(1, size),
                      const SizedBox(height: 20),
                      customButton(2, size),
                      const SizedBox(height: 20),
                      customButton(3, size),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

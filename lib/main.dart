import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(const MyApp());
}

List<String> mqttStatus = [
  'initial connection state',
  'Initial state of 1',
  'initial state of 2',
  'initial state of 3'
];

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
    client = MqttServerClient.withPort(broker, 'ClientID_karthi1248345', port);
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
        print('Received Message : $payload');
        String topic = payload[6];
        print(topic);
        String data = payload.substring(9).split(':').join('');
        print(data);
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Board1Page()),
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
                          child: const Text(
                            'Board 1',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Board2Page()),
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
                          child: const Text(
                            'Board 2',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Board3Page()),
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
                          child: const Text(
                            'Board 3',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
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

class Board1Page extends StatelessWidget {
  const Board1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board 1'),
      ),
      body: Center(
        child: Text(mqttStatus[1]),
      ),
    );
  }
}

class Board2Page extends StatelessWidget {
  const Board2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board 2'),
      ),
      body: Center(
        child: Text(mqttStatus[2]),
      ),
    );
  }
}

class Board3Page extends StatelessWidget {
  const Board3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board 3'),
      ),
      body: Center(
        child: Text(mqttStatus[3]),
      ),
    );
  }
}

// class Board2Page extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: size.height * 0.35,
//             alignment: Alignment.center,
//             child: Text(
//               'Board 2',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 40,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(left: 25, top: 45),
//                     child: Text(
//                       'Select your board',
//                       style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: () {
//                       print(
//                           'Button pressed'); // Print message when button is pressed
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.black,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(13),
//                       ),
//                       padding: EdgeInsets.all(0),
//                     ),
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: size.height * 0.065,
//                       width: double.infinity,
//                       padding: EdgeInsets.only(left: 10),
//                       child: Text(
//                         'Board 1',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Board3Page extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: EdgeInsets.only(top: 50, left: 20),
//                   child: Text(
//                     'Board 3',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 35,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Column(
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         // Handle button press
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(13),
//                         ),
//                         padding: EdgeInsets.all(0),
//                       ),
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: size.height * 0.065,
//                         width: double.infinity,
//                         padding: EdgeInsets.only(left: 10),
//                         child: Text(
//                           'Light 1',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     // Repeat similar ElevatedButton widgets for other buttons
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(left: 25, top: 45),
//                     child: Text(
//                       'Select your board',
//                       style: TextStyle(
//                         color: Theme.of(context).primaryColor,
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

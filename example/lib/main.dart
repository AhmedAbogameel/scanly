import 'package:flutter/material.dart';
import 'package:scanly/scanly.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanly Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Scanly Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                child: const Text('Scan'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ScanView(),));
                },
              ),
              ElevatedButton(
                child: const Text('Generate'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GenerateView(),));
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}

class ScanView extends StatelessWidget {
  const ScanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanly Scan Widget"),
      ),
      body: Center(
        child: ScanlyQRScanner(
          onScanData: (data) {

          },
        ),
      ),
    );
  }
}

class GenerateView extends StatelessWidget {
  const GenerateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanly Generator Widget"),
      ),
      body: Center(
        child: ScanlyQRGenerator(
          data: 'Scan',
        ),
      ),
    );
  }
}
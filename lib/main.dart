import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

VoidCallback _handleMetricsChanged;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        if (_handleMetricsChanged == null) {
          _handleMetricsChanged = ui.window.onMetricsChanged;
        }
        ui.window.onMetricsChanged = () {
          _handleMetricsChanged();
          setState(() {});
        };
        return new Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              color: const Color(0xFF3333FF),
              padding: EdgeInsets.only(top: ui.window.padding.top / ui.window.devicePixelRatio),
              child: new Container(
                  color: const Color(0xFFFFA3A3),
                  child: new Center(
                      child: new Container(
                          color: const Color(0xFF313100),
                          padding: const EdgeInsets.all(20.0),
                          child: new MyAppCounter()))),
            ));
      },
    );
  }
}

void main() {
  runApp(new MyApp());
}

class MyAppCounter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyAppCounter> {
  int _count = 0;
  static const String COUNTER_KEY = 'counter';

  _MyAppState() {
    init();
  }

  init() async {
    var pref = await SharedPreferences.getInstance();
    _count = pref.getInt(COUNTER_KEY) ?? 0;
    setState(() {});
  }

  increaseCounter() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(COUNTER_KEY, ++_count);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Text(
        'Hello world！x $_count',
        style: const TextStyle(color: const Color(0xFF0000FF), fontSize: 30.0),
      ),
      onTap: increaseCounter,
    );
  }
}

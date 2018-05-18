import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Directionality(
        textDirection: TextDirection.ltr,
        child: new Container(
            color: const Color(0xFFFFFFFF),
            child: new Center(
                child: new Container(
                    color: const Color(0xFFF1F100),
                    padding: const EdgeInsets.all(20.0),
                    child: new MyAppCounter()))));
  }
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

void main() {
  runApp(new MyApp());
}

import 'package:flutter/widgets.dart';

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
                    child: new Text(
                      'Hello world！',
                      style: const TextStyle(
                          color: const Color(0xFF0000FF), fontSize: 30.0),
                    )))));
  }
}

void main() {
  runApp(new MyApp());
}

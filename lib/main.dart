import 'dart:ui' as ui;

import 'package:flutter/material.dart';
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
                          color: const Color(0xFFA1A100),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              MyAppCounter(),
                              new Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: RaisedButton(
                                    onPressed: () {
                                      print('start eval js');
                                      var v = ui.window.evalJavaScript(
                                          '(function(){var rc = parseInt(ts)+1;'
                                          'ts = rc;'
                                          'if (rc%2==0) return rc;'
                                          'if (rc%3==0) return "hello";'
                                          'return true;})()',
                                          'returnValue.js');
                                      print("$v @ ${v.runtimeType}");
                                    },
                                    child: Text('script return value')),
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: RaisedButton(
                                  onPressed: () {
                                    ui.window.execJavaScript(
                                        'throw new Error(\'throwing a error ${DateTime.now().toIso8601String()}\');',
                                        'exp.js');
                                  },
                                  child: Text('throw js exception'),
                                ),
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: RaisedButton(
                                  onPressed: () {
                                    var n = DateTime.now().millisecond.toDouble();
                                    var r = ui.window.invokeMethod('', 'isOdd', n);
                                    print("$n is Odd: $r");
                                  },
                                  child: Text('invoke method'),
                                ),
                              )
                            ],
                          )))),
            ));
      },
    );
  }
}

void main() {
  print("window defalut route:${ui.window.defaultRouteName}");
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
    pref.setInt(COUNTER_KEY, _count++);
    print('jsc function return: ');
    print(ui.window.invokeMethod('', 'getTG', ""));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ui.window
        .execJavaScript("function isOdd(a) { return Math.ceil(a)%2==1; }; function getTG() { return tg; };", "init.js");
    ui.window.setGlobalVariable("tg", DateTime.now().second.toDouble());
    ui.window.setGlobalVariable(
        'ts',
        "${DateTime
            .now()
            .millisecondsSinceEpoch}");
    ui.window.addJavaScriptInterface('dart_window', (argument) {
      print("call from JavaScript $argument");
      return "$argument _ ${DateTime
          .now()
          .millisecond}";
    });
    return new RaisedButton(
      onPressed: increaseCounter,
      child: new Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: new Text(
          'Hello, world（！x $_count）',
          style: const TextStyle(color: const Color(0xFF0000FF), fontSize: 20.0),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

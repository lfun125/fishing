import 'dart:io';

import 'package:fishing/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart' as ws;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    ws.setWindowTitle("魔兽世界钓鱼控制台");
    ws.setWindowMinSize(const Size(1024, 750));
    ws.setWindowMaxSize(const Size(1024, 750));
    final platformWindow = await ws.getWindowInfo();
    final Rect frame = Rect.fromCenter(
      center: Offset(
        platformWindow.frame.center.dx,
        platformWindow.frame.center.dy,
      ),
      width: 1024,
      height: 750,
    );
    ws.setWindowFrame(frame);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '魔兽世界钓鱼控制台'),
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
  final _formKey = GlobalKey<FormState>();
  final _formCtl = FormCtl();
  var wowVersion = '70';
  final _split = [false, false, false, false];
  final _cycleList = <CycleData>[];
  int _cycleNumber = 0;

  void _fishing() {
    final args = _getArgs();
    print(args);
    setState(() {});
  }

  void _setSplitValue(int k, bool v) {
    _split[k] = v;
    setState(() {});
  }

  void _setVersion(String v) {
    wowVersion = v;
    setState(() {});
  }

  void _apendCycle() {
    _cycleList.add(CycleData(_cycleNumber));
    _cycleNumber++;
    setState(() {});
  }

  String _getArgs() {
    final data = _formCtl.values();
    var splitList = [];
    _split.asMap().forEach((key, value) {
      if (value) {
        splitList.add('${key + 1}');
      }
    });
    var args =
        '-fb ${data["fb"]} -om ${data["om"]} -l ${data["l"]} -wow-ersion $wowVersion';
    if (splitList.isNotEmpty) {
      final s = splitList.join('_');
      args += ' -split $s';
    }
    return args;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        children: [
          Form(
            key: _formKey,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _field(_formCtl, 'fb', '钓鱼按键', text: '1', smg: '钓鱼按键必须填写'),
                _field(_formCtl, 'om', '开河蚌箱子宏', text: '2', smg: '开河蚌箱子宏必须填写'),
                _field(_formCtl, 'l', '明亮度', text: '4', smg: '明亮度必须填写'),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      const Text('魔兽版本：'),
                      OutlinedButton(
                        onPressed: () {
                          _setVersion('70');
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              shape: const CircleBorder(),
                              value: wowVersion == '70',
                              onChanged: (b) => {_setVersion('70')},
                            ),
                            const Text('70'),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _setVersion('60');
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              shape: const CircleBorder(),
                              value: wowVersion == '60',
                              onChanged: (b) => {_setVersion('60')},
                            ),
                            const Text('60'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '分屏区域：',
                        style: TextStyle(height: 2),
                      ),
                      displaySplitData(
                        [
                          SplitData(
                            '分区1',
                            _split[0],
                            (value) => _setSplitValue(0, value!),
                          ),
                          SplitData(
                            '分区2',
                            _split[1],
                            (value) => _setSplitValue(1, value!),
                          ),
                          SplitData(
                            '分区3',
                            _split[2],
                            (value) => _setSplitValue(2, value!),
                          ),
                          SplitData(
                            '分区4',
                            _split[3],
                            (value) => _setSplitValue(3, value!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                for (var item in _cycleList)
                  wigetCycleButton(item, _formCtl, () => {}, (v) {
                    for (var item in v.keys) {
                      print(item);
                      _formCtl.disposeKey(item);
                    }
                    _cycleList.remove(v);
                    setState(() {});
                  }),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _apendCycle();
                      },
                      child: Row(
                        children: const [
                          Text('添加按键循环'),
                          Icon(Icons.add),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            margin: const EdgeInsets.all(20),
            child: ListView(
              children: const [
                Text('1', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: _fishing,
              tooltip: '开始钓鱼',
              child: const Icon(Icons.power_settings_new),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _field(FormCtl ctl, String k, String name, {text = '', smg = ''}) {
  return TextFormField(
    controller: ctl.key(k, text: text),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return smg;
      }
      return null;
    },
    decoration: InputDecoration(
      label: Text(name),
    ),
  );
}

class CycleData {
  int index;
  String btn = '3';
  String time = '1';
  String cycle = '300';
  List<String> keys = <String>[];
  List<bool> checkList = [false, false, false, false];
  CycleData(this.index) {
    keys = ['sycle_${index}_btn', '${index}_cycle', '${index}_time'];
  }
}

class SplitData {
  String name;
  bool value;
  final ValueChanged<bool?>? onChanged;
  SplitData(this.name, this.value, this.onChanged);
}

Widget wigetCycleButton(CycleData data, FormCtl ctl, Function onChange,
    Function(CycleData) delete) {
  return Row(
    children: [
      Container(
        width: 35,
        margin: const EdgeInsets.only(right: 10),
        child: TextFormField(
          controller: ctl.key(data.keys[0], text: data.btn),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          decoration: const InputDecoration(
            label: Text('按键'),
          ),
        ),
      ),
      Container(
        width: 70,
        margin: const EdgeInsets.only(right: 10),
        child: TextFormField(
          controller: ctl.key(data.keys[1], text: data.time),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          decoration: const InputDecoration(
            label: Text('施法时间'),
          ),
        ),
      ),
      Container(
        width: 70,
        margin: const EdgeInsets.only(right: 10),
        child: TextFormField(
          controller: ctl.key(data.keys[2], text: data.cycle),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '';
            }
            return null;
          },
          decoration: const InputDecoration(
            label: Text('周期/秒'),
          ),
        ),
      ),
      const Text('区域：'),
      const SizedBox(width: 5),
      const Text('1'),
      Checkbox(
          value: data.checkList[0],
          onChanged: (v) {
            data.checkList[0] = v!;
            onChange();
          }),
      const SizedBox(width: 5),
      const Text('2'),
      Checkbox(
          value: data.checkList[1],
          onChanged: (v) {
            data.checkList[1] = v!;
            onChange();
          }),
      const SizedBox(width: 5),
      const Text('3'),
      Checkbox(
          value: data.checkList[2],
          onChanged: (v) {
            data.checkList[2] = v!;
            onChange();
          }),
      const SizedBox(width: 5),
      const Text('4'),
      Checkbox(
          value: data.checkList[3],
          onChanged: (v) {
            data.checkList[3] = v!;
            onChange();
          }),
      const SizedBox(width: 5),
      TextButton(
          onPressed: () => delete(data),
          child: const Icon(
            Icons.delete,
            color: Colors.red,
          ))
    ],
  );
}

Widget displaySplitData(List<SplitData> list,
    {crossAxisCount = 2, ratio = 5 / 1}) {
  return Flexible(
    child: GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: ratio,
      children: [
        for (var item in list)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.name),
              Checkbox(value: item.value, onChanged: item.onChanged),
            ],
          ),
      ],
    ),
  );
}

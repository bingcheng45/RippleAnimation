import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:random_color/random_color.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fab overlay transition',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Duration animationDuration = Duration(milliseconds: 300);
  final Duration delay = Duration(milliseconds: 300);
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;
  RandomColor _randomColor = RandomColor();
  Color _color;
  Color _bgcolor = Colors.transparent;
  @override
  void initState() {
    super.initState();
    _color = _randomColor.randomColor();
  }

  void _onTap() async {
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() =>
          rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
      Future.delayed(
        animationDuration + delay,
      ).then((_) => setState(() {
            rect = null;

            _color = _randomColor.randomColor();
          }));
    });
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
      _bgcolor = _color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          //appBar: AppBar(title: Text('Fab overlay transition')),
          body: Stack(
            children: <Widget>[
              Container(color: _bgcolor,),
              _ripple(), //put below so only change the background
              Center(child: Text('Tap the smiley face to change color')),
            ],
          ),

          floatingActionButton: RectGetter(
            key: rectGetterKey,
            child: FloatingActionButton(
              backgroundColor: _color,
              onPressed: _onTap,
              child: Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      duration: animationDuration,
      left: rect.left,
      right: MediaQuery.of(context).size.width - rect.right,
      top: rect.top,
      bottom: MediaQuery.of(context).size.height - rect.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _color,
        ),
      ),
    );
  }
}

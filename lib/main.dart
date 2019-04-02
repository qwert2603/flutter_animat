import 'package:flutter/material.dart';
import 'package:flutter_animat/2048.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController staggeredController;

  @override
  void initState() {
    super.initState();

    staggeredController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.forward),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (c) => Game2048())))
        ],
      ),
      body: StaggerAnimation(controller: staggeredController),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        try {
          await staggeredController.forward().orCancel;
          await staggeredController.reverse().orCancel;
        } on TickerCanceled {
          print("cancelled!!!!");
        }
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    staggeredController.dispose();
  }
}

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius> borderRadius;
  final Animation<Color> color;

  StaggerAnimation({Key key, this.controller})
      : opacity = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.1, curve: Curves.ease),
          ),
        ),
        width = Tween(
          begin: 50.0,
          end: 150.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.125, 0.25, curve: Curves.ease),
          ),
        ),
        height = Tween(
          begin: 50.0,
          end: 150.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.25, 0.375, curve: Curves.ease),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: EdgeInsets.only(bottom: 60),
          end: EdgeInsets.only(bottom: 150),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.25, 0.5, curve: Curves.ease),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(8),
          end: BorderRadius.circular(80.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.375, 0.7, curve: Curves.ease),
          ),
        ),
        color = TweenSequence([
          TweenSequenceItem(
            tween: ColorTween(
              begin: Colors.grey,
              end: Colors.red,
            ),
            weight: 2,
          ),
          TweenSequenceItem(
            tween: ColorTween(
              begin: Colors.red,
              end: Colors.yellow,
            ),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.5, 1.0, curve: Curves.ease),
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          alignment: AlignmentDirectional.bottomCenter,
          padding: padding.value,
          child: Opacity(
            opacity: opacity.value,
            child: Container(
              width: width.value,
              height: height.value,
              decoration: BoxDecoration(
                color: color.value,
                border: Border.all(),
                borderRadius: borderRadius.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

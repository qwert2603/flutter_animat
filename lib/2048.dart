import 'package:flutter/material.dart';
import 'dart:math' show min;

class Game2048 extends StatefulWidget {
  @override
  _Game2048State createState() => _Game2048State();
}

class _Game2048State extends State<Game2048>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final side = min(size.width, size.height);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("swipe right"),
          GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity > 0) {
                animationController.forward();
              }
            },
            child: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all()),
              width: side,
              height: side,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  MovingTile(
                    -1,
                    0.33,
                    -1,
                    -1,
                    Colors.pink,
                    animationController: animationController,
                  ),
                  MovingTile(
                    0.33,
                    1,
                    -1,
                    -1,
                    Colors.orange,
                    animationController: animationController,
                  ),
                  MovingTile(
                    -0.33,
                    0.33,
                    -0.33,
                    -0.33,
                    Colors.yellow,
                    animationController: animationController,
                  ),
                  MovingTile(
                    1,
                    1,
                    -0.33,
                    -0.33,
                    Colors.deepPurple,
                    animationController: animationController,
                  ),
                  MovingTile(
                    -1,
                    1,
                    0.33,
                    0.33,
                    Colors.blue,
                    animationController: animationController,
                  ),
                  MovingTile(
                    0.33,
                    1,
                    1,
                    1,
                    Colors.red,
                    animationController: animationController,
                  ),
                  AppearingTile(
                    animationController,
                    Alignment(-0.33, 0.33),
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          animationController.reset();
//          animationController.forward();
        },
        child: Icon(Icons.restore),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class MovingTile extends StatelessWidget {
  final AnimationController animationController;

  final Animation<Alignment> alignment;
  final Animation<Color> color;

  MovingTile(double bx, double ex, double by, double ey, Color color,
      {Key key, this.animationController})
      : alignment = AlignmentTween(
          begin: Alignment(bx, by),
          end: Alignment(ex, ey),
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.0, 0.5, curve: Curves.easeIn),
          ),
        ),
        color = AlwaysStoppedAnimation(color),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => FractionallySizedBox(
            alignment: alignment.value,
            widthFactor: 0.25,
            heightFactor: 0.25,
            child: Container(
              color: color.value,
              margin: const EdgeInsets.all(2.0),
            ),
          ),
    );
  }
}

class AppearingTile extends StatelessWidget {
  final AnimationController animationController;

  final Animation<double> opacity;
  final Alignment alignment;
  final Color color;

  AppearingTile(this.animationController, this.alignment, this.color)
      : opacity = Tween(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: Interval(0.5, 1.0, curve: Curves.easeIn),
        ));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) => FractionallySizedBox(
            alignment: alignment,
            widthFactor: 0.25,
            heightFactor: 0.25,
            child: Opacity(
              opacity: opacity.value,
              child: Container(
                color: color,
                margin: const EdgeInsets.all(2.0),
              ),
            ),
          ),
    );
  }
}

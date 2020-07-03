import 'package:brick_breaker/brick_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyAnimation(),
    );
  }
}

class MyAnimation extends StatefulWidget {
  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation> {
  Ticker ticker;
  @override
  void initState() {
    super.initState();
    ticker = Ticker((now) => setState(() {}));
    ticker.start();
  }

  @override
  void dispose() {
    super.dispose();
    ticker.dispose();
  }

  List<Brick> wall = [
    Brick(x: 100, y: 100, size: 100, color: Colors.green, height: 50),
    Brick(x: 210, y: 100, size: 100, color: Colors.green, height: 50),
    Brick(x: 50, y: 160, size: 100, color: Colors.green, height: 50),
    Brick(x: 160, y: 160, size: 100, color: Colors.green, height: 50),
    Brick(x: 270, y: 160, size: 100, color: Colors.green, height: 50),
    Brick(x: 100, y: 220, size: 100, color: Colors.green, height: 50),
    Brick(x: 210, y: 220, size: 100, color: Colors.green, height: 50),
  ];

  double x = 10.0;
  double y = 500.0;
  double speed = 8.0;
  double dirX = 5.0;
  double dirY = 5.0;

  double barPosX = 200.0;
  double barPosY;
  double barSize = 150;

  var toRemove = [];

  @override
  Widget build(BuildContext context) {
    final size = 25.0;
    final screen = MediaQuery.of(context).size;

    x += dirX;
    y += dirY;
    barPosY = screen.height - 70;

    if (x > screen.width - size) {
      dirX = -speed;
    }
    if (x < 0) {
      dirX = speed;
    }
    if (y > screen.height - size) {
      ticker.dispose();
    }
    if (y < 0) {
      dirY = speed;
    }

    if (y + size >= barPosY && x >= barPosX && x <= barPosX + barSize) {
      dirY = -speed;
    }

    wall.forEach((brick) {
      if (x + size >= brick.x &&
          x <= brick.x + brick.size &&
          y + size >= brick.y &&
          y <= brick.y + brick.height) {
        if (x + size >= brick.x &&
            x <= brick.x + brick.size &&
            y + size >= brick.y &&
            y <= brick.y + 1) {
          dirY = -speed;
        }
        if (x + size >= brick.x &&
            x <= brick.x + brick.size &&
            y + size >= brick.y + brick.height - 1 &&
            y <= brick.y + brick.height) {
          dirY = speed;
        }
        if (x + size >= brick.x &&
            x <= brick.x + 1 &&
            y + size >= brick.y &&
            y <= brick.y + brick.height) {
          dirX = -speed;
        }
        if (x + size >= brick.x + brick.size &&
            x <= brick.x + brick.size - 1 &&
            y + size >= brick.y &&
            y <= brick.y + brick.height) {
          dirX = speed;
        }
        toRemove.add(brick);
      }
    });

    wall.removeWhere((e) => toRemove.contains(e));

    return Scaffold(
      body: Container(
          child: GestureDetector(
        onHorizontalDragStart: (DragStartDetails start) {
          RenderBox getBox = context.findRenderObject();
          var local = getBox.globalToLocal(start.globalPosition);
          barPosX = local.dx - size / 2;
        },
        onHorizontalDragUpdate: (update) {
          RenderBox getBox = context.findRenderObject();
          var local = getBox.globalToLocal(update.globalPosition);
          barPosX = local.dx - size / 2;
        },
        child: Container(
            width: screen.width,
            height: screen.height,
            color: Colors.transparent,
            child: CustomPaint(
                painter: Wall(
              wall: wall,
              y: y,
              x: x,
              ballSize: size,
              barSize: barSize,
              barX: barPosX,
              barY: barPosY,
            ))),
      )),
    );
  }
}

class Wall extends CustomPainter {
  List<Brick> wall;
  double ballSize;
  double x;
  double y;
  double barX;
  double barY;
  double barSize;

  Wall(
      {this.wall,
      this.y,
      this.x,
      this.ballSize,
      this.barX,
      this.barY,
      this.barSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paintBar = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.yellow;

    canvas.drawRect(
      Rect.fromLTRB(barX, barY, barX + barSize, barY + 20),
      paintBar,
    );
    final paintBall = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.indigoAccent;
    canvas.drawOval(
      Rect.fromLTRB(x, y, x + ballSize, y + ballSize),
      paintBall,
    );
    wall.forEach((brick) {
      brick.drawBrick(canvas);
    });
  }

  @override
  bool shouldRepaint(Wall oldDelegate) => true;
}

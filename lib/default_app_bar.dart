import 'package:flutter/material.dart';
import 'package:appbar_animation/ripplePaint.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState();
}

// add SingleTickerProviderStateMixin to our State widget
class _DefaultAppBarState extends State<DefaultAppBar>
    with SingleTickerProviderStateMixin {
  double rippleStartX, rippleStartY;

  // intialize animation and controller
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  //we'll run the animation in forward direction when user taps on search icon
  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });
    print("pointer location $rippleStartX, $rippleStartY");

    // run animation controller in forward direction
    // as we now have center point for ripple animation
    _controller.forward();
  }

  // lastly we'll add AnimationBuilder which uses our MyPainter and AnimationController to render ripple animation

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        AppBar(
          title: Text('Flutter App'),
          elevation: 0.0,
          actions: <Widget>[
            GestureDetector(
                onTapUp: onSearchTapUp,
                child: IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: null)),
            IconButton(icon: Icon(Icons.more_vert), onPressed: null)
          ],
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: RipplePainter(
                containerHeight: widget.preferredSize.height,
                center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
                // increase radius in % from 0% to 100% of screenWidth
                radius: _animation.value * screenWidth,
                context: context,
              ),
            );
          },
        ),
      ],
    );
  }
}

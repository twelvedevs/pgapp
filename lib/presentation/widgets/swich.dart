import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pgapp/core/theme/theme.dart';

class LiteRollingSwitch extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;
  final Duration animationDuration;
  final String iconOnAssetName;
  final String iconOffAssetName;
  final double width;
  final double height;
  final double iconSize;
  final double borderWidth;
  final Color color;

  const LiteRollingSwitch(
      {Key? key,
      this.value = false,
      this.iconOffAssetName = '',
      this.iconOnAssetName = '',
      this.animationDuration = MyThemes.duration,
      required this.onChanged,
      this.width = 80,
      this.height = 40,
      this.iconSize = 32,
      this.borderWidth = 1,
      this.color = Colors.white})
      : super(key: key);

  @override
  _RollingSwitchState createState() => _RollingSwitchState();
}

class _RollingSwitchState extends State<LiteRollingSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  double value = 0.0;
  late bool turnState;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: widget.animationDuration);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationController.addListener(() {
      setState(() {
        value = animation.value;
      });
    });
    turnState = widget.value;
    turnState ? animationController.forward() : animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: _action,
      onTap: _action,
      child: Container(
        padding: const EdgeInsets.all(4),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            border: Border.all(width: widget.borderWidth, color: Colors.white),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(40)),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset((widget.width - widget.iconSize - 10) * value, 0),
              child: Stack(
                children: <Widget>[
                  Opacity(
                    opacity: (1 - value).clamp(0.0, 1.0),
                    child: SvgPicture.asset(widget.iconOffAssetName,
                        width: widget.iconSize,
                        height: widget.iconSize,
                        color: widget.color),
                  ),
                  Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: SvgPicture.asset(widget.iconOnAssetName,
                          width: widget.iconSize,
                          height: widget.iconSize,
                          color: widget.color)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _action() {
    _determine(changeState: true);
  }

  _determine({bool changeState = false}) {
    setState(() {
      if (changeState) turnState = !turnState;
      (turnState)
          ? animationController.forward()
          : animationController.reverse();

      widget.onChanged(turnState);
    });
  }
}

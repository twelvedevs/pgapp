import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pgapp/core/theme/theme.dart';
import 'package:pgapp/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class Incrementer extends StatelessWidget {
  final String label;
  final int value;
  final bool increaseDisabled;
  final bool decreaseDisabled;
  final ValueChanged<int> onIncrease;
  final ValueChanged<int> onDecrease;
  final int min;
  final int max;
  final double iconSize;

  const Incrementer(
      {Key? key,
      required this.value,
      required this.onIncrease,
      required this.onDecrease,
      this.min = 0,
      this.max = 20,
      this.label = '',
      this.increaseDisabled = false,
      this.decreaseDisabled = false,
      this.iconSize = 20})
      : super(key: key);

  bool _increaseDisabled() => increaseDisabled || value + 1 > max;

  bool _decreaseDisabled() => decreaseDisabled || value - 1 < min;

  _onIncrease() {
    final int newValue = value + 1;

    if (newValue > max || increaseDisabled) {
      return;
    }

    onIncrease(newValue);
  }

  _onDecrease() {
    final int newValue = value - 1;

    if (newValue < min || decreaseDisabled) {
      return;
    }

    onIncrease(newValue);
  }

  String randomStr(BuildContext context) =>
      MediaQuery.of(context).size.width > MyDimensions.small ? 'Random' : 'rnd';

  String _valueStr(BuildContext context) =>
      value == -1 ? randomStr(context) : value.toString();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color _iconColor = themeProvider.colorMode.onSurfaceDark;
    Color _iconColorDisabled = themeProvider.colorMode.onSurfaceLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label${_valueStr(context)}',
            style: Theme.of(context).textTheme.caption),
        AnimatedContainer(
          duration: MyThemes.duration,
          height: 48,
          decoration: BoxDecoration(
              color: themeProvider.colorMode.surfaceDark,
              borderRadius: const BorderRadius.all(Radius.circular(40))),
          child: Row(
            children: [
              Expanded(
                  child: Center(
                      child: Material(
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: IconButton(
                    onPressed: _decreaseDisabled() ? null : _onDecrease,
                    icon: SvgPicture.asset('assets/icons/minus.svg',
                        width: iconSize,
                        height: iconSize,
                        color: _decreaseDisabled()
                            ? _iconColorDisabled
                            : _iconColor)),
              ))),
              SvgPicture.asset('assets/icons/separator.svg',
                  color: _iconColorDisabled),
              Expanded(
                  child: Center(
                      child: Material(
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: IconButton(
                    onPressed: _increaseDisabled() ? null : _onIncrease,
                    icon: SvgPicture.asset('assets/icons/plus.svg',
                        width: iconSize,
                        height: iconSize,
                        color: _increaseDisabled()
                            ? _iconColorDisabled
                            : _iconColor)),
              ))),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pgapp/core/theme/theme.dart';
import 'package:pgapp/domain/entities/password_constants.dart';
import 'package:pgapp/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class Separator extends StatefulWidget {
  final String label;
  final String value;
  final bool disabled;
  final double size;
  final ValueChanged<String> onChange;

  const Separator(
      {Key? key,
      required this.value,
      required this.onChange,
      this.label = '',
      this.disabled = false,
      this.size = 48})
      : super(key: key);

  @override
  State<Separator> createState() => _SeparatorState();
}

class _SeparatorState extends State<Separator> {
  late ScrollController _controller;
  bool _disabledNext = false;
  bool _disabledBack = true;
  final List<String> _data = ['', ...PasswordConstants.symbols.split('')];

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(listener);
  }

  listener() {
    _updDisableState(_controller.offset);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(listener);
  }

  _updDisableState(double to) {
    setState(() {
      _disabledBack = to <= 0 || widget.disabled;
      _disabledNext =
          to >= _controller.position.maxScrollExtent || widget.disabled;
    });
  }

  _onBackPressed() {
    if (_controller.offset <= 0 || widget.disabled) {
      return;
    }

    final to = _controller.offset - (widget.size * 2 + 8);

    _controller.animateTo(to,
        duration: MyThemes.duration, curve: Curves.linear);

    _updDisableState(to);
  }

  _onNextPressed() {
    if (_controller.offset >= _controller.position.maxScrollExtent ||
        widget.disabled) {
      return;
    }

    final to = _controller.offset + (widget.size * 2 + 8);

    _controller.animateTo(to,
        duration: MyThemes.duration, curve: Curves.linear);

    _updDisableState(to);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.caption),
        AnimatedOpacity(
          duration: MyThemes.duration,
          opacity: widget.disabled ? 0.7 : 1,
          child: Row(
            children: [
              if (MediaQuery.of(context).size.width >= MyDimensions.mobile)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                      onPressed: _disabledBack || widget.disabled
                          ? null
                          : _onBackPressed,
                      disabledColor: context
                          .watch<ThemeProvider>()
                          .colorMode
                          .onSurfaceLight,
                      color: context
                          .watch<ThemeProvider>()
                          .colorMode
                          .onSurfaceDark,
                      icon: const Icon(Icons.arrow_back_ios)),
                ),
              Expanded(
                child: SingleChildScrollView(
                    physics: widget.disabled
                        ? const NeverScrollableScrollPhysics()
                        : const ScrollPhysics(),
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List.generate(_data.length, separatorItem).toList(),
                    )),
              ),
              if (MediaQuery.of(context).size.width >= MyDimensions.mobile)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                      onPressed: _disabledNext || widget.disabled
                          ? null
                          : _onNextPressed,
                      disabledColor: context
                          .watch<ThemeProvider>()
                          .colorMode
                          .onSurfaceLight,
                      color: context
                          .watch<ThemeProvider>()
                          .colorMode
                          .onSurfaceDark,
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                      )),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget separatorItem(index) {
    final marginRight =
        EdgeInsets.only(right: index == _data.length - 1 ? 0 : 8);

    final textStyle = Theme.of(context).textTheme.bodyText2?.copyWith(
        color: _data[index] == widget.value
            ? context.watch<ThemeProvider>().colorMode.onPrimary
            : context.watch<ThemeProvider>().colorMode.onSurfaceLight);

    final color = _data[index] == widget.value
        ? context.watch<ThemeProvider>().colorMode.primary
        : context.watch<ThemeProvider>().colorMode.surfaceDark;

    return AnimatedContainer(
      duration: MyThemes.duration,
      margin: marginRight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: AnimatedContainer(
          duration: MyThemes.duration,
          color: color,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  widget.disabled ? null : () => widget.onChange(_data[index]),
              hoverColor: context
                  .watch<ThemeProvider>()
                  .colorMode
                  .primary
                  .withOpacity(0.4),
              child: SizedBox(
                  height: widget.size,
                  width: widget.size,
                  child: Center(
                      child: Text(
                    _data[index],
                    style: textStyle,
                  ))),
            ),
          ),
        ),
      ),
    );
  }
}

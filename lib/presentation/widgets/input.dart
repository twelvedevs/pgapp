import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pgapp/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class Password extends StatelessWidget {
  final String password;
  final Function? onUpdate;
  final double iconSize;

  const Password(
      {Key? key, this.password = '', this.onUpdate, this.iconSize = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool hasOnUpdate = onUpdate != null;
    const EdgeInsetsGeometry defaultIconPadding = EdgeInsets.all(8);

    const EdgeInsetsGeometry lastIconPadding =
        EdgeInsets.only(right: 24, left: 8, top: 8, bottom: 8);

    _onUpdate() {
      if (hasOnUpdate) {
        onUpdate!();
      }
    }

    _onCopy() {
      Clipboard.setData(ClipboardData(text: password));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Password Copied!'),
        ),
      );
    }

    return TextField(
      controller: TextEditingController(text: password),
      readOnly: true,
      decoration: InputDecoration(
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                padding: hasOnUpdate ? defaultIconPadding : lastIconPadding,
                constraints: const BoxConstraints(),
                onPressed: _onCopy,
                icon: SvgPicture.asset(
                  'assets/icons/copy.svg',
                  width: iconSize,
                  height: iconSize,
                  color: themeProvider.colorMode.onInput,
                )),
            if (hasOnUpdate)
              IconButton(
                  constraints: const BoxConstraints(),
                  padding: lastIconPadding,
                  onPressed: _onUpdate,
                  icon: SvgPicture.asset(
                    'assets/icons/refresh.svg',
                    width: iconSize,
                    height: iconSize,
                    color: themeProvider.colorMode.onInput,
                  )),
          ],
        ),
      ),
    );
  }
}

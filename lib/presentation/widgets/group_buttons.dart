import 'package:flutter/material.dart';
import 'package:pgapp/core/theme/theme.dart';
import 'package:pgapp/presentation/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class RadioModel {
  bool isSelected;
  final String label;

  RadioModel(this.isSelected, this.label);
}

class _GroupButtonsItem extends StatelessWidget {
  final RadioModel _item;
  final int _index;
  final Function _onSelect;

  const _GroupButtonsItem(this._item, this._index, this._onSelect);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final Color textColor = _item.isSelected
        ? themeProvider.colorMode.onPrimary
        : themeProvider.colorMode.onSurfaceLight;
    final Color containerColor = _item.isSelected
        ? themeProvider.colorMode.primary
        : themeProvider.colorMode.surfaceDark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: AnimatedContainer(
        duration: MyThemes.duration,
        color: containerColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onSelect(_index),
            hoverColor: themeProvider.colorMode.primary.withOpacity(0.4),
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(_item.label,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: textColor)))),
          ),
        ),
      ),
    );
  }
}

class GroupButtons extends StatefulWidget {
  final List<RadioModel> data;
  final ValueChanged<RadioModel>? onSelect;
  final String label;

  const GroupButtons(
      {Key? key, required this.data, this.onSelect, this.label = ''})
      : super(key: key);

  @override
  State<GroupButtons> createState() => _GroupButtonsState();
}

class _GroupButtonsState extends State<GroupButtons> {
  List<RadioModel> data = [];

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  _onSelect(int index) {
    setState(() {
      data.forEach((element) => element.isSelected = false);
      data[index].isSelected = true;
    });

    if (widget.onSelect != null) {
      widget.onSelect!(data[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.caption),
        AnimatedContainer(
          duration: MyThemes.duration,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            color: themeProvider.colorMode.surfaceDark,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
          ),
          child: Row(
            children: List.generate(
                data.length,
                (index) => Expanded(
                      child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child:
                              _GroupButtonsItem(data[index], index, _onSelect)),
                    )).toList(),
          ),
        ),
      ],
    );
  }
}

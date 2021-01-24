import 'package:filcnaplo/data/context/app.dart';
import 'package:flutter/material.dart';

class CustomTabButton extends StatelessWidget {
  final String title;
  final Color color;
  final bool dropdown;

  CustomTabButton(this.title, {this.color, this.dropdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18.0, color: color),
            ),
          ),
          dropdown
              ? Icon(Icons.arrow_drop_down, color: color, size: 20.0)
              : Container(),
        ],
      ),
    );
  }
}

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  if (!controller.indexIsChanging)
    return (currentIndex - controllerValue).abs().clamp(0.0, 1.0);

  return (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
}

class CustomTabIndicator extends StatelessWidget {
  const CustomTabIndicator({
    Key key,
    @required this.backgroundColor,
    @required this.borderColor,
    @required this.size,
    @required this.label,
    @required this.controller,
    @required this.index,
    @required this.onTap,
  })  : assert(backgroundColor != null),
        assert(borderColor != null),
        assert(size != null),
        super(key: key);

  final Color backgroundColor;
  final TabController controller;
  final CustomLabel label;
  final Color borderColor;
  final double size;
  final int index;
  final onTap;

  @override
  Widget build(BuildContext context) {
    final _menuKey = GlobalKey();

    List<PopupMenuItem> items = [];
    if (label.dropdown != null) {
      for (int i = 0; i < label.dropdown.values.keys.length; i++) {
        dynamic type = label.dropdown.values.keys.toList()[i];
        if (label.dropdown.check != null && !label.dropdown.check(type))
          continue;
        items.add(PopupMenuItem(
          value: i,
          child: Text(label.dropdown.values[type]),
        ));
      }
    }

    return Expanded(
      child: InkWell(
        customBorder: StadiumBorder(),
        child: Padding(
          padding: EdgeInsets.only(top: 3, bottom: 3),
          child: Container(
            key: _menuKey,
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: CustomTabButton(
                label.dropdown != null
                    ? label.dropdown.values.values
                        .elementAt(label.dropdown.initialValue ??
                            0.clamp(0, label.dropdown.values.values.length))
                        .replaceAll(". ", ".")
                    : label.title,
                dropdown: label.dropdown != null && items.length > 1,
                color: backgroundColor),
          ),
        ),
        onTap: () {
          if (label.dropdown != null && controller.index == index) {
            if (items.length > 1)
              showMenu(
                context: context,
                position: () {
                  Offset pos = _getPosition(_menuKey);
                  return RelativeRect.fromLTRB(0, pos.dy, pos.dx, 0);
                }(),
                items: items,
              ).then((value) {
                if (value != null) label.dropdown.callback(value);
              });
          }
          onTap(index);
        },
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  CustomTabBar({
    Key key,
    this.controller,
    this.labels,
    this.indicatorSize = 12.0,
    this.color,
    this.selectedColor,
    this.onTap,
  })  : assert(indicatorSize != null && indicatorSize > 0.0),
        super(key: key);

  final TabController controller;
  final double indicatorSize;
  final List<CustomLabel> labels;
  final Color color;
  final Color selectedColor;
  final onTap;

  final Size preferredSize = Size.fromHeight(48.0);

  Widget _buildTabIndicator(
      int tabIndex,
      TabController tabController,
      ColorTween selectedColorTween,
      ColorTween previousColorTween,
      BuildContext context) {
    Color background;
    Color borderColor = selectedColorTween.end;

    if (tabController.indexIsChanging) {
      final double t = 1.0 - _indexChangeProgress(tabController);
      if (tabController.index == tabIndex)
        background = selectedColorTween.lerp(t);
      else if (tabController.previousIndex == tabIndex)
        background = previousColorTween.lerp(t);
      else
        background = selectedColorTween.begin;
    } else {
      final double offset = tabController.offset;
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs());
        borderColor = app.settings.appColor;
      } else if (tabController.index == tabIndex - 1 && offset > 0.0) {
        background = selectedColorTween.lerp(offset);
      } else if (tabController.index == tabIndex + 1 && offset < 0.0) {
        background = selectedColorTween.lerp(-offset);
      } else {
        background = selectedColorTween.begin;
      }
    }

    return CustomTabIndicator(
      backgroundColor: background,
      borderColor: borderColor,
      size: indicatorSize,
      label: labels[tabIndex],
      controller: controller,
      index: tabIndex,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = controller;
    final Animation<double> animation = CurvedAnimation(
      parent: tabController.animation,
      curve: Curves.fastOutSlowIn,
    );

    if (labels.length < 2) return Container();

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Row(
          children: List<Widget>.generate(labels.length, (int tabIndex) {
            final Color fixColor = color;
            final Color fixSelectedColor =
                selectedColor ?? app.settings.appColor;
            final ColorTween selectedColorTween =
                ColorTween(begin: fixColor, end: fixSelectedColor);
            final ColorTween previousColorTween =
                ColorTween(begin: fixSelectedColor, end: fixColor);

            return _buildTabIndicator(
              tabIndex,
              tabController,
              selectedColorTween,
              previousColorTween,
              context,
            );
          }).toList(),
        );
      },
    );
  }
}

class CustomLabel {
  CustomLabel({this.title, this.dropdown});

  final String title;
  final CustomDropdown dropdown;
}

class CustomDropdown {
  CustomDropdown({this.values, this.callback, this.initialValue, this.check});

  final Map<dynamic, String> values;
  final callback;
  final int initialValue;
  final check;
}

Offset _getPosition(GlobalKey key) {
  final RenderBox renderBox = key.currentContext.findRenderObject();
  final position = renderBox.localToGlobal(Offset.zero);
  return position;
}

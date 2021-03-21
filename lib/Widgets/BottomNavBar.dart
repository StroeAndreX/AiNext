import 'package:AiOrganization/Core/AppLocalizations.dart';
import 'package:AiOrganization/Styles/ColorsConfig.dart';
import 'package:AiOrganization/Styles/SizeConfig.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final List<NavigationItem> items;
  final bool hasShadow;
  final Function(int) onIndexChanged;

  BottomNavBar({
    Key key,
    this.items,
    this.onIndexChanged,
    this.hasShadow = true,
  }) : super(key: key);

  final navBarState = _BottomNavBarState();

  @override
  _BottomNavBarState createState() => navBarState;
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  List<AnimationController> _controller = [];
  int _currentIndex = 0;
  int _tappedIndex = -1;

  @override
  void initState() {
    for (int i = 0; i < 5; i++) {
      _controller.add(new AnimationController(
          duration: Duration(milliseconds: 700), vsync: this));
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
      _tappedIndex = -1;
      widget.onIndexChanged(index);
    });
  }

  Widget _buildItem(NavigationItem item, bool isSelected, bool isTapped,
      int index, BuildContext context, AnimationController controller) {
    var language = AppLocalizations.of(context);

    setState(() {});

    return Expanded(
      child: GestureDetector(
        onTapUp: (TapUpDetails details) {
          setCurrentIndex(index);
          controller.reverse();
          setState(() {});
        },
        onTapDown: (TapDownDetails details) {
          setState(() {
            _tappedIndex = index;
            controller.forward();
          });
        },
        onTapCancel: () {
          setState(() {
            _tappedIndex = -1;
            controller.reverse();
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 270),
          curve: Curves.easeOutExpo,
          height: double.maxFinite,
          color: Colors.transparent,
          constraints: BoxConstraints(minWidth: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Icon
              ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.12).animate(CurvedAnimation(
                    parent: controller, curve: Curves.elasticOut)),
                child: Icon(
                  (isSelected || isTapped) ? item.selectedIcon : item.icon,
                  size: SizeConfig.blockSizeVertical < 6 ? 20 : 24,
                  color: (isSelected || isTapped)
                      ? ColorsConfig.primary
                      : ColorsConfig.primaryText,
                ),
              ),
              SizedBox(height: 4),
              // Title
              SizeConfig.blockSizeVertical < 4
                  ? SizedBox()
                  : Text(
                      //language.translate(item.title.toLowerCase()) ?? "",
                      item.title,
                      style: TextStyle(
                        color: ColorsConfig.primaryText,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.0,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60.0 + bottomPadding - (bottomPadding >= 15 ? 10 : 0),
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: bottomPadding - (bottomPadding >= 15 ? 10 : 0),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(width: 1.0, color: Color(0xFFE3E7E8))),
      ),
      child: SizedBox(
        height: kCustomBottomNavbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.items.map((item) {
            var index = widget.items.indexOf(item);

            return _buildItem(
                item,
                (_currentIndex == index),
                (_tappedIndex == index),
                index,
                context,
                _controller.elementAt(index));
          }).toList(),
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String title;

  NavigationItem({
    @required this.icon,
    @required this.selectedIcon,
    this.title,
  });
}

const double kCustomBottomNavbarHeight = 76.0;

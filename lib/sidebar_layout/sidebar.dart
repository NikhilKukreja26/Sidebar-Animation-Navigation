import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';

import 'menu_item.dart';
import '../blocs.navigation_bloc/navigation_bloc.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  StreamController<bool> _isSideBarOpenedStreamController;
  Stream<bool> _isSideBarOpenedStream;
  Sink<bool> _isSideBarOpenedSink;

  final bool isSideBarOpened = false;
  AnimationController _animationController;
  final _animationDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    _isSideBarOpenedStreamController = PublishSubject<bool>();
    _isSideBarOpenedStream = _isSideBarOpenedStreamController.stream;
    _isSideBarOpenedSink = _isSideBarOpenedStreamController.sink;
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _isSideBarOpenedStreamController.close();
    _isSideBarOpenedSink.close();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
    if (isAnimationCompleted) {
      _isSideBarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      _isSideBarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<Object>(
      initialData: false,
      stream: _isSideBarOpenedStream,
      builder: (context, isSideBarOpenAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenAsync.data ? 0 : 0 - screenWidth,
          right: isSideBarOpenAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: const Color(0xFF262AAA),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 50.0),
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                        title: Text(
                          'Nikhil Kukreja',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          'kukrejanikhil25@gmail.com',
                          style: TextStyle(
                            color: const Color(0xFF1BB5FD),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Divider(
                        height: 64.0,
                        thickness: 0.3,
                        color: Colors.white.withOpacity(0.3),
                        indent: 32.0,
                        endIndent: 32.0,
                      ),
                      MenuItem(
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.HomePageClickEvent);
                        },
                        iconData: Icons.home,
                        title: 'Home',
                      ),
                      MenuItem(
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.MyAccountsPageClickEvent);
                        },
                        iconData: Icons.person,
                        title: 'My Accounts',
                      ),
                      MenuItem(
                        onTap: () {
                          onIconPressed();
                          BlocProvider.of<NavigationBloc>(context)
                              .add(NavigationEvents.MyOrdersPageClickEvent);
                        },
                        iconData: Icons.shopping_basket,
                        title: 'My Orders',
                      ),
                      MenuItem(
                        iconData: Icons.card_giftcard,
                        title: 'Wishlist',
                      ),
                      Divider(
                        height: 64.0,
                        thickness: 0.3,
                        color: Colors.white.withOpacity(0.3),
                        indent: 32.0,
                        endIndent: 32.0,
                      ),
                      MenuItem(
                        iconData: Icons.settings,
                        title: 'Settings',
                      ),
                      MenuItem(
                        iconData: Icons.exit_to_app,
                        title: 'Logout',
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: 35.0,
                      height: 110.0,
                      color: const Color(0xFF262AAA),
                      child: AnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        progress: _animationController.view,
                        size: 25.0,
                        color: const Color(0xFF1BB5FD),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

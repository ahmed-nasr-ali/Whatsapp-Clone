// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, deprecated_member_use, unnecessary_new, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

class NetworkIndicator extends StatefulWidget {
  final Widget child;
  const NetworkIndicator({required this.child});
  @override
  _NetworkIndicatorState createState() => _NetworkIndicatorState();
}

class _NetworkIndicatorState extends State<NetworkIndicator> {
  double _height = 0;

  Widget _buildBodyItem() {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: _height * 0.2,
            ),
            Icon(
              Icons.signal_wifi_off,
              size: _height * 0.25,
              color: Colors.grey[400],
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'sorry..no_internet_connection',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'RB',
                      fontWeight: FontWeight.w400),
                )),
            Container(
                margin: EdgeInsets.only(top: _height * 0.025),
                child: Text(
                  'check_your_router',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                      fontFamily: 'RB',
                      fontWeight: FontWeight.w400),
                )),
            Container(
                margin: EdgeInsets.only(top: _height * 0.025),
                child: Text(
                  'reconnect_to_network',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                      fontFamily: 'RB',
                      fontWeight: FontWeight.w400),
                )),
            Container(
                height: _height * 0.09,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.25,
                    vertical: _height * 0.02),
                child: Builder(
                    builder: (context) => RaisedButton(
                          onPressed: () {},
                          elevation: 500,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0)),
                          color: Theme.of(context).primaryColor,
                          child: Container(
                              alignment: Alignment.center,
                              child: new Text(
                                'refresh_screen',
                                style: TextStyle(
                                    fontFamily: 'RB',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20.0),
                              )),
                        )))
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          final appBar = AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                'matrix',
                style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontFamily: 'RB',
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              centerTitle: true,
              actions: <Widget>[]);
          _height = MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top;
          return Scaffold(
            appBar: appBar,
            body: _buildBodyItem(),
          );
        } else {
          return child;
        }
      },
      builder: (BuildContext context) {
        return widget.child;
      },
    );
  }
}

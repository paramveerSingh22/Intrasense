import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/AppColors.dart';
import '../utils/Images.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';




class WebViewScreen extends StatefulWidget{
  @override
  _WebViewScreen createState() => _WebViewScreen();

}

class _WebViewScreen extends State<WebViewScreen>{

  @override
  void initState() {
    super.initState();
    //WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Images.headerBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 0,
            child: Stack(
              children: [
                Image.asset(
                  Images.curveOverlay,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              Images.curveBg,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 36,
            left: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'FAQs',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'PoppinsMedium',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            bottom: 60,
            // Adjust the bottom to leave space for the button
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'FAQs',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondaryOrange,
                                    fontFamily: 'PoppinsMedium'),
                              )),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child:  WebviewScaffold(
                            url: 'http://www.google.com/',
                            withJavascript: true,  // Enable JavaScript
                            withZoom: true,  // Enable zoom
                            appBar: AppBar(
                              title: const Text('FAQs'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
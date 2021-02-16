import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/common/page_transition.dart';
import 'package:filcnaplo/ui/pages/welcome/features.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xCC1A4742),
      body: Container(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 120.0),
              alignment: Alignment.topCenter,
              child: Container(
                width: 212,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 64.0,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Image.asset("assets/logo.png"),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  color: Colors.white,
                  height: 300,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        I18n.of(context).welcome,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 32.0,
                          color: Color(0xFF474747),
                        ),
                      ),
                      Text(
                        I18n.of(context).appTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "RedHatDisplay",
                          fontWeight: FontWeight.bold,
                          fontSize: 48.0,
                          color: Color(0xFF292929),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      SizedBox(
                        width: 150.0,
                        child: MaterialButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          color: Color(0xFF225B55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                I18n.of(context).begin,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                              Icon(FeatherIcons.arrowRight,
                                  color: Colors.white),
                            ],
                          ),
                          onPressed: () => Navigator.of(context,
                                  rootNavigator: true)
                              .pushReplacement(
                                  PageTransition.horizontal(FeaturesPage())),
                        ),
                      ),
                      SizedBox(height: 32.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    //start path with this if you are making at bottom

    Offset firstStart = Offset(size.width / 5, 0);
    //fist point of quadratic bezier curve
    Offset firstEnd = Offset(size.width / 2.25, 40.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    Offset secondStart = Offset(size.width - (size.width / 3.24), 80);
    //third point of quadratic bezier curve
    Offset secondEnd = Offset(size.width, 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

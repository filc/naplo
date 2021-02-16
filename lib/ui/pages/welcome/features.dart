import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:filcnaplo/ui/pages/login/page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';

class FeaturesPage extends StatefulWidget {
  @override
  _FeaturesPageState createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  SwiperController _swiper;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _swiper = SwiperController();
  }

  @override
  void dispose() {
    if (mounted) {
      _swiper.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xCC1A4742),
      body: Container(
        child: Stack(
          children: [
            Swiper(
              itemCount: 4,
              itemBuilder: (context, index) => FeaturePage(index),
              pagination: SwiperPagination(
                margin: EdgeInsets.only(bottom: 16.0),
                builder: DotSwiperPaginationBuilder(
                  size: 8.0,
                  activeSize: 12.0,
                  space: 4.0,
                  color: Colors.grey,
                  activeColor: Colors.grey[700],
                ),
              ),
              controller: _swiper,
              loop: false,
              onIndexChanged: (int n) => index = n,
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      child: Text(
                        I18n.of(context).dialogSkip,
                        style: TextStyle(
                          color: app.settings.appColor,
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => LoginPage()))),
                  TextButton(
                    child: Text(
                      I18n.of(context).dialogNext,
                      style: TextStyle(
                        color: app.settings.appColor,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      if (index != 3) {
                        _swiper.next();
                        index++;
                      } else {
                        Navigator.of(context, rootNavigator: true)
                            .pushReplacement(MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FeaturePage extends StatelessWidget {
  final int index;

  FeaturePage(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 24.0),
            padding: EdgeInsets.all(6.0),
            child: Image.asset("assets/page" + (index + 1).toString() + ".png"),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Image.asset("assets/wave" + (index + 1).toString() + ".png"),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              height: 180.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    [
                      I18n.of(context).features1,
                      I18n.of(context).features2,
                      I18n.of(context).features3,
                      I18n.of(context).features4,
                    ][index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w700,
                      fontSize: 28.0,
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

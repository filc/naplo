import 'package:flutter/material.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/generated/i18n.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutPrivacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: app.settings.theme.backgroundColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: EdgeInsets.only(top: 18.0, bottom: 4.0),
        margin: EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Html(
                  data: """
    <h2>Adatkezelési tájékoztató</h2>
    <p>A Filc Napló egy kliensalkalmazás, segítségével az e-Kréta rendszeréből letöltheted és felhasználóbarát módon
      megjelenítheted az adataidat. Ilyenkor adattovábbítás csak közvetlenül az alkalmazás és a Kréta-szerverek között
      történik, titkosított kapcsolaton keresztül. A Filc fejlesztői és üzemeltetői a személyes adataidat semmilyen célból nem másolják,
      nem tárolják és harmadik félnek nem továbbítják. Ezeket így az e-Kréta Informatikai Zrt. kezeli, az ő
      tájékoztatójukat itt találod:
      <a href="tudasbazis.ekreta.hu/pages/viewpage.action?pageId=4065038">
        https://tudasbazis.ekreta.hu/pages/viewpage.action?pageId=4065038</a>
      Azok törlésével vagy módosítával kapcsolatban keresd az osztályfőnöködet vagy az iskolád rendszergazdáját.</p>

    <p>Az alkalmazás az adatokat a telefonod tárhelyén belül titkosítatlanul tárolja. Ha ezeket törölni szeretnéd,
      távolítsd el az alkalmazást.
      Az alkalmazás a Google Playen keresztül névtelen, alapszintű használati statisztikákat gyűjt. Erre a Google
      irányelvei
      érvényesek, amiket a telefonod használatba vételekor elfogadtál. Itt tudhasz meg többet:
      <a href="https://policies.google.com/">policies.google.com</a> Ha
      az adataidat el szeretnéd távolítani a Google rendszeréből, keresd fel a
      <a href="https://myaccount.google.com">myaccount.google.com</a> oldalt.
      Az alkalmazás néhány adat letöltéséhez (iskolalista, támogatók listája) ugyan igénybe veszi a Filc Napló
      weboldalát
      (<a href="https://filcnaplo.hu/">filcnaplo.hu</a>), viszont oda nem tölt fel semmit.</p>

    <p>Ha az adataiddal kapcsolatban bármilyen kérdésed van (törlés, módosítás, adathordozás), keress minket a
      <a href="mailto:filcnaplo.hu@gmail.com">filcnaplo.hu@gmail.com</a> címen.</p>
    <p>Az alkalmazás használatával jelzed, hogy ezt a tájékoztatót tudomásul vetted.</p>
    <p>Utolsó módosítás: 2020. 08. 26.</p>
                    """,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  I18n.of(context).dialogOk,
                  style: TextStyle(color: app.settings.appColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

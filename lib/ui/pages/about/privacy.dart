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
<p>A Filc Napló egy kliensalkalmazás, segítségével az e-Kréta rendszeréből letöltheted és felhasználóbarát módon megjelenítheted az adataidat. Tanulmányi adataid csak közvetlenül az alkalmazás és a Kréta-szerverek között közlekednek, titkosított kapcsolaton keresztül.</p>
<p>A Filc fejlesztői és üzemeltetői a tanulmányi adataidat semmilyen célból nem másolják, nem tárolják és harmadik félnek nem továbbítják. Ezeket így az e-Kréta Informatikai Zrt. kezeli, az ő tájékoztatójukat itt találod: <a href="https://tudasbazis.ekreta.hu/pages/viewpage.action?pageId=4065038">https://tudasbazis.ekreta.hu/pages/viewpage.action?pageId=4065038</a>. Azok törlésével vagy módosítával kapcsolatban keresd az osztályfőnöködet vagy az iskolád rendszergazdáját.</p>

<p>Az alkalmazás néhány adat letöltéséhez (például: iskolalista, támogatók listája, konfiguráció) ugyan igénybe veszi a Filc Napló weboldalát (<a href="https://filcnaplo.hu/">filcnaplo.hu</a>), viszont oda nem tölt fel semmit.</p>
<p>Az alkalmazás belépéskor a GitHub API segítségével ellenőrzi, hogy elérhető-e új verzió, és kérésre innen is tölti le a telepítőt.</p>

<p>Amikor az alkalmazás hibába ütközik, lehetőséged van egy erről szóló jelentést továbbítani a Filc Napló Discord szerverére. Ez személyes információt nem tartalmaz, viszont az app futásáról, eszközöd típusáról részletesen beszámol, ezért küldés előtt mindenképp nézd át a jelentés tartalmát. Ezt a küldés előtt megjelenő képernyőn teheted meg.</p>
<p>A hibajelentésekhez csak a fejlesztők férnek hozzá <i>(<b>@DEV</b> rangú felhasználók)</i>.</p>

<p>Ha az adataiddal kapcsolatban bármilyen kérdésed van (törlés, módosítás, adathordozás), keress minket a filcnaplo@filcnaplo.hu címen.</p>

<p>Az alkalmazás használatával jelzed, hogy ezt a tájékoztatót tudomásul vetted.</p>

<p>Utolsó módosítás: 2021. 04. 19.</p>
<p>A tájékoztató korábbi változatai: <a href="https://github.com/filc/filc.github.io/commits/master/docs/privacy">https://github.com/filc/filc.github.io/commits/master/docs/privacy</a></p>
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

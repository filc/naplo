# Setup Guide
## Flutter telepítése
### Windows

1. **Git telepítése**
Ha nem csináltál még ilyet, a legegyszerűbb, ha egyszerűen feltelepíted a **[GitHub Desktopot](https://desktop.github.com/)**, ez a telepítő mindent elintéz.
2. **Visual Studio Code telepítése**
Mást, akár Android Studiót is használhatsz a szerkesztéshez, mi azonban egyszerűsége miatt ezt ajánljuk, valamint ebben fogunk tudni segíteni. **[Innen töltheted le.](https://code.visualstudio.com/)**
3. **Flutter környezet telepítése**
*Pár instrukció az angol leírás linkje előtt:*
A második oldalon válaszd majd a **Visual Studio Code fül**et.
Igazából a harmadik oldaltól nincs a Filchez rá szükséged, de bártan csináld végig, bevezet a Flutter használatába.
**[Itt találod a leírást.](https://flutter.dev/docs/get-started/install/windows)** 
Légy különös tekintettel az SDK helyes telepítésére, és a környezeti változók helyes beállítására.
*Tipp:* Az angol `Edit environment variables for your account` Start menü elemet magyarul `A fiók környezeti változóinak szerkesztése`-ként fogod megtalálni.

### Linux
*Feltöltés alatt...*

## Filc forráskód futtatása
1. A VS Code felületén nyisd meg a terminált `Ctrl+J`, és futtasd a `flutter doctor` parancsot, majd javísd az esetleges kritikus hibákat. *(Ha az előzőekben Visual Studio Code-ra raktad össze a Fluttered, nem kell, hogy az Android Studio-s telepítésed rendben legyen.)*
2.  Futtasd ugyanitt a `flutter channel beta` parancsot, hogy átállj a Flutter beta verziójára. A Filc csak ezzel fog működni.
3. Indíts el egy emulátort, vagy csatlakoztass egy ADB-re konfigurált telefont (az előzőekben ezt meg kellett tenned).
4. A forráskódot a `/lib` mappán belül fogod megtalálni. Az alkalmazás belépési pontja (innen "indul") a `main.dart`. Nyisd ezt meg, bal oldalt lépj a "Run" oldalra, majd kattints a `Run and Debug` gombra. Ha mindent jól csináltál, pár perc alatt az app felépül (első alkalommal, lassabb gépen akár 3-6 perc is lehet), majd megnyílik a megadott eszközön.

Kész is vagy!

[Itt találod a Contributing Guideot.](/.github/CONTRIBUTING.md)

Ha elakadtál, keress minket Discordon.

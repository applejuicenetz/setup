# appleJuice Client Setup für Windows

![](https://img.shields.io/github/license/applejuicenet/setup)
![](https://img.shields.io/github/v/release/applejuicenet/setup)
![](https://img.shields.io/github/downloads/applejuicenet/setup/total)
![](https://github.com/applejuicenet/setup/workflows/release/badge.svg)

Einfaches Windows Setup, welches den appleJuice Client installiert.

Inhalt:
- appleJuice Client 32bit
- appleJuice Client 64bit
- appleJuice Java GUI

Inkl. voll funktionsfähiger Startmenü und Desktop Verknüpfungen.
Außerdem wir das `ajfsp` Protokoll mit dem GUI verknüpft, sofern es installiert wurde.

### Details

Die appleJuice Client JAR `ajcore.jar` wird über einen sogenannten Wrapper gestartet, was vieles vereinfacht:

- es müssen keine (komplizierten) Verknüpfungen angelegt oder angepasst werden :sunglasses:
- es wird **immer** das **richtige** Java Runtime Environment (JRE) ausgewählt (32/64bit) :exclamation:
- man kann und sollte das installierte JRE in seinem Windows aktuell halten :dizzy:
- die Zuweisung des RAMs mittels `-Xmx` wird einfach über die korrespondierende `.l4j.ini` Datei angepasst :heart_eyes:
- es gibt einen **Splash Screen** für den Core :rocket: 
- 32bit und 64bit können **parallel** installiert und betrieben werden :v:
- startet man die 32/64bit Version ohne installiertes Java 32/64bit, wird man auf das Fehlen hingewiesen (inkl. Download Link) :wink:
- es gibt einen Wrapper für den `-c` bzw. `--configinjardir` Modus (für den Betrieb auf anderen Laufwerk) :floppy_disk:
- es gibt einen Wrapper für den `--nogui` Modus (zum validieren bei etwaigen Fehlern) :bug:

Die einzelnen Wrapper wurden mit dem Tool [Launch4j](http://launch4j.sourceforge.net) erstellt (siehe [launch4j](./launch4j/) Ordner).

### Setup

Das Setup wird mit [NSIS](https://nsis.sourceforge.io/Main_Page) erstellt, was es ermöglicht, dies einfach stets aktuell zu halten.
 
Die hier im Ordner liegende `.nsi` Datei kann einfach mit dem `NSIS` Compiler geöffnet werden.

Das Setup löscht eine etwaig vorhandene `ajnetmask.dll` im `?:\Windows\system32\` Ordner, da diese dort nicht (_mehr_) benötigt wird. :put_litter_in_its_place: 

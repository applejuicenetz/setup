# appleJuice Client Setup für Windows

![](https://img.shields.io/github/license/applejuicenetz/setup)
![](https://img.shields.io/github/v/release/applejuicenetz/setup)
![](https://img.shields.io/github/downloads/applejuicenetz/setup/total)
![](https://github.com/applejuicenetz/setup/workflows/release/badge.svg)

Einfache Windows Setup, welche alle Komponenten herunterladen und installieren

### Setup

Die Setups wurden mit [NSIS](https://nsis.sourceforge.io/Main_Page) erstellt.

### Multi-Setup

`nsis_applejuice_setup.nsi` lädt die Windows-jpackage-Installer für Core,
Java GUI und optional Collector aus den GitHub-Releases herunter.
Der Core kommt aus `applejuicenetz/core`, Java GUI aus `applejuicenetz/gui-java`
und Collector aus `applejuicenetz/collector`. Die Dateinamen sind
`AJCore-windows-<arch>.exe`, `AJCoreGUI-windows-<arch>.exe` und
`AJCollector-windows-<arch>.exe`; `<arch>` ist je nach Windows-System `amd64`
oder `aarch64`. Die Architektur wird beim Build festgelegt; es entstehen zwei
getrennte Multi-Setups. Der Server ist nicht Bestandteil der Multi-Setups.
Core, Java GUI und Collector verwenden jeweils das neueste Release (`latest`).
Eine feste Core-Version kann beim Build mit
`makensis -DCORE_VERSION=<tag> nsis_applejuice_setup.nsi` gewählt werden.

Die standardmäßig ausgewählte Komponente „Silent“ verwendet für jpackage
`/qn /norestart`, für die alten NSIS-Installer weiterhin `/S`.
Ohne „Silent“ zeigen die Komponenten ihren Installationsdialog; jpackage erhält
weiterhin `/norestart`, damit kein Neustart die weiteren Installationen unterbricht.
Die Multi-Setups selbst können mit `/S` unbeaufsichtigt laufen.
Collector, Apfelmus, ApplePulp und Juicer bleiben in beiden Varianten optional,
auch im ARM64-Multi-Setup. Die bestehenden Community-GUI-Installer werden
unverändert verwendet; ihre Anwendungen laufen auf ARM64 gegebenenfalls unter
Windows-Emulation, nicht als native ARM64-Builds. Die native
Windows-Architektur wird mit `${IsNativeARM64}` bzw. `${IsNativeAMD64}` aus
`x64.nsh` erkannt, auch wenn das NSIS-Programm unter Emulation läuft.
Die jeweils falsche Architektur sowie 32bit-Windows werden vor der Installation abgewiesen;
ein x86-Core wird nicht mehr angeboten.

Downloads landen im temporären NSIS-Verzeichnis und werden nach der Ausführung
gelöscht. Download- oder Installationsfehler brechen das Multi-Setup mit einem
Fehlercode ab. Ein erforderlicher Neustart wird als Exit-Code `3010` gemeldet.
Alte NSIS-Installationen von Core, Java GUI oder Collector müssen gegebenenfalls
vorher deinstalliert werden; die neuen Installer prüfen diese Altinstallationen.

Beide Multi-Setups bauen (NSIS 3.11):

```sh
bash build_nsis.sh
```

Ergebnisse: `build/appleJuice-windows-amd64.exe` und
`build/appleJuice-windows-aarch64.exe`.

Einzeln bauen: `makensis -DSETUP_ARCH=amd64 nsis_applejuice_setup.nsi` bzw.
`makensis -DSETUP_ARCH=aarch64 nsis_applejuice_setup.nsi` (mit vorhandenem
`build`-Verzeichnis). Ohne `SETUP_ARCH` wird die AMD64-Variante gebaut.

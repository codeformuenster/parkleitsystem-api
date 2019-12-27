# DEPRECATED: Parkleitsystem API Münster

This is no longer supported, please consider using https://github.com/codeformuenster/parking-decks-muenster instead.

Ein Wrapper für das Parkleitsystem des Tiefbauamts Münster (http://www5.stadt-muenster.de/parkhaeuser/). Die API lässt sich abrufen auf http://parkleit-api.codeformuenster.org/

[![wercker status](https://app.wercker.com/status/274d1e9e544844e4355435e201a4a0be/m "wercker status")](https://app.wercker.com/project/bykey/274d1e9e544844e4355435e201a4a0be)

### Docker
- `docker build -t parking_api .`
- `docker run -d -p 8080:8080 parking_api`

### Lokal ausführen
- Benötigt wird Ruby 2.1.5
- `bundle install`
- ausführen mit `unicorn -Ilib`

### New Relic Monitoring
- newrelic.yml in `config` anlegen (wird bei new relic erklärt)


Wer schon einmal ein bisschen auf muenster.de herumgesurft hat, ist sicherlich schon auf das [Parkleitsystem](http://www5.stadt-muenster.de/parkhaeuser/) des Tiefbauamtes Münster gestoßen. Das System erlaubt es seinen Nutzern die aktuell freien Parkplätze für insgesamt 16 Parkplätze, Parkhäuser und Tiefgaragen in Münsters Innenstadt abzurufen.

Dafür allein schonmal ein großes Lob. Es ist nicht selbstverständlich diese Daten frei verfügbar im Internet bereit zu stellen. Auf einer statischen Karte kann der geneigte Nutzer zudem die Standorte der Parkmöglichkeiten sehen. Zusätzlich können über Popups weitere Daten zu den einzelnen Standorten angezeigt werden. Diese umfassen Öffnungszeiten, Preise und Behinderten- und Frauenparkplätze.

Wer dann das Parkleitsystem schonmal versucht hat im Auto zu benutzen, der wird gemerkt haben, dass die Seite eher für Desktopbrowser optimiert ist. Die Idee hinter der API war es, Apps die Möglichkeit zu geben, die Daten des Parkleitsystems benutzen zu können, ohne sich selbst mit scrapen "die Finger schmutzig" zu machen.

Technisch ist die API mit einem [simplen Ruby Script](https://github.com/codeformuenster/parkleitsystem-api/blob/master/lib/parking_api.rb) realisiert. Das HTML der Parkleit-Seite wird mit [Nokogiri](http://www.nokogiri.org/) gescraped und dann in einem kleinen Cache vorgehalten, bis das Parkleitsystem neue Daten liefert. Dadurch minimiert sich auch die Last, die die API am Parkleitsystem erzeugt. Anfragen an die API werden so lange aus dem Cache beantwortet, bis eine gewisse Zeit abgelaufen ist. Als Format für die Rückgabe habe ich mich für eine GeoJSON FeatureCollection entschieden. Dafür habe ich mithilfe der OverpassAPI und [overpass-turbo.eu](http://overpass-turbo.eu/) Daten aus [OpenStreetMap](http://openstreetmap.org) exportiert und verschneide diese dann in der Parkleitsystem API mit den gescrapedten Daten aus dem Parkleitsystem.

Die API ist noch längst nicht fertig. Es fehlen noch die Informationen aus den Popups, CORS wird noch nicht unterstützt und eine Rückgabe ohne GeoJSON sind noch Ideen, die mir im Kopf herumschwirren. Wer also Lust hat, mitzuhelfen, der kann dies gerne tun. Schaut einfach auf [github.com/codeformuenster/parkleitsystem-api](https://github.com/codeformuenster/parkleitsystem-api) und helft mit!

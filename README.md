# Parkleitsystem API Münster

Ein Wrapper für das Parkleitsystem des Tiefbauamts Münster (http://www5.stadt-muenster.de/parkhaeuser/).

### Docker
- `docker build -t parking_api .`
- `docker run -d -p 8080:8080 parking_api`

### Lokal ausführen
- Benötigt wird Ruby 2.1.5
- `bundle install`
- ausführen mit `unicorn -Ilib`

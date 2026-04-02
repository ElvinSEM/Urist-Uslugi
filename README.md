# Urist Uslugi

## Run

```bash
cp .env.example .env
bundle install
npm install
bin/rails db:prepare
bin/rails db:seed
bin/dev
```

## Docker

```bash
cp .env.example .env
docker compose up --build
docker compose exec app bundle exec rails db:prepare db:seed
```

## API examples

```bash
curl http://localhost:3000/api/v1/services
```

```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"Password123!"}'
```

```bash
curl -X POST http://localhost:3000/api/v1/service_requests \
  -H "Authorization: Bearer <JWT>" \
  -H "Content-Type: application/json" \
  -d '{"service_request":{"service_id":1,"full_name":"Иван Иванов","email":"ivan@example.com","phone":"+79990001122","description":"Нужна консультация"}}'
```
# Urist-Uslugi

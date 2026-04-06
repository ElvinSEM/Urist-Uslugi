# Проект: UristUslugi

## Описание
Онлайн-сервис юридических услуг с клиентской, адвокатской и административной панелями.
Используются: Ruby on Rails 8.1.3, PostgreSQL, Tailwind CSS, Hotwire (Turbo + Stimulus).

## Пользователи
- **Admin**: полный доступ ко всем данным
- **Client**: создаёт заявки на услуги
- **Lawyer**: обрабатывает заявки и управляет статусами

## Структура базы данных
Основные модели:
- User (role: admin, client, lawyer)
- Category (категории услуг)
- Service (услуги в категориях)
- ServiceRequest (заявки клиентов)
- Notification (уведомления)

## Enum и статусы
- ServiceRequest.status: pending, in_progress, completed, rejected
- User.role: admin, client, lawyer

## Seeds
- Admin: admin@example.com / Password123!
- Client: client0…clientN@example.com
- Lawyer: lawyer0…lawyerN@example.com

## Рекомендации по коду
- Держать контроллеры тонкими
- Общую логику выносить в Concerns
- Использовать scopes и enums последовательно
- Поддерживать единый стиль и DRY
- Создавать тесты для ключевых функций

## Полезные команды
- Поднять сервер: `bin/rails server`
- Применить миграции: `bin/rails db:migrate`
- Загрузить сиды: `bin/rails db:seed`
- Просмотреть задачи rake: `bundle exec rake -T`

## Игнорируемые файлы
- `db/schema.rb`
- `/log/*`
- `/tmp/*`
- `/node_modules/*`
- `/public/assets/*`

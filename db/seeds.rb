admin = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "Password123!"
  user.first_name = "Admin"
  user.last_name = "User"
  user.role = :admin
end

client = User.find_or_create_by!(email: "client@example.com") do |user|
  user.password = "Password123!"
  user.first_name = "Client"
  user.last_name = "User"
  user.role = :client
end

lawyer = User.find_or_create_by!(email: "lawyer@example.com") do |user|
  user.password = "Password123!"
  user.first_name = "Lead"
  user.last_name = "Lawyer"
  user.role = :lawyer
end

corporate = Category.find_or_create_by!(name: "Корпоративное право") { |c| c.description = "Регистрация, сопровождение и сделки" }
realty = Category.find_or_create_by!(name: "Недвижимость") { |c| c.description = "Сделки, споры, проверка документов" }

service_one = Service.find_or_create_by!(title: "Регистрация ООО") do |service|
  service.category = corporate
  service.description = "Подготовка документов, подача и сопровождение регистрации."
  service.price_cents = 150_000
  service.position = 1
end

service_two = Service.find_or_create_by!(title: "Проверка договора купли-продажи") do |service|
  service.category = realty
  service.description = "Правовой аудит договора и рисков сделки."
  service.price_cents = 80_000
  service.position = 2
end

ServiceRequest.find_or_create_by!(service: service_one, client: client, full_name: client.full_name, email: client.email, phone: "+79990000001") do |request|
  request.description = "Нужно открыть ООО для консалтинговой деятельности."
  request.status = :pending
  request.lawyer = lawyer
end

ServiceRequest.find_or_create_by!(service: service_two, client: client, full_name: client.full_name, email: client.email, phone: "+79990000002") do |request|
  request.description = "Нужно проверить договор перед сделкой."
  request.status = :in_progress
  request.lawyer = lawyer
end

Notifications::Dispatch.call(user: client, title: "Тестовое уведомление", body: "Сидовые данные загружены")

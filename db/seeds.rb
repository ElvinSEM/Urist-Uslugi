password = "Password123!"

# === Users ===
admin = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = password
  user.first_name = "Admin"
  user.last_name = "User"
  user.role = :admin
end

lawyers = [
  { email: "lawyer0@example.com", first_name: "Lead", last_name: "Lawyer" },
  { email: "lawyer1@example.com", first_name: "Support", last_name: "Lawyer" }
].map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |user|
    user.password = password
    user.first_name = attrs[:first_name]
    user.last_name = attrs[:last_name]
    user.role = :lawyer
  end
end

clients = 3.times.map do |index|
  User.find_or_create_by!(email: "client#{index}@example.com") do |user|
    user.password = password
    user.first_name = "Client"
    user.last_name = index.zero? ? "Zero" : index.to_s
    user.role = :client
  end
end

# === Categories ===
categories = [
  { name: "Корпоративное право", description: "Регистрация, сопровождение и сделки" },
  { name: "Недвижимость", description: "Сделки, споры, проверка документов" },
  { name: "Семейное право", description: "Разводы, алименты, опека" }
].map do |attrs|
  Category.find_or_create_by!(name: attrs[:name]) do |category|
    category.description = attrs[:description]
  end
end

# === Services ===
services = [
  {
    title: "Регистрация ООО",
    category: categories[0],
    description: "Подготовка документов, подача и сопровождение регистрации.",
    price_cents: 150_000,
    position: 1
  },
  {
    title: "Проверка договора купли-продажи",
    category: categories[1],
    description: "Правовой аудит договора и рисков сделки.",
    price_cents: 80_000,
    position: 2
  },
  {
    title: "Составление брачного договора",
    category: categories[2],
    description: "Консультации и составление договора для супругов.",
    price_cents: 50_000,
    position: 3
  }
].map do |attrs|
  Service.find_or_create_by!(title: attrs[:title]) do |service|
    service.category = attrs[:category]
    service.description = attrs[:description]
    service.price_cents = attrs[:price_cents]
    service.position = attrs[:position]
  end
end

# === Service Requests ===
[
  { service: services[0], client: clients[0], lawyer: lawyers[0], status: :pending, phone: "+79990000000", description: "Нужно открыть ООО для консалтинговой деятельности." },
  { service: services[1], client: clients[1], lawyer: lawyers[0], status: :in_progress, phone: "+79990000001", description: "Нужно проверить договор перед сделкой." },
  { service: services[2], client: clients[2], lawyer: lawyers[1], status: :completed, phone: "+79990000002", description: "Хотим оформить брачный договор." }
].each do |attrs|
  ServiceRequest.find_or_create_by!(
    service: attrs[:service],
    client: attrs[:client],
    full_name: attrs[:client].full_name,
    email: attrs[:client].email,
    phone: attrs[:phone]
  ) do |request|
    request.description = attrs[:description]
    request.status = attrs[:status]
    request.lawyer = attrs[:lawyer]
  end
end

# === Notifications ===
clients.each do |client|
  Notifications::Dispatch.call(
    user: client,
    title: "Тестовое уведомление",
    body: "Сидовые данные загружены для тестирования."
  )
end

puts "✅ Сиды успешно загружены!"

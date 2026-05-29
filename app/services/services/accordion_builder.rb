module Services
  class AccordionBuilder < ApplicationService
    GROUPS = [
      {
        title: "Военные услуги",
        subtitle: "Защита прав военнослужащих, мобилизация и сопутствующие вопросы.",
        keywords: %w[воен арм мобилиз призыв службе служба]
      },
      {
        title: "Услуги для физических лиц",
        subtitle: "Бытовые, личные и частные правовые вопросы.",
        keywords: %w[физичес частн личн потребит наследств труд миграц доверен]
      },
      {
        title: "Семейное право",
        subtitle: "Семья, брак, алименты, опека и родительские вопросы.",
        keywords: %w[семейн брак развод алимент опек попеч брач]
      },
      {
        title: "Уголовные дела",
        subtitle: "Защита по уголовным делам и сопровождение на стадии следствия и суда.",
        keywords: %w[уголов следств обвин подозр защита судим]
      },
      {
        title: "Гражданские и административные дела",
        subtitle: "Споры, иски, жалобы и обжалование решений.",
        keywords: %w[гражд админ иск жалоб обжал спор претенз суд]
      },
      {
        title: "Финансовые и банковские услуги",
        subtitle: "Кредиты, долги, расчеты, банковские и финансовые вопросы.",
        keywords: %w[финан банк кредит долг ипотек платёж платеж счёт счет]
      },
      {
        title: "Недвижимость и земельное право",
        subtitle: "Сделки, аренда, земля, объекты и правовой аудит документов.",
        keywords: %w[недвиж земл квартир дом аренда сделк купли-продажи строительство строит]
      },
      {
        title: "Бизнес и хозяйственные дела",
        subtitle: "ООО, ИП, договорная работа, корпоративные и хозяйственные вопросы.",
        keywords: %w[бизнес ооо ип корпорат хозяйств коммерц регистр ликвид догово поставк подряд]
      }
    ].freeze

    RULES = [
      {
        group: "Бизнес и хозяйственные дела",
        patterns: [/регистрация ооо/i, /ликвидация компании/i, /ооо/i, /ликвид/i]
      },
      {
        group: "Недвижимость и земельное право",
        patterns: [/купли-продажи/i, /сопровождение сделки/i, /недвиж/i, /земел/i, /аренд/i]
      },
      {
        group: "Семейное право",
        patterns: [/брачного договора/i, /развод/i, /алимент/i, /опек/i, /попеч/i]
      },
      {
        group: "Услуги для физических лиц",
        patterns: [/проверка договора$/i, /проверка договора/i, /консультац/i, /личн/i, /частн/i]
      }
    ].freeze

    def initialize(services)
      @services = Array(services)
    end

    def call
      groups = GROUPS.map do |group|
        matched = @services.select { |service| category_for(service) == group[:title] }

        {
          id: group[:title].parameterize,
          title: group[:title],
          subtitle: group[:subtitle],
          count: matched.size,
          services: matched
        }
      end

      open_index = groups.index { |group| group[:count].positive? } || 0

      groups.each_with_index.map do |group, index|
        group.merge(open: index == open_index)
      end
    end

    private

    def category_for(service)
      haystack = [service.title, service.description, service.category_name].compact.join(" ")

      explicit_match = RULES.find do |rule|
        rule[:patterns].any? { |pattern| haystack.match?(pattern) }
      end

      return explicit_match[:group] if explicit_match

      keyword_match = GROUPS.find do |group|
        group[:keywords].any? { |keyword| haystack.downcase.include?(keyword) }
      end

      keyword_match&.fetch(:title) || "Услуги для физических лиц"
    end
  end
end

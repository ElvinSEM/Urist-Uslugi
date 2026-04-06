# db/migrate/20260402001300_enable_pg_extensions_and_fulltext.rb
class EnablePgExtensionsAndFulltext < ActiveRecord::Migration[8.1]
  def up
    # Включаем расширения
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
    enable_extension 'btree_gin' unless extension_enabled?('btree_gin')
    enable_extension 'unaccent' unless extension_enabled?('unaccent')

    # Добавляем GIN индекс для full-text search на русском
    unless index_exists?(:services, :search_vector)
      add_column :services, :search_vector, :tsvector, null: false, default: ''

      # Триггер для автоматического обновления search_vector
      execute <<-SQL
        CREATE OR REPLACE FUNCTION services_search_vector_update() RETURNS trigger AS $$
        BEGIN
          NEW.search_vector := 
            setweight(to_tsvector('russian', unaccent(coalesce(NEW.title, ''))), 'A') ||
            setweight(to_tsvector('russian', unaccent(coalesce(NEW.description, ''))), 'B');
          RETURN NEW;
        END
        $$ LANGUAGE plpgsql;
        
        CREATE TRIGGER services_search_vector_update
          BEFORE INSERT OR UPDATE ON services
          FOR EACH ROW EXECUTE FUNCTION services_search_vector_update();
      SQL

      add_index :services, :search_vector, using: :gin, name: 'idx_services_search_vector'
    end

    # Обновляем существующие записи
    execute <<-SQL
      UPDATE services SET search_vector = 
        setweight(to_tsvector('russian', unaccent(coalesce(title, ''))), 'A') ||
        setweight(to_tsvector('russian', unaccent(coalesce(description, ''))), 'B');
    SQL
  end

  def down
    remove_index :services, name: 'idx_services_search_vector' if index_exists?(:services, :search_vector)
    remove_column :services, :search_vector if column_exists?(:services, :search_vector)
    execute "DROP TRIGGER IF EXISTS services_search_vector_update ON services"
    execute "DROP FUNCTION IF EXISTS services_search_vector_update()"

    disable_extension 'unaccent' if extension_enabled?('unaccent')
    disable_extension 'btree_gin' if extension_enabled?('btree_gin')
    disable_extension 'pg_trgm' if extension_enabled?('pg_trgm')
  end
end
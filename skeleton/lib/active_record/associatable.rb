require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @class_name = options[:class_name]   || name.to_s.camelcase
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] ||
                   (name.to_s.underscore + '_id').to_sym
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @class_name = options[:class_name]   || name.to_s.singularize.camelcase
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] ||
                   (self_class_name.to_s.singularize.underscore + '_id').to_sym
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name, options)
    options = assoc_options[name]

    define_method(name) do
      target_class = options.model_class
      foreign_key_value = send(options.foreign_key)
      primary_key = options.primary_key

      target_class.find(foreign_key_value)
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      target_class = options.model_class
      foreign_key = options.foreign_key
      primary_key_value = send(options.primary_key)

      target_class.where({ foreign_key => primary_key_value })
    end
  end
  
  def has_one_through(name, through_name, source_name)

    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      through_table = through_options.table_name.to_s
      source_table = source_options.table_name.to_s

      s_foreign_key = source_options.foreign_key.to_s
      s_primary_key = source_options.primary_key.to_s

      t_foreign_key = self.send(through_options.foreign_key)

      result = DBConnection.execute(<<-SQL, t_foreign_key).first
          SELECT
            #{source_table}.*
          FROM
            #{through_table}
          JOIN
            #{source_table}
          ON
            #{through_table}.#{s_foreign_key} =
            #{source_table}.#{s_primary_key}
          WHERE
            #{through_table}.id = ?
        SQL

      source_options.model_class.new(result)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end

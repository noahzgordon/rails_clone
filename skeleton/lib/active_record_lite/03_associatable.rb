require_relative '02_searchable'
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

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end

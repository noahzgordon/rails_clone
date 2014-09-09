require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    relation = Relation.new(self)
    relation.where(params)
    relation
  end

  def includes(other_relation)
    relation = Relation.new(self)
    relation.includes(other_relation)
    relation
  end

  def joins(other_relation)
    relation = Relation.new(self)
    relation.where(other_relation)
    relation
  end
end

class SQLObject
  extend Searchable
end

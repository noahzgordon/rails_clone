require_relative '03_associatable'

# Phase V
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

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
end

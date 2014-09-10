class House < SQLObject
  attr_reader :address
  
  has_many(
    :humans,
    class_name: "Humans",
    foreign_key: :house_id,
    primary_key: :id
  )
end
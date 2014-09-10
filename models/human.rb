class Human < SQLObject
  attr_reader :id, :fname, :lname
  
  has_many(
    :cats,
    class_name: "Cat",
    foreign_key: :owner_id,
    primary_key: :id
  )
  
  belongs_to(
    :home,
    class_name: "House",
    foreign_key: :house_id,
    primary_key: :id
  )
end
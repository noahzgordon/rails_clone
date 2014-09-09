require "../lib/active_record/core.rb"

class Cat < SQLObject
  attr_reader :name, :owner_id, :id
  
  belongs_to (
    :owner, 
    class_name: "Human",
    foreign_key: :owner_id,
    primary_key: :id
  )
end

class Human < SQLObject
  attr_reader :id, :fname, :lname
  
  has_many (
    :cats,
    class_name: "Cat",
    foreign_key: :owner_id,
    primary_key: :id
  )
end
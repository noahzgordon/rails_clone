require_relative "../lib/active_record/core.rb"

class Cat < SQLObject
  attr_reader :name, :owner_id, :id
  
  belongs_to(
    :owner, 
    class_name: "Human",
    foreign_key: :owner_id,
    primary_key: :id
  )
  
  has_one_through :home, :owner, :home
  
end

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

class House < SQLObject
  attr_reader :address
  
  has_many(
    :humans,
    class_name: "Humans",
    foreign_key: :house_id,
    primary_key: :id
  )
end
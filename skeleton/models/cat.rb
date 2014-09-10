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
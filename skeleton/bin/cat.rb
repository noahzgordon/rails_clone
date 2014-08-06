class Cat
  attr_reader :name, :owner, :id

  $id_counter = 0

  def self.all
    @cats ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name, @owner = params["name"], params["owner"]
  end

  def save
    return false unless @name.present? && @owner.present?

    @id = $id_counter
    $id_counter += 1

    Cat.all << self
    true
  end

  def inspect
    { id: id, name: name, owner: owner }.inspect
  end
end
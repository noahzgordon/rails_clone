class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym

      define_method(name) do
        instance_variable_get(var_name)
      end

      define_method("#{name}=".to_sym) do |arg|
        instance_variable_set(var_name, arg)
      end
    end
  end
end
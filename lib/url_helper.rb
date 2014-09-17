require 'active_support/core_ext'

module UrlHelper

  def add_url_helper(controller_class, pattern, action)
    controller_name = controller_class.name

    prefix = /(.+)_controller/.match(controller_name.underscore)[1]
    single_prefix = prefix.singularize

    case action
      when :new
        define_method("new_#{prefix.singularize}_url") do
          pattern[1...-1]
        end
      when :create
        define_method("#{prefix}_url") do
          pattern[1...-1]
        end
      when :show
        define_method("#{single_prefix}_url") do |obj|
          pattern[1...-1].gsub(/\(.+\)/, obj.id.to_s)
        end
      when :index
        define_method("#{prefix}_url") do
          pattern[1...-1]
        end
      when :edit
        define_method("edit_#{single_prefix}_url") do |obj|
          pattern[1...-1].gsub(/\(.+\)/, obj.id.to_s)
        end
      when :update
        define_method("#{single_prefix}_url") do |obj|
          pattern[1...-1].gsub(/\(.+\)/, obj.id.to_s)
        end
      when :destroy
        define_method("#{single_prefix}_url") do |obj|
          pattern[1...-1].gsub(/\(.+\)/, obj.id.to_s)
        end
      else
        define_method("#{prefix}_#{action}_url") do
          pattern[1...-1]
        end
    end
  end
end

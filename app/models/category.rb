class Category < ActiveRecord::Base

  has_many :recipes
  
  extend Slugifiable::ClassMethods
  include Slugifiable::InstanceMethods
end

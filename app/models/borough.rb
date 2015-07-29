class Borough < ActiveRecord::Base
  has_many :neighborhoods
end

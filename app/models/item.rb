class Item < ApplicationRecord
  enum days:{
    "1~2日で発送": 0,
    "2~3日で発送": 1,
    "4~7日で発送": 2
  }
  belongs_to :user,required: false
  belongs_to :category,required: false
  belongs_to :brand,required: false
  has_many :images, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true
end

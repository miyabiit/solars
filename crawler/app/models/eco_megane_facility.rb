# coding: utf-8
require 'mongoid'
require_relative 'facility'

class EcoMeganeFacility < Facility
  field :prefecture,    type: String

  has_many :equipments
end

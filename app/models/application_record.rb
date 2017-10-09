class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_validation :strip_text_fields

  def strip_text_fields
    self.attributes.each do |field, val|
      self.send(field).strip! if val.respond_to?(:strip)
    end
  end
end

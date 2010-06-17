class Upload < ActiveRecord::Base
  belongs_to :page
  has_attached_file :document
end


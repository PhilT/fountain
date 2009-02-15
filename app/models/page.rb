class Page < ActiveRecord::Base
  validates_presence_of :title
  validates_format_of :name,
                      :with    => /^[a-zA-Z]+$/,
                      :message => "can't contain punctuation or numbers. a-z and A-Z only"

  def to_param
    self.name.underscore.dasherize unless self.name.nil?
  end

  def self.find_by_slug(slug)
    find_by_name(slug.underscore.classify)
  end
end

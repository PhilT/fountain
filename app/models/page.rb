class Page < ActiveRecord::Base
  include ActiveSupport::CoreExtensions::String::Inflections
  validates_presence_of :title
  validates_format_of :name, :with => /^[a-zA-Z]+$/, :message => "can't contain punctuation or numbers. a-z and A-Z only"

  def initialize(attributes = {})
    super
    self.title = self.name.titleize if self.title.blank? && !self.name.blank?
  end

  def to_param
    self.name.underscore.dasherize unless self.name.nil?
  end

  def self.from_slug(slug)
    Page.new(:name => slug.underscore.classify)
  end

  def self.find_by_slug(slug)
    find_by_name(slug.underscore.classify)
  end

  def formatted_content
    ContentFormatter.new(RedCloth.new(self.content.to_s).to_html).to_s
  end
end

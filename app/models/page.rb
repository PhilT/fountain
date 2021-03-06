class Page < ActiveRecord::Base
  has_paper_trail
  has_many :uploads, :dependent => :destroy
  accepts_nested_attributes_for :uploads, :allow_destroy => true

  validates_presence_of :title
  validates_format_of :name, :with => /^[a-zA-Z]+$/, :message => "can't contain punctuation or numbers. a-z and A-Z only"
  before_destroy :stop_homepage_destruction

  def initialize(attributes = {})
    super
    self.title = self.name.titleize if self.title.blank? && !self.name.blank?
  end

  def to_param
    self.name.underscore.dasherize unless self.name.nil?
  end

  def self.from_slug(slug)
    Page.new(:name => to_name(slug))
  end

  def self.find_by_slug(slug)
    find_by_name(to_name(slug))
  end

  def self.to_name(slug)
    slug.titleize.gsub(' ', '')
  end

  def formatted_content
    ContentFormatter.new(BlueCloth.new(self.content.to_s).to_html).to_s
  end

  def last_updated_by
    User.find(self.versions.last.whodunnit.to_i)
  end

private
  def stop_homepage_destruction
    return false if self.name == 'HomePage'
  end
end


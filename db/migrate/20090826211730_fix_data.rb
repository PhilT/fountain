class FixData < ActiveRecord::Migration
  def self.up
    Page.all.each do |page|
      page.update_attribute(:name, page.title)
    end
  end

  def self.down
  end
end

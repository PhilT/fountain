class RemoveNameFromUploads < ActiveRecord::Migration
  def self.up
    remove_column :uploads, :name
  end

  def self.down
    add_column :uploads, :name, :string
  end
end


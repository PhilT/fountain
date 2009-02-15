class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.text :content
      t.boolean :public, :default => true

      t.timestamps
    end

    Page.create!(:name => 'HomePage', :title => 'Home Page', :content => 'AnotherPage')
  end

  def self.down
    drop_table :pages
  end
end

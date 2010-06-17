class AddAttachmentsDocumentToUpload < ActiveRecord::Migration
  def self.up
    add_column :uploads, :document_file_name, :string
    add_column :uploads, :document_content_type, :string
    add_column :uploads, :document_file_size, :integer
    add_column :uploads, :document_updated_at, :datetime
  end

  def self.down
    remove_column :uploads, :document_file_name
    remove_column :uploads, :document_content_type
    remove_column :uploads, :document_file_size
    remove_column :uploads, :document_updated_at
  end
end

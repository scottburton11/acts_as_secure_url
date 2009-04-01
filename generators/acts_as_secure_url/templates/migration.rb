class <%= class_name.pluralize %>ActsAsSecureUrl < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>", :force => true do |t|
      
      <% if options[:persist_public_key] %>
      t.column :public_key,                :string, :limit => 256      
      <% end %>
      t.column :access_key,                :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime

    end
  end

  def self.down
    drop_table "<%= table_name %>"
  end
end

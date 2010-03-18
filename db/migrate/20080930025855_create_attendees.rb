class CreateAttendees < ActiveRecord::Migration
  def self.up
    create_table :attendees do |t|
      t.column :name, :string
      t.column :email, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :attendees
  end
end

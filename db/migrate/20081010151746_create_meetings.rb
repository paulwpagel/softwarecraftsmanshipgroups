class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.column  :title,           :string
      t.column  :speaker,         :string
      t.column  :description,     :text
      t.column  :time,            :datetime 
      t.column  :location,        :text
      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end

class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device
      t.string :port
      t.string :label

      t.timestamps
    end
  end
end

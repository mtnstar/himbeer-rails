class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :device
      t.integer :gpio_port

      t.timestamps
    end
  end
end

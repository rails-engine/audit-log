# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :title
      t.integer :user_id

      t.timestamps
    end
  end
end

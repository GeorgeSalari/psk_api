# frozen_string_literal: true

class CreateCallRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :call_requests do |t|
      t.string :contact_name, null: false
      t.string :phone, null: false
      t.string :comment
      t.datetime :email_sent_at
      t.boolean :called, default: false, null: false

      t.timestamps
    end

    add_index :call_requests, :called
  end
end

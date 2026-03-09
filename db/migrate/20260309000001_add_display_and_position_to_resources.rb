# frozen_string_literal: true

class AddDisplayAndPositionToResources < ActiveRecord::Migration[8.1]
  def change
    add_column :certificates, :display, :boolean, default: false, null: false
    add_column :certificates, :position, :integer, default: 0, null: false

    add_column :products, :display, :boolean, default: false, null: false
    add_column :products, :position, :integer, default: 0, null: false

    add_column :vacancies, :display, :boolean, default: false, null: false
    add_column :vacancies, :position, :integer, default: 0, null: false

    add_index :certificates, [ :display, :position ]
    add_index :products, [ :display, :position ]
    add_index :vacancies, [ :display, :position ]
  end
end

# frozen_string_literal: true

class CreateVacancies < ActiveRecord::Migration[8.1]
  def change
    create_table :vacancies do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end

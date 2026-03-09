# frozen_string_literal: true

class AddPhotoPositionsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :photo_positions, :jsonb, default: []
  end
end

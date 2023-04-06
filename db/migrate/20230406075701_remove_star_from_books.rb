class RemoveStarFromBooks < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :star, :float
  end
end

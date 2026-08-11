class AddThreadingToPosts < ActiveRecord::Migration[8.1]
  def change
    add_reference :posts, :parent, null: true, foreign_key: { to_table: :posts, on_delete: :cascade }
  end
end

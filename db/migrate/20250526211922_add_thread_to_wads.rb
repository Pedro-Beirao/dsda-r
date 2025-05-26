class AddThreadToWads < ActiveRecord::Migration[7.1]
  def change
    add_column :wads, :forum_thread, :string
  end
end

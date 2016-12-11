class CreateReviewAssignment < ActiveRecord::Migration[5.0]
  def up
    create_table :review_assignments do |t|
      t.datetime :deadline, null: false

      t.references :user, foreign_key: true, null: false
      t.references :talk, foreign_key: true, null: false
      t.references :review, foreign_key: true
    end

    change_table :reviews do |t|
      t.boolean :approved, default: false
      t.timestamps
    end
  end

  def down
    drop_table :review_assignments

    change_table :reviews do |t|
      t.remove :approved, :created_at, :updated_at
    end
  end
end

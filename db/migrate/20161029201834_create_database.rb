class CreateDatabase < ActiveRecord::Migration[5.0]
  # columns are nullable by default
  # default length for 'string' column is 255
  # default length for 'text' column is 65535

  def change
    create_table :users do |t|
      t.string :firstname, limit: 50, null: false
      t.string :lastname, limit: 50, null: false
      t.string :email, limit: 60, null: false
      t.string :password, null: false
      t.string :password_reset_token, limit: 255
      t.datetime :password_reset_sent_at
      t.string :confirmation_token, limit: 255, null: false
      t.datetime :confirmed_at
      t.datetime :remember_at
      t.text :bio
      t.string :nickname, limit: 50
      t.string :affiliation, limit: 2048
      t.string :phone, limit: 21
      t.string :avatar
      t.boolean :email_public, default: true
      t.boolean :phone_public, default: false

      t.index :email, unique: true
      t.index :password, unique: true
      t.index :password_reset_token, unique: true
      t.index :confirmation_token, unique: true
      t.index [:firstname, :lastname]
    end

    create_table :roles do |t|
      t.string :name, limit: 50
      t.string :description, limit: 2048
    end

    create_table :conferences do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :logo
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.datetime :registration_start_date
      t.datetime :registration_end_date
      t.integer :ticket_limit

      t.index :title
      t.index :start_date
    end

    create_table :topics do |t|
      t.string :name, null: false
    end

    create_table :venues do |t|
      t.string :name, null: false
      t.string :website
      t.text :description, limit: 2048
      t.string :country, limit: 2, null: false
      t.string :city, limit: 50, null: false
      t.string :street, limit: 50, null: false
      t.string :postal_code, limit: 10, null: false
      t.string :latitude, limit: 25
      t.string :longitude, limit: 25
      t.string :photo
    end

    create_table :rooms do |t|
      t.integer :size, limit: 2, null: false
      t.string :number, limit: 6, null: false

      t.references :venue, null: false
    end

    create_table :sponsors do |t|
      t.string :name, null: false
      t.text :description, limit: 2048
      t.string :website
      t.string :logo
    end

    create_table :sponsorships do |t|
      t.integer :amount, null: false
      t.string :currency, limit: 3, null: false

      t.references :sponsor, null: false
      t.references :conference, null: false
    end

    create_table :schedule_days do |t|
      t.boolean :public, null: false, default: true
      t.datetime :day, null: false

      t.references :conference, null: false
      t.index :day
    end

    create_table :talks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :slides
      t.boolean :public, default: true
      t.boolean :highlighted, default: false
      t.datetime :start_time

      t.references :topic, null: false
      t.references :room
      t.references :schedule_day, foreign_key: {on_delete: :nullify}

      t.index :title
    end

    create_table :reviews do |t|
      t.string :title, null: false
      t.text :content, null: false

      t.references :talk, null: false
      t.references :user, null: false
    end

    create_table :registration_types do |t|
      t.string :name, limit: 50, null: false
      t.string :description
      t.boolean :requires_ticket, default: false
      t.integer :amount
      t.string :currency, limit: 3

      t.references :conference, null: false
    end

    create_table :registrations do |t|
      t.datetime :registered_at, null: false

      t.references :conference, null: false
      t.references :user, null: false
      t.references :registration_type, null: false
    end

    create_table :tickets do |t|
      t.datetime :created_at, null: false
      t.integer :quantity, limit: 2, null: false, default: 1
      t.integer :price, null: false
      t.string :currency, limit: 3, null: false
      t.boolean :paid, null: false, default: false

      t.references :registration, foreign_key: {on_delete: :cascade}
    end

    create_join_table :roles, :users do |t|
      t.index [:user_id, :role_id], unique: true
      t.index [:role_id]
    end
    add_foreign_key :roles_users, :users, on_delete: :cascade
    add_foreign_key :roles_users, :roles, on_delete: :cascade

    create_join_table :talks, :users do |t|
      t.index [:user_id, :talk_id], unique: true
      t.index [:talk_id, :user_id], unique: true
    end
    add_foreign_key :talks_users, :users, on_delete: :cascade
    add_foreign_key :talks_users, :talks, on_delete: :cascade

    create_join_table :topics, :users do |t|
      t.index [:user_id, :topic_id], unique: true
      t.index [:topic_id]
    end
    add_foreign_key :topics_users, :users, on_delete: :cascade
    add_foreign_key :topics_users, :topics, on_delete: :cascade

    create_join_table :conferences, :topics do |t|
      t.index [:conference_id, :topic_id], unique: true
      t.index [:topic_id, :conference_id], unique: true
    end
    add_foreign_key :conferences_topics, :conferences, on_delete: :cascade
    add_foreign_key :conferences_topics, :topics, on_delete: :cascade
  end
end

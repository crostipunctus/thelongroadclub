class CreateCommunity < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.text :bio
      t.string :location
      t.string :avatar_color, null: false, default: "green"
      t.integer :role, null: false, default: 0
      t.boolean :verified, null: false, default: false
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true

    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :color, null: false, default: "green"
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :categories, :slug, unique: true

    create_table :discussions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body, null: false
      t.integer :status, null: false, default: 0
      t.boolean :featured, null: false, default: false
      t.boolean :pinned, null: false, default: false
      t.integer :views_count, null: false, default: 0
      t.integer :replies_count, null: false, default: 0
      t.datetime :last_posted_at, null: false
      t.timestamps
    end
    add_index :discussions, :slug, unique: true
    add_index :discussions, [:pinned, :last_posted_at]

    create_table :posts do |t|
      t.references :discussion, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.datetime :edited_at
      t.timestamps
    end
    add_index :posts, [:discussion_id, :created_at]

    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :discussion, null: false, foreign_key: true
      t.timestamps
    end
    add_index :bookmarks, [:user_id, :discussion_id], unique: true

    create_table :events do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :description, null: false
      t.string :location, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at
      t.integer :capacity
      t.integer :rsvps_count, null: false, default: 0
      t.boolean :published, null: false, default: false
      t.timestamps
    end
    add_index :events, :slug, unique: true
    add_index :events, [:published, :starts_at]

    create_table :event_rsvps do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.timestamps
    end
    add_index :event_rsvps, [:event_id, :user_id], unique: true

    create_table :garage_features do |t|
      t.references :user, foreign_key: true
      t.string :owner_name, null: false
      t.string :slug, null: false
      t.string :title, null: false
      t.text :summary, null: false
      t.text :story, null: false
      t.integer :car_year, null: false
      t.string :car_make, null: false
      t.string :car_model, null: false
      t.string :city, null: false
      t.boolean :featured, null: false, default: false
      t.datetime :published_at
      t.timestamps
    end
    add_index :garage_features, :slug, unique: true
    add_index :garage_features, [:featured, :published_at]

    create_table :guides do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :slug, null: false
      t.string :section, null: false
      t.text :summary, null: false
      t.text :body, null: false
      t.integer :read_time_minutes, null: false, default: 5
      t.datetime :published_at
      t.timestamps
    end
    add_index :guides, :slug, unique: true
    add_index :guides, :published_at

    create_table :newsletter_subscriptions do |t|
      t.string :email, null: false
      t.integer :status, null: false, default: 0
      t.string :source, null: false, default: "homepage"
      t.datetime :confirmed_at
      t.timestamps
    end
    add_index :newsletter_subscriptions, :email, unique: true
  end
end

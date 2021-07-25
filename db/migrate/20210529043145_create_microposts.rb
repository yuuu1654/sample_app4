class CreateMicroposts < ActiveRecord::Migration[6.0]
  def change
    create_table :microposts do |t|
      t.text :content
      #データにnullが入らないようにしておく
      #この外部キーは他のテーブルを参照するためのモノであるとRailsからSQLに伝える
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    #複合keyindex
    #→よくあるクエリを高速化する為に使う
    add_index :microposts, [:user_id, :created_at]
  end
end

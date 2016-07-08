class CreateTweetUsers < ActiveRecord::Migration
  def change
  	create_table :tweet_users do |t|
  		t.belongs_to :user, index:true
  		t.string :tweet
  		t.integer :user_id
  		
  		t.timestamps
  	end
  end
end

class CreateTweets < ActiveRecord::Migration
  def change
  	create_table :tweets do |t|
  		t.belongs_to :twitter_user, index:true
  		t.string :tweets
  		t.integer :twitter_user_id
  	end
  end
end

class CreateTwitterUsers < ActiveRecord::Migration
  def change
  	create_table :twitter_users do |t|
  		t.string :twitter_handle
  		t.string :name
  		t.string :token
			t.string :secret_token


  		t.timestamps
  	end
  end
end

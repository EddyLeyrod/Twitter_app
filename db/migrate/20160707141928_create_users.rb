class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :email
  		t.string :name
  		t.string :token
			t.string :secret_token

  		t.timestamps
  	end

  end
end
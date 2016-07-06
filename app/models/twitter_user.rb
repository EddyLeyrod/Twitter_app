class TwitterUser < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweets

  def self.search_user_handler(user_name)
  	user = self.find_by(twitter_handle: "#{user_name}")
    if user != nil
    	user
    else
     	nil
    end   
	end  
end

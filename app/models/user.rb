class User < ActiveRecord::Base
  # Remember to create a migration!

	def tweet_user_conection
		p "MODIFICANDO TWEETERS" * 10
	  client = Twitter::REST::Client.new do |config|
	
	    config.consumer_key        = ENV["TWITTER_KEY"]
	    config.consumer_secret     = ENV["TWITTER_SECRET"]
	    config.access_token        = self.token
	    config.access_token_secret = self.secret_token
	  end
	  client
	end


	def self.search_user(email)
		p "BUSCANDO" * 10
	    user = User.find_by(email: email)
	    if user 
	      return user
	    else
	      nil
	    end
	  end

end
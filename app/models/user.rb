class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweet_users

	def tweet_user_conection
	  client = Twitter::REST::Client.new do |config|
	
	    config.consumer_key        = ENV["TWITTER_KEY"]
	    config.consumer_secret     = ENV["TWITTER_SECRET"]
	    config.access_token        = self.token
	    config.access_token_secret = self.secret_token
	  end
	  client
	end

	def self.search_user(email)
	  user = User.find_by(email: email)
	  if user 
	    return user
	  else
	    nil
	  end
	end

	def tweet_later(text)
   	tweet = TweetUser.create(tweet: text, user_id: self.id) # Crea un tweet relacionado con este usuario en la tabla de tweets
    # Este es un método de Sidekiq con el cual se agrega a la cola una tarea para ser
    # 
    TweetWorker.perform_async(tweet.id)
    #La última linea debe de regresar un sidekiq job id
  end

end
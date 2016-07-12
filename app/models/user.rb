class User < ActiveRecord::Base
  # Remember to create a migration!
  has_many :tweet_users

	def tweeting(text)
		p "**user conecion"
	  client = Twitter::REST::Client.new do |config|
	
	    config.consumer_key        = ENV["TWITTER_KEY"]
	    config.consumer_secret     = ENV["TWITTER_SECRET"]
	    config.access_token        = self.token
	    config.access_token_secret = self.secret_token
	  end
	  client.update!(text)
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
		p "**inside tweet_later" 
		p "Tweet text: #{text}"
   	tweet = TweetUser.create(tweet: text, user_id: self.id) # Crea un tweet relacionado con este usuario en la tabla de tweets
   	p tweet 
   	p tweet.id
   	
    # Este es un método de Sidekiq con el cual se agrega a la cola una tarea para ser
    TweetWorker.perform_in(10.seconds, tweet.id)
    #La última linea debe de regresar un sidekiq job id
  end

end
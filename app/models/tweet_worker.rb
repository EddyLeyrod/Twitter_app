class TweetWorker
  # Remember to create a migration!
  include Sidekiq::Worker

  def perform(tweet_id)
  	p "**inside perform"
    p tweet_id
  	# Encuentra el tweet basado en el 'tweet_id' pasado como argumento
    tweet = TweetUser.find(tweet_id)
    # Utilizando relaciones deberás encontrar al usuario relacionado con dicho tweet
		user  = tweet.user
    
    # Manda a llamar el método del usuario que crea un tweet (user.tweet)
    p "CREA TWEET"
    p "Tweet: #{tweet} Usuario_id: #{user}"

    user.tweeting("#{tweet.tweet}")	

  end
end

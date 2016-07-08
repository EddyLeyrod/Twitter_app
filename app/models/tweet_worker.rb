class TweetWorker < ActiveRecord::Base
  # Remember to create a migration!
  include Sidekiq::Worker

  def perform(tweet_id)
  	p "perform **" * 10
  	# Encuentra el tweet basado en el 'tweet_id' pasado como argumento
    tweet = TweetUser.find(tweet_id)
    # Utilizando relaciones deberás encontrar al usuario relacionado con dicho tweet
		user  = tweet.user_id
    # Manda a llamar el método del usuario que crea un tweet (user.tweet)
    p "CREA TWEET"
    p "Tweet: #{tweet} Usuario_id: #{user}"

    current_user.tweet_user_conection.update("#{tweet}")	

  end
end

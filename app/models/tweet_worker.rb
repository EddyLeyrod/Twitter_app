class TweetWorker < ActiveRecord::Base
  # Remember to create a migration!
  include Sidekiq::Worker

  def perform(tweet_id)
     tweet = Tweet.find(tweet_id)# Encuentra el tweet basado en el 'tweet_id' pasado como argumento
     user  = tweet.id # Utilizando relaciones deberás encontrar al usuario relacionado con dicho tweet

    # Manda a llamar el método del usuario que crea un tweet (user.tweet)
  end
end

require 'sinatra/base'
require 'rack-flash'
enable :sessions
use Rack::Flash

get '/' do
	flash[:notice] = "Bienvenido"
  erb :index
end

post '/fetch' do
	handle = params[:handler]  
  #buscar al usuariio en twitter
  user = CLIENT.user_search(handle).first if handle
	#busca al usuario en la base de datos
  if user
  p  @user_exist = TwitterUser.search_user_handler(user.screen_name)
  else
  	p "*"*50
  	p "no se encontro usuario"
  	flash.now[:warning] = "No encontramos un usuario con ese nombre"  
  end 

  if @user_exist
  		redirect "/username/#{user.screen_name}"
  else
   		redirect "/handle/#{handle}"
  end
end

#crecaion de tweets
post '/tweet' do
	tweet = params[:tweet]
	unless tweet == ""
		CLIENT.update("#{tweet}")	
		flash.now[:notice] = "Perfecto tu tweet se a creado!!"
		
	else
		flash.now[:notice] = "Vamos escribe algun tweet"
		erb :index		
	end
	#	redirecciona al twitter del usuario
	#	redirect to("https://twitter.com/search?q=#{handle}&page=1&count=1")   
end

			
get '/handle/:handle' do
	flash.now[:notice] = "Has buscado un nuevo twitter!!"
  name = params[:handle]
	##BUSCA el usuario en twitter con ese nombre obtiene un objeto
	user = CLIENT.user_search(name).first
	##obtiene los datos  de el usuario con ese nombre
	if user
	    @full_name = user.name
	    @created_at = user.created_at    
	    @user_id = user.id
	    @screen_name = user.screen_name
	    #---OBTIENE LOS TWEET ESCRITOS POR EL USUARIO
		 	@time_tweet_user =  CLIENT.user_timeline("#{@screen_name}", options={:count => 10})
	  	#----OBTIENE LOS TWEETS DONDE APARECE EL USUARIO
	 	  @tweets_relations = CLIENT.search("#{@screen_name}").take(10)
	 	   # Se crea un TwitterUser si no existe en la base de datos 	 	  
		  new_twitter_handle = TwitterUser.create(twitter_handle: @screen_name)
		  @time_tweet_user.each do |tweet|
		   	Tweet.create(tweets: tweet.text, twitter_user_id: new_twitter_handle.id )
		  end		 
		  flash.now[:notice] = "Lo que encontramos mas cercano a ti!!!"
	 	  erb :relation_tweet

	 	else
	 	flash.now[:notice] = "No quieres buscar a nadie"
		erb :index		

	end
end

get '/username/:handle' do
	flash.now[:notice] = "Parece que esto ya lo habias buscado!!!"
	name = params[:handle]
	user_handle = TwitterUser.find_by(twitter_handle: "#{name}")
	@name_handle = user_handle.twitter_handle
	@tweets_user = user_handle.tweets


  if @tweets_user.empty?
  	flash.now[:warning] = "Pero no hay tweets, vamos por ellos"  
		user = CLIENT.user_search(name).first
		@time_tweet_user =  CLIENT.user_timeline("#{user.screen_name}", options={:count => 10})
		@time_tweet_user.each do |tweet|
		   	Tweet.create(tweets: tweet.text, twitter_user_id: user_handle.id )
		end		
		erb :tweets
	else
		
  	  # "usuario con tweets en la base se manda el cache"  	
  	  #"VERIFICAR SI LOS TWEETS ESTAS ACTUALIZADOS"  	
  		#"**********ultimo_tweet_base de datos********" 
  		@tweet_last = @tweets_user.first.tweets
  		# "**********ultimo_tweet_actualizado********" 
  		tweets_updates =  CLIENT.user_timeline("#{user_handle.twitter_handle}", options={:count => 1})
  		tweets_updates.each do |tweet|
	  			#sie el ultimo tweet esta igual no hay nuevos
	  		if tweet.text == @tweet_last		  				
		  			flash.now[:warning] = "Tenemos algunos tweets de este usuario"
		  			@tweets_user = user_handle.tweets
		  			erb :tweets
		  	else #si no hay nuevos #actualizar base de datos
		  		flash.now[:notice] = "Parece que emos encontrado nuevos tweets"
		  			flash.now[:warning] = "Porque no actulizas para verlos"
		  			@tweets_user.delete_all
		  			#buscar los 10 nuevos
		  			@tweets_updates_news =  CLIENT.user_timeline("#{user_handle.twitter_handle}", options={:count => 10})
		  			#guardarlos
		  			@tweets_updates_news.each do |tweet|
						   	Tweet.create(tweets: tweet.text, twitter_user_id: user_handle.id)
						end		 
						# "tweets guardados y actualizados"					
		  	end	#IF SI HAY TWEET IGUAL
  		end #EACH TWEETS UPDATES   		
  erb :tweets
	end#if empty?
end
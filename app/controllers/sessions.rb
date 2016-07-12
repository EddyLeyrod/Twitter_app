=begin
	El flujo de OAuth es de la siguiente manera.
  Nuestra app crea un formulario para autenticarse con Twitter
  El usuario hace click en el link para autenticarse
  El usuario es redirigido a Twitter para autorizar a nuestra app, dando sus credenciales
  El usuario es redirigido de regreso a nuestra app ('callback URL')
  Nuestra aplicación verifica que el proceso fue valido.
  Si es valido obtenemos los tokens necesarios del usuario para poder actuar en su nombre
=end

get '/sign_in' do
  session[:email] ||= params[:email]
  p "buscando usuario"
  user_exist = User.search_user(params[:email])
  if user_exist
    p "usuario existente conectar con los tokens guardados"
    session[:user_id] ||= user_exist.id
    redirect to('/myapp')
  else    
  # El método `request_token` es uno de los helpers
  # Esto lleva al usuario a una página de twitter donde sera autentificado con sus credenciales
  redirect request_token.authorize_url(:oauth_callback => "http://#{host_and_port}/auth")
  # Cuando el usuario otorga sus credenciales es redirigido a la callback_url 
  # Dentro de params twitter regresa un 'request_token' llamado 'oauth_verifier'
  end
end

get '/auth' do
	params[:oauth_token]
  # "Volvemos a mandar a twitter el 'request_token' a cambio de un 'acces_token' "
  # Este 'acces_token' lo utilizaremos para futuras comunicaciones.   
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # Despues de utilizar el 'request token' ya podemos borrarlo, porque no vuelve a servir. 
  session.delete(:request_token)
  # Aquí es donde deberás crear la cuenta del usuario y guardar usando el 'acces_token' lo siguiente:
  # nombre, oauth_token y oauth_token_secret
  # No olvides crear su sesión 
  nombre = @access_token.params.values_at("screen_name").first 
  oauth_token = @access_token.token
  oauth_token_secret = @access_token.secret
  p "**Guarda usuario nuevo**" * 5
  user_current = User.find_or_create_by(email: session[:email], name: nombre, token: oauth_token, secret_token: oauth_token_secret)
  user_current =  User.find_by(email: session[:email])
  session[:user_id] ||= user_current.id
  redirect to('/myapp')
end

# Para el signout no olvides borrar el hash de session
get '/log_out' do
  session.clear
  redirect to("/")
end

#antes de entrar al contenido validar
before '/myapp' do
  if session[:email] == nil
      flash.now[:warning] = "Debes iniciar session"
    redirect to("/")
  end
end

#mostrar contenido para tweets & search users
get '/myapp' do 
  p "Inicio: #{current_user.name}"
  flash[:notice] = "Bienvenido #{current_user.name}"
  
  erb :myapp
end
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
	params[:email]
  p "*** inicio de sesion" * 10
  p session[:email] ||= params[:email]
  
  # El método `request_token` es uno de los helpers
  # Esto lleva al usuario a una página de twitter donde sera autentificado con sus credenciales
  redirect request_token.authorize_url(:oauth_callback => "http://#{host_and_port}/auth")
  # Cuando el usuario otorga sus credenciales es redirigido a la callback_url 
  # Dentro de params twitter regresa un 'request_token' llamado 'oauth_verifier'
end

get '/auth' do
	params[:oauth_token]
  # Volvemos a mandar a twitter el 'request_token' a cambio de un 'acces_token' 
  # Este 'acces_token' lo utilizaremos para futuras comunicaciones.   
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # Despues de utilizar el 'request token' ya podemos borrarlo, porque no vuelve a servir. 
  session.delete(:request_token)

  # Aquí es donde deberás crear la cuenta del usuario y guardar usando el 'acces_token' lo siguiente:
  # nombre, oauth_token y oauth_token_secret
  # No olvides crear su sesión 

  

  p session[:email] ||= params[:email]
  p oauth_token = @access_token.token
  p oauth_token_secret = @access_token.secret
  p nombre = @access_token.params.values_at("screen_name").first 
  
  redirect to('/myapp')
end

# Para el signout no olvides borrar el hash de session
get '/log_out' do
  #Cerrar Sesión
  session.clear
  session[:message] = "Cerraste sesion"
  redirect to("/")
end
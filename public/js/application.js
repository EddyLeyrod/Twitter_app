$(document).ready(function() {
	// Este código corre después de que `document` fue cargado(loaded) 
	// completamente. 
	// Esto garantiza que si amarramos(bind) una función a un elemento 
	// de HTML este exista ya en la página. 

  job_id ="";


  $('#update_tweets').click(function() {
    location.reload(); //actualiza nuevos tweets
  });

  $(".loading").hide();

  $( "#form_tweet" ).on( "submit", function( event ) {
  	event.preventDefault(); //detenemos el proceso
    var info = $("#form_tweet" ).serialize();//mensaje
    var tweet = $("#tweet_text").val();
     $(".loading").show();

    $.post( "/tweet", info ,function( data ) {
      console.log("post ajax");
      $(".loading").hide();
      $( "#new_tweet" ).css("display","block");
      $( "#new_tweet" ).html(tweet);
      job_id = data

      var interval_check = setInterval(
        function(){

          $.get("/status/"+job_id, function(data) {
            console.log("get status ajax");          
              if(data == "true") {
                $( "#flash" ).html("Tu tweet a sido posteado");
                clearInterval(interval_check);
              }else{
                console.log("tweet en proceso");          
              }
                
          }); 
        }
        , 3000);
      
    });
	});   
});










// metodo .submit()
// funciona mandando el valor de un form 
// se le puede pasar una funcionque la ejevute al hcer click

//metodo .serialize()
//codifica una cadena de valores o elementos del formulario 
//para enviar la entrega e una cadna de texto

// metodo .post()  $(selector).post(URL,data,function(data,status,xhr),dataType)
// carga datos archivos desde el servidor
// usando un requisito HTTP POST

// metodo on() 
// realizan una accion sobre elementos datos funciones -
$(document).ready(function() {
	// Este código corre después de que `document` fue cargado(loaded) 
	// completamente. 
	// Esto garantiza que si amarramos(bind) una función a un elemento 
	// de HTML este exista ya en la página. 


$('#update_tweets').click(function() {
    location.reload(); //actualiza nuevos tweets
});

$( "#form_tweet" ).on( "submit", function( event ) {
    alert("Tu tweet va ser creado");
  	event.preventDefault(); //detenemos el proceso
    var info = $("#form_tweet" ).serialize();//mensaje
    var tweet = $("#tweet_text").val();
    console.log(info);
    console.log(tweet);

    $.post( "/tweet", info ,function( data ) {
      console.log(data);
      $( "#flash" ).html(data);
      $( "#new_tweet" ).css("display","block");
      $( "#new_tweet" ).html(tweet);

      //$("#tweet").appen('<div id="tweet_new" >'+tweet+'</div><br><br><br><br><br><br>');
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
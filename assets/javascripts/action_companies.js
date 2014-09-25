$(function() {
    $(".draggable").draggable({
        appendTo: 'body', helper:'clone'
    });
    $(".droppable").droppable({
        accept: ".draggable",
        activeClass: "ui-state-default",
        drop: function( event, ui ) {
            $( this )
                .find("ol").append( ui.draggable );
        }
    });
    $("#save").click(function(event){
        event.preventDefault();
        var ids = [];
        $("#assigned_companies").find("li").each(function(){
          var id = this.id.match(/\d+/)[0];
          ids.push(id);
        });
        console.log(ids);
        $.ajax({
            type: "POST",
            dataType: 'json',
            contentType: 'application/json',
            url: $(location).attr('href').replace(window.location.search,'')+"/add_companies",
            data: JSON.stringify({"ids":ids}),
            complete: function(){
                location.reload(true);
            }

        });

    })
});


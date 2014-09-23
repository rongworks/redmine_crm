$(function() {
    $(".draggable").draggable({
        appendTo: 'body', helper:'clone'
    });
    $(".droppable").droppable({
        drop: function( event, ui ) {
            $( this )
                .find("ol").append( ui.draggable );
        }
    });
});


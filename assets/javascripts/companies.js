/**
 * Created by Rong on 12.06.2014.
 */
$(function() {

    $( ".accordion" ).accordion({
        collapsible: true
    });


    //get all input boxes with class "autoc"
    $('.autoc').each(function(){

        //reference input and get it's url
        var input = $(this);
        var url = input.data('source');

        //when request is received, add autocomplete using the returned data
        input.autocomplete({
         source: url,
         minLength: 2
        });
    });

    function split( val ) {
        return val.split( /,\s*/ );
    }
    function extractLast( term ) {
        return split( term ).pop();
    }

    $('.autoc_multi').each(function(){
        var input = $(this);
        var url = input.data('source');

           // don't navigate away from the field on tab when selecting an item
        input.bind( "keydown", function( event ) {
            if ( event.keyCode === $.ui.keyCode.TAB &&
                $( this ).data( "ui-autocomplete" ).menu.active ) {
                event.preventDefault();
            }
        });
        input.autocomplete({
            minLength: 2,
            source: function( request, response ) {
                 // delegate back to autocomplete, but extract the last term
                response( $.ui.autocomplete.filter(
                    url, extractLast( request.term ) ) );
            },
            focus: function() {
                // prevent value inserted on focus
                return false;
            },
            select: function( event, ui ) {
                var terms = split( this.value );
                // remove the current input
                terms.pop();
                // add the selected item
                terms.push( ui.item.value );
                // add placeholder to get the comma-and-space at the end
                terms.push( "" );
                this.value = terms.join( ", " );
                return false;
            }
        });
    });

    $("#tabs").tabs({  selected: $(this).data("selected") });
});
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
});
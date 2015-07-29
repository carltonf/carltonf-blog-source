$(function(){
    $('#sidebar').on('hidden.bs.collapse', function(){
        $('#page-content').removeClass("col-lg-9");
        $('#page-content').addClass('col-lg-10 col-lg-offset-1');
    })

    // The two steps in showing sidebar is necessary to avoid intermediate
    // display issue.
    $('#sidebar').on('show.bs.collapse', function(e){
        if( $('#page-content').hasClass('col-lg-offset-1') ){
            $('#page-content').removeClass('col-lg-10 col-lg-offset-1');
            $('#page-content').addClass("col-lg-9");
            return e.preventDefault();
        }
    })

    // only really show the sidebar after layout updated.
    $('#page-content').on('transitionend', function(){
        // TODO a separate class for whether there is a sidebar shown
        if ( ! $('#page-content').hasClass('col-lg-offset-1') ){
            $('#sidebar').collapse('show');
        }
    })

    $('#sidebar').on('shown.bs.collapse', function(){
        // must be in 'shown' event for this to work
        $('#quick-search').focus();
    })
})

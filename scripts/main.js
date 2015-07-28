$(function(){
    $('#sidebar').on('hidden.bs.collapse', function(){
        $('#page-content').removeClass("col-lg-9");
        $('#page-content').addClass('col-lg-10 col-lg-offset-1');
    })

    $('#sidebar').on('show.bs.collapse', function(){
        // temporarily make sidebar invisible to avoid undesirable intermediate
        // display:
        // TODO the best way is to have a hook that runs BEFORE show action.
        $('#sidebar').css("visibility", "hidden");
    })

    $('#sidebar').on('shown.bs.collapse', function(){
        $('#page-content').removeClass('col-lg-10 col-lg-offset-1');
        $('#page-content').addClass("col-lg-9");

        $('#sidebar').css("visibility", "visible");
        // must be in 'shown' event for this to work
        $('#quick-search').focus();
    })
})

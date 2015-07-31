$(function(){
    $('#sidebar').on('hidden.bs.collapse', function(){
        $('#sidebar-btn').removeClass('sidebar-toggled');
        $('#page-content').removeClass("col-lg-9");
        $('#page-content').addClass('col-lg-10 col-lg-offset-1');
    })

    // The two steps in showing sidebar is necessary to avoid intermediate
    // display issue.
    $('#sidebar').on('show.bs.collapse', function(e){
        if( ! $('#sidebar-btn').hasClass('sidebar-toggled') ){
            $('#page-content').removeClass('col-lg-10 col-lg-offset-1');
            $('#page-content').addClass("col-lg-9");
            $('#sidebar-btn').addClass('sidebar-toggled');
            return e.preventDefault();
        }
    })

    // only really show the sidebar after layout updated.
    $('#page-content').on('transitionend', function(){
        if ( $('#sidebar-btn').hasClass('sidebar-toggled') ){
            $('#sidebar').collapse('show');
        }
    })

    $('#sidebar').on('shown.bs.collapse', function(){
        // must be in 'shown' event for this to work
        $('#quick-search').focus();
    })


    ///////////////////////////////////////////////////////////////// 
    // Quick Search
    /* TODO too crude for the check on 'searchIndex' */
    if ( !searchIndex ){
        var searchIndex;
        $.getJSON('/search-index.json', function (data){
            searchIndex = data;

            $('#quick-search').autocomplete({
                lookup: searchIndex,

                /* TODO we've force the format of JSON, use 'transformResult' to undo that. */
                onSelect: function (suggestion) {
                    console.log("Jump to: " + suggestion.data);
                    window.location.href = suggestion.data;
                }
            });
        })
    }
})

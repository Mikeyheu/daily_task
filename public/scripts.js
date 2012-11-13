$(document).ready(function(){
	$( "#sortable" ).sortable({
		update: function(e){
			$.ajax({
				type: 'POST',
				url: '/sort',
				data: $(this).sortable('serialize')
			});
		}
	})
	$( "#sortable span" ).disableSelection();
});

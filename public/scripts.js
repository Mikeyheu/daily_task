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

	$(".editable").on("dblclick", replaceHTML);  

	function replaceHTML() {

		current_value = $(this).text();
		old_value = current_value;
		$(this).html('');
		$(this).html('<form><input type="text" id="edit_field" class="small_input" value="' + current_value +'"></form>');  
		
		$('#edit_field').focus();

		$('#edit_field').keyup(function(){
			current_value = $(this).val();
		});

		$(document).on("click", function(e){
			if(e.target.id != 'edit_field') {
				if(old_value != current_value) {
					id = parseInt($('#edit_field').parent().parent().parent().attr('id').replace("task_", ""));
					console.log(id);
					$.ajax({
						type: 'POST',
						url:  '/' + id + '/update',
						data: {
							content: current_value,
						}
					});
				}
				$('#edit_field').parent().html('<span class=>' + current_value + '</span>');
				$(document).off("click");
			}
		});
	}
	
});


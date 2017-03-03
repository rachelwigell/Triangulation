$('#x_grid_size_slider').change(function(){
	handleSliderChange("x", this.value);
})

$('#y_grid_size_slider').change(function(){
	handleSliderChange("y", this.value);
})

$('#grid_size_slider').change(function(){
	handleSliderChange("", this.value);
})

function handleSliderChange(slider, newVal){
	if(slider == "x") xGridSize = parseInt(newVal);
	else if(slider == "y") yGridSize = parseInt(newVal);
	else gridSize = parseInt(newVal);
	var processing = Processing.getInstanceById('processing');
	if(simpleMode) processing.setupHomogenousGrid();
	else processing.setupBalancedGrid();
}

$('#render_mode').change(function(){
	simpleMode = $('#render_mode').is(":checked");
	var processing = Processing.getInstanceById('processing');
	if(simpleMode){
		$('#edge_detect_mode_sliders').hide()
		$('#simple_mode_slider').show();
		processing.setupHomogenousGrid();
	}
	else {
		$('#edge_detect_mode_sliders').show()
		$('#simple_mode_slider').hide();
		processing.setupBalancedGrid();
	}
})
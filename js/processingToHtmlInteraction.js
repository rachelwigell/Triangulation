$('#x_grid_size_slider').change(function(){
	handleSliderChange(true, this.value);
})

$('#y_grid_size_slider').change(function(){
	handleSliderChange(false, this.value);
})

function handleSliderChange(x, newVal){
	if(x) xGridSize = parseInt(newVal);
	else yGridSize = parseInt(newVal);
	var processing = Processing.getInstanceById('processing');
	processing.setupBalancedGrid();
}
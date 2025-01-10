extends Control

@onready var progress_bar = $ProgressBar

func _ready() -> void:
	setup_progress_bar()

func setup_progress_bar() -> void:
	var gradient = Gradient.new()
	gradient.offsets = [0.0, 1.0]
	gradient.colors = [Color(0, 1, 0, 1), Color(1, 0, 0, 1)]
	
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.fill = GradientTexture2D.FILL_LINEAR
	gradient_texture.width = 256
	gradient_texture.height = progress_bar.size.y
	gradient_texture.fill_from = Vector2(0, 0)
	gradient_texture.fill_to = Vector2(1, 0)
	
	var style_box = StyleBoxTexture.new()
	style_box.texture = gradient_texture
	
	progress_bar.add_theme_stylebox_override("fill", style_box)
	progress_bar.show_percentage = false
	progress_bar.fill_mode = ProgressBar.FILL_BEGIN_TO_END
	
func update_noise_bar(noise_percentage: float) -> void:
	progress_bar.value = noise_percentage

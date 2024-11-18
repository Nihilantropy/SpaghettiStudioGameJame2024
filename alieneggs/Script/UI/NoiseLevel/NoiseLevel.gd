extends Control

@onready var progress_bar = $ProgressBar

func _ready() -> void:
	setup_progress_bar()

func setup_progress_bar() -> void:
	# Create a gradient for the progress bar
	var gradient = Gradient.new()
	gradient.add_point(0, Color(0, 1, 0, 1))  # Fully opaque green at 0%
	gradient.add_point(1, Color(1, 0, 0, 1))  # Fully opaque red at 100%
	
	# Create a GradientTexture2D using the gradient
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.width = 256  # Optional: Adjust for smoothness

	# Create a StyleBoxTexture and assign the gradient texture
	var style_box = StyleBoxTexture.new()
	style_box.texture = gradient_texture

	# Assign the StyleBoxTexture to the ProgressBar's fill style
	progress_bar.add_theme_stylebox_override("fill", style_box)

	# Configure ProgressBar properties if needed
	progress_bar.fill_mode = ProgressBar.FILL_BEGIN_TO_END

func update_noise_bar(noise_percentage: float) -> void:
	# Update the ProgressBar value
	progress_bar.value = noise_percentage

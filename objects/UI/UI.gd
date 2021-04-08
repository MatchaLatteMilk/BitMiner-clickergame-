extends Control

func _ready():
	$Upgrade.hide()
	option_button_list()

func option_button_theme():
	$Option/OptionButton.theme = Theme.new()
	$Option/OptionButton.theme.default_font = DynamicFont.new()
	$Option/OptionButton.theme.default_font.font_data = load("res://Amatic-Bold.ttf")
	$Option/OptionButton.theme.default_font.settings.font_size = 64

func option_button_list():
	$Option/OptionButton.get_popup().add_item("WHALE",1)
	$Option/OptionButton.add_item("DEEP ORANGE",2)
	$Option/OptionButton.add_item("BEIGE",3)
	$Option/OptionButton.add_item("AMBER",4)
	$Option/OptionButton.add_item("RUBY",5)

func _process(delta):
	button_size()

func button_size():
	$Option/OptionButton.rect_size = $Option/OptionButton.get_font("font").get_string_size($Option/OptionButton.text)*1.2

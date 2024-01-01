extends Node

#An atrocious workaround... The fact RTL's can't just auto-adjust width is ridiculous
func label_width(label):
	var theme_font = label.get_theme_font("font")
	var string_size = theme_font.get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, label.get_theme_font_size("font_size"))
	
	return string_size.x

local wezterm = require("wezterm")

wezterm.on("update-right-status", function(window)
	window:set_right_status(window:active_workspace())
end)

-- A helper function for my fallback fonts
local function font_with_fallback(name, params)
	local names = { name, "Noto Color Emoji", "JetBrains Mono" }
	return wezterm.font_with_fallback(names, params)
end

local font = "Hack Nerd Font Mono"

return {
	color_scheme = "ayu",
	-- General configuration
	set_environment_variables = {
		COLORTERM = "truecolor",
	},
	bold_brightens_ansi_colors = true,
	custom_block_glyphs = true,

	scrollback_lines = 50000,
	audible_bell = "Disabled",
	window_close_confirmation = "NeverPrompt",
	use_fancy_tab_bar = false,
	enable_tab_bar = false,

	window_padding = {
		left = 2,
		right = 4,
		top = 2,
		bottom = 2,
	},

	-- Font and color scheme
	font = font_with_fallback(font, { weight = "Bold" }),
	font_rules = {
		{
			italic = true,
			font = font_with_fallback(font, { weight = "Bold", italic = true }),
		},
		{
			italic = true,
			intensity = "Bold",
			font = font_with_fallback(font, { weight = "Bold", italic = true }),
		},
	},
	font_size = 15,
	use_resize_increments = true,
	line_height = 1.2,
	cell_width = 1.0,

	-- window_background_opacity = 0.8,
	window_background_image = "/Users/jj/Documents/GERMANCASTLE.jpg",
	window_background_image_hsb = {
		brightness = 0.08,
		hue = 1,
		saturation = 1,
	},
	colors = {
		ansi = {
			"black",
			"maroon",
			"green",
			"olive",
			"navy",
			"purple",
			"teal",
			"silver",
		},
		brights = {
			"grey",
			"red",
			"lime",
			"yellow",
			"blue",
			"fuchsia",
			"aqua",
			"white",
		},
	},
}

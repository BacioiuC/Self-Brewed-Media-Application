local data = {

	backGround = {
		widget="image",
		dim = {100, 100},
		pos = { 0, 0 },
		images = { 
			{
				fileName = "", --../gui/ggMM/main_menu.png  ../gui/alpha_sign_1080.png
			},
		},
		children = {
			category_background = {
				widget="image",
				dim = {100, 5},
				pos = {0, 10},
				images = {
					{
						fileName = "../../media/ui_elements/category_background.png",
					},
				},
			},
		},

	},
}

return data

return {
	"sphamba/smear-cursor.nvim",
	event = "VeryLazy",
	opts = {
		stiffness = 0.8, -- 0.6 más elástico, 0.9 más seco
		trailing_stiffness = 0.5,
		distance_stop_animating = 0.5,
		smear_insert_mode = true,
	},
}

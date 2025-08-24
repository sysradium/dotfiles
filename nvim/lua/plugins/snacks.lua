-- ~/.config/nvim/lua/plugins/snacks.lua
return {
	{
		"folke/snacks.nvim",
		-- Merge into Snacks defaults so built-in LazyVim keys use them
		opts = function(_, opts)
			opts = opts or {}
			opts.picker = opts.picker or {}

			-- Base picker config for all picker operations including <leader>/
			local picker_config = {
				hidden = true,
				ignored = false,
				exclude = { "vendor/**", "*.pb.go", "*.pb.debug.go", "*.pb.gw.go", "**/*fakes*/**" },
			}

			-- Apply to both base picker and grep specifically
			opts.picker = vim.tbl_deep_extend("force", opts.picker, picker_config)
			opts.picker.grep = vim.tbl_deep_extend("force", opts.picker.grep or {}, picker_config)

			return opts
		end,
	},
}

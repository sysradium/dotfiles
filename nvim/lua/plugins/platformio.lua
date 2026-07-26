local function pio_executable()
	local bundled = vim.fn.expand("~/.platformio/penv/bin/pio")
	return vim.fn.executable(bundled) == 1 and bundled or "pio"
end

local function project_root()
	local current = vim.api.nvim_buf_get_name(0)
	local config = vim.fs.find("platformio.ini", {
		path = current == "" and vim.uv.cwd() or current,
		upward = true,
		type = "file",
	})[1]
	return config and vim.fs.dirname(config) or nil
end

local function has_platformio_project(root)
	return #vim.fs.find("platformio.ini", { path = root, upward = true, type = "file" }) > 0
end

local function run_task(name, args, open_output)
	local root = project_root()
	if not root then
		vim.notify("No platformio.ini found", vim.log.levels.ERROR)
		return
	end

	local task = require("overseer").new_task({
		name = name,
		cmd = vim.list_extend({ pio_executable() }, args),
		cwd = root,
		components = open_output and {
			{ "open_output", on_start = "always", direction = "dock", focus = false },
			"default",
		} or { "default" },
	})
	task:start()
end

return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			local clangd = opts.servers.clangd
			local original = clangd.on_new_config
			clangd.on_new_config = function(config, root)
				if original then
					original(config, root)
				end
				if has_platformio_project(root) then
					config.cmd = vim.deepcopy(config.cmd)
					table.insert(
						config.cmd,
						"--query-driver="
							.. vim.fn.expand(
								"~/.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-g++"
							)
					)
				end
			end
		end,
	},
	{
		"stevearc/overseer.nvim",
		keys = {
			{ "<leader>pb", function() run_task("PlatformIO: Build", { "run" }, true) end, desc = "PlatformIO build" },
			{ "<leader>pu", function() run_task("PlatformIO: Upload", { "run", "-t", "upload" }, true) end, desc = "PlatformIO upload" },
			{ "<leader>pm", function() run_task("PlatformIO: Monitor", { "device", "monitor", "--baud", "115200" }, true) end, desc = "PlatformIO monitor" },
		},
	},
}

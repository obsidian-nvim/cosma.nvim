local uv = vim.uv

---@class cosma.Config
---@field select_origin "directory"
---@field files_origin string
---@field links_origin string
---@field nodes_online string
---@field links_online string
---@field images_origin string
---@field export_target string
---@field history boolean

local M = {}

---@param opts { dir: string, config: cosma.Config }
function M.config(opts)
	opts = opts or {}
	local dir = opts.dir or uv.cwd()
	local config = opts.config or require("cosma.config").default
end

function M.modelize(dir, cb)
	dir = dir or uv.cwd()
	vim.system({
		"cosma",
		"modelize",
	}, {
		cwd = dir,
	}, function(out)
		assert(out.code == 0, "failed to modelize")
		if cb then
			cb()
		end
	end)
end

function M.open(dir)
	local path = vim.fs.joinpath(dir, "export", "cosmoscope.html") -- TODO: according to config
	vim.ui.open(path, { cmd = { "wsl-open" } })
end

return M

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
---TODO:

local M = {}
local yaml = require("obsidian.yaml")
local config = require("cosma.config")

config.resolve = function(og)
	return vim.tbl_deep_extend("force", og or config.default, config.custom or {})
end

---@param opts { dir: string }
function M.config(opts)
	opts = opts or {}
	local dir = vim.fs.normalize(opts.dir or uv.cwd())
	local config_fp = vim.fs.joinpath(dir, "config.yml")
	local cfg = config.resolve()
	vim.fn.writefile(vim.split(yaml.dumps(cfg), "\n"), config_fp)
	return cfg
end

local function get_plugin_dir()
	local str = debug.getinfo(2, "S").source:sub(2)
	return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(str))))
end

---@return boolean
local function has_global_cli()
	return vim.fn.executable("cosma") == 1
end

local function get_cli_path()
	if has_global_cli() then
		return "cosma"
	else
		return vim.fs.joinpath(get_plugin_dir(), "node_modules", ".bin", "cosma")
	end
end

function M.modelize(dir, cb)
	dir = dir or uv.cwd()
	local cfg = M.config({ dir = dir })
	local export_path = vim.fs.joinpath(dir, cfg.export_target)
	if vim.fn.isdirectory(export_path) == 0 then
		vim.fn.mkdir(export_path, "p")
	end

	vim.system({
		get_cli_path(),
		"modelize",
	}, {
		cwd = dir,
	}, function(out)
		assert(out.code == 0, "failed to modelize")
		if cb then
			cb(dir, cfg)
		end
	end)
end

function M.open(dir, cfg)
	local path = vim.fs.joinpath(dir, cfg.export_target, "cosmoscope.html") -- TODO: according to config
	vim.ui.open(path)
end

function M.setup(cfg)
	config.custom = cfg.custom
end

return M

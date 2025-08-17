local cosma = require("cosma")
local api = require("obsidian.api")
local Path = require("obsidian.path")
local log = require("obsidian.log")
local Note = require("obsidian.note")

return function()
	local tmpdir = Path.temp()
	tmpdir:mkdir()

	for path in api.dir(Obsidian.dir) do
		local new_path = Path.new(tmpdir / Path.new(path):vault_relative_path())
		local parent = new_path:parent()
		if parent and not parent:exists() then
			parent:mkdir({ parents = true })
		end
		local ok, err = vim.uv.fs_copyfile(path, tostring(new_path))
		local new_note = Note.from_file(new_path)

		if not new_note.title then
			new_note.metadata = new_note.metadata or {}
			new_note.metadata.title = new_note.id or vim.fs.basename(tostring(new_path))
		end

		new_note:save()

		if not ok then
			log.err(err or "fail to copy the vault")
		end
	end

	cosma.modelize(tostring(tmpdir), function(dir, cfg)
		cosma.open(dir, cfg)
	end)
end

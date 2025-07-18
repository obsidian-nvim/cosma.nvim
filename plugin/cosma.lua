if pcall(require, "obsidian") then
	require("obsidian").register_command("graph", { nargs = 0 })
end

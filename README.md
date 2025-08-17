# cosma.nvim

cosma 🤝 neovim

**WIP**

This is mainly for using in combination with [obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim), but is also available as a standalone plugin, and is willing to provide integration with other note-taking plugin for neovim.

## Install

**dependencies**:

- For now it depends on some API provided by obsidian.nvim, but can be easily decoupled if anyone wants.
- [Install cosma](https://cosma.arthurperret.fr/installing.html) (will auto install as node dependency in the future)

**lazy.nvim**:

```lua
return {
    "obsidian-nvim/obsidian.nvim"
    dependencies = {
        "obsidian-nvim/cosma.nvim"
    }
}
```

This will give you a `Obsidian graph` command.

## Caveat

`cosma` requires a `title` field in the frontmatter, which is not the standard for either obsidian app or obsidian.nvim, so using `Obsidian graph` on most vaults will not work.

Temporary **workaround**

> [!WARNING]
> Following is very hacky, and you are advised to try this on a new vault, or manually give notes titles.

1. change `note_frontmatter_func`:

```lua
require("obsidian").setup({
	note_frontmatter_func = function(note)
		local out = {
			id = note.id,
			tags = note.tags,
			aliases = not vim.tbl_isempty(note.aliases) and note.aliases or nil,
			title = note.title,
		}

		for line in io.lines(note.path.filename) do
			local header = require("obsidian.util").parse_header(line)
			if header and header.level == 1 then
				out.title = header.header
			end
		end

		if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
			for k, v in pairs(note.metadata) do
				out[k] = v
			end
		end
		return out
	end,
})
```

2. run this script to save in every note in the vault:

```lua
local paths = api.dir(Obsidian.dir)

for path in paths do
	local note = Note.from_file(path)
	note:open({
		callback = function(bufnr)
			vim.api.nvim_exec_autocmds("BufWritePre", { buffer = bufnr })
		end,
	})
end
```

## Customization

- see https://cosma.arthurperret.fr/user-manual.html for configuration parameters.

```lua
require("cosma").setup({
	custom = {
		export_target = "new_export",
	},
})
```

## TODO

- [ ] install a local copy of cosma if not present.

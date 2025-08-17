local cosma = require("cosma")

return function()
	local dir = tostring(Obsidian.dir)
	cosma.modelize(dir, cosma.open)
end

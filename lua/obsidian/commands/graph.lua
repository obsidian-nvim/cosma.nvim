local cosma = require("cosma")

return function()
	local dir = tostring(Obsidian.dir)
	cosma.modelize(dir, function()
		cosma.open(dir)
	end)
end

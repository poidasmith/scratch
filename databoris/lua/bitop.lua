
local bitop = {}

fns = {	"orr", "and", "xor", "not", "loword", "hiword" }

for k, v in next, fns do
	bitop[ v ] = dbos.GetProcAddress("bit_" .. v)
end

return table.readonly(bitop)

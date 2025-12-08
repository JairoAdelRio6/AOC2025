local lpeg = require("lpeg")
local Cc, Ct, P, match = lpeg.Cc, lpeg.Ct, lpeg.P, lpeg.match

local grid_aux = {}
local grid = {}

local grammar = P({
	"grammar",
	grammar = Ct(((P(".") * Cc(false)) + (P("@") * Cc(true))) ^ 1),
})

for line in io.lines("./input04.txt") do
	grid[#grid + 1] = match(grammar, line)
	grid_aux[#grid_aux + 1] = match(grammar, line)
end

local W = #grid[1]
local H = #grid

do
	local n_of_accessibles = 0
	local rounds = 0
	while true do
		local found = false
		rounds = rounds + 1
		for y = 1, H do
			for x = 1, W do
				if grid_aux[y][x] then
					local n_of_neighbors = 0
					for dir_x = -1, 1 do
						for dir_y = -1, 1 do
							local neighbor_x = x + dir_x
							local neighbor_y = y + dir_y
							local check = x ~= neighbor_x or y ~= neighbor_y
							if check and neighbor_x > 0 and neighbor_x <= W and neighbor_y > 0 and neighbor_y <= H then
								if grid_aux[neighbor_y][neighbor_x] then
									n_of_neighbors = n_of_neighbors + 1
								end
							end
						end
					end
					if n_of_neighbors < 4 then
						found = true
						n_of_accessibles = n_of_accessibles + 1
						grid[y][x] = false
					end
				end
			end
		end
		if rounds == 1 then
			print(n_of_accessibles)
		end
		if not found then
			break
		end
		for y = 1, H do
			for x = 1, W do
				grid_aux[y][x] = grid[y][x]
			end
		end
	end
	print(n_of_accessibles)
end

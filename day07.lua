local lpeg = require("lpeg")
local Ct, P, S, V, match = lpeg.Ct, lpeg.P, lpeg.S, lpeg.V, lpeg.match

local START, EMPTY, SPLITTER, BEAM = 1, 2, 3, 4

local mappings = {
	["S"] = START,
	["."] = EMPTY,
	["^"] = SPLITTER,
	["|"] = BEAM,
}

local grammar =
	P({ "grammar", chars = Ct((S("S.^|") / mappings) ^ 1), grammar = Ct(V("chars") * (P("\n") * V("chars")) ^ 0) })

local input_file <close> = io.open("./input07.txt")
if not input_file then
	error("Input file failure!")
end
local input = input_file:read("*a")

local n_of_splits = 0
local n_of_ways = 0

local sums_grid = {}

local grid = match(grammar, input)
local W, H = #grid[1], #grid

for y = 1, H do
	for x = 1, W do
		local cell = grid[y][x]
		if cell == START then
			grid[y + 1][x] = BEAM
		end
		if cell == SPLITTER and grid[y - 1][x] == BEAM then
			grid[y][x - 1] = BEAM
			grid[y][x + 1] = BEAM
			if not grid[y - 1][x - 1] ~= BEAM or grid[y - 1][x + 1] ~= BEAM then
				n_of_splits = n_of_splits + 1
			end
		end
		if y > 1 then
			if cell == EMPTY and grid[y - 1][x] == BEAM then
				grid[y][x] = BEAM
			end
		end
	end
end
print(n_of_splits)

for y = 1, H do
	sums_grid[y] = {}
	local cell = sums_grid[y]
	for x = 1, W do
		cell[x] = 0
	end
end

for y = 1, H do
	for x = 1, W do
		local cell = grid[y][x]
		if cell == START then
			sums_grid[y + 1][x] = 1
		end
		if cell == BEAM then
			if grid[y - 1][x] then
				sums_grid[y][x] = sums_grid[y][x] + sums_grid[y - 1][x]
			end
			if x > 1 then
				if grid[y][x - 1] == SPLITTER and grid[y - 1][x - 1] == BEAM then
					sums_grid[y][x] = sums_grid[y][x] + sums_grid[y - 1][x - 1]
				end
			end
			if x < W then
				if grid[y][x + 1] == SPLITTER and grid[y - 1][x + 1] == BEAM then
					sums_grid[y][x] = sums_grid[y][x] + sums_grid[y - 1][x + 1]
				end
			end
		end
	end
end

for _, i in ipairs(sums_grid[H]) do
	n_of_ways = n_of_ways + i
end

print(n_of_ways)

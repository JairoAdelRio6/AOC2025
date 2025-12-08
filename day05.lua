local ranges = {}
local ids = {}
-- local id_hashes = {}

local n_of_fresh = 0
local n_of_fresh_total = 0

for line in io.lines("./input05.txt") do
	local id
	local start, stop = line:match("(%d+)%D(%d+)")
	if start then
		start = tonumber(start)
		stop = tonumber(stop)
		ranges[#ranges + 1] = { start, stop }
	else
		id = line:match("(%d+)")
		if id then
			ids[#ids + 1] = tonumber(id)
		end
	end
end

table.sort(ranges, function(a, b)
	return a[1] < b[1]
end)

-- for _, id in ipairs(ids) do
-- 	for _, range in ipairs(ranges) do
-- 		local start, stop = range[1], range[2]
-- 		if start <= id and id <= stop then
-- 			if not id_hashes[id] then
-- 				n_of_fresh = n_of_fresh + 1
-- 				id_hashes[id] = true
-- 			end
-- 		end
-- 	end
-- end

for i = 1, #ranges - 1 do
	for j = i + 1, #ranges do
		if ranges[i] and ranges[j] then
			local first = { ranges[i][1], ranges[i][2] }
			local second = { ranges[j][1], ranges[j][2] }
			local all = { ranges[i][1], ranges[i][2], ranges[j][1], ranges[j][2] }
			table.sort(all)
			if math.max(first[1], second[1]) <= math.min(first[2], second[2]) then
				ranges[i][1] = all[1]
				ranges[i][2] = all[4]
				ranges[j] = false
			end
		end
	end
end

for _, range in ipairs(ranges) do
	if range then
		local start, stop = range[1], range[2]
		for _, id in ipairs(ids) do
			if start <= id and id <= stop then
				n_of_fresh = n_of_fresh + 1
			end
		end
		n_of_fresh_total = n_of_fresh_total - start + stop + 1
	end
end

print(n_of_fresh)
print(n_of_fresh_total)

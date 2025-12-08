local dial = 50
local module = 100
local exact_zeros = 0
local zeros = 0

for line in io.lines("./input01.txt") do
	local dir, n = line:match("^([LR])(%d+)$")
	if dir then
		local angle = tonumber(n) * (dir == "R" and 1 or -1)
		local fromzero = dial == 0 and 0 or 1
		dial = dial + angle
		if dial > 0 then
			zeros = zeros + dial // module
		else
			zeros = zeros + fromzero + math.abs(dial) // module
		end
		dial = dial % module
		if dial == 0 then
			exact_zeros = exact_zeros + 1
		end
	end
end
print(exact_zeros)
print(zeros)

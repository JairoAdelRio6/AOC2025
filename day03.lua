local lpeg = require("lpeg")
local C, Ct, P, R, V, match = lpeg.C, lpeg.Ct, lpeg.P, lpeg.R, lpeg.V, lpeg.match

local input_file <close> = io.open("./input03.txt")
if not input_file then
	error("Input file failure!")
end
local input = input_file:read("*a")

local digits_grammar = P({
	"grammar",
	line = Ct((R("09") / tonumber) ^ 1),
	grammar = Ct(V("line") * (P("\n") * V("line")) ^ 0),
})

local lines_grammar = P({
	"grammar",
	line = C((1 - P("\n")) ^ 1),
	grammar = Ct(V("line") * (P("\n") * V("line")) ^ 0),
})

local sum_of_maxima = function(data, n)
	local lines_grid = match(lines_grammar, data)
	local digits_grid = match(digits_grammar, data)

	local sum = 0
	for j, digits in ipairs(digits_grid) do
		local max = 0
		local next_pos = 0
		for i = n - 1, 0, -1 do
			max = max * 10
			local prefix_digits = {}
			local prefix = lines_grid[j]:sub(next_pos + 1, #digits - i)
			table.move(digits, next_pos + 1, #digits - i, 1, prefix_digits)
			table.sort(prefix_digits)
			local max_digit = prefix_digits[#prefix_digits]
			next_pos = next_pos + (prefix:find(tostring(max_digit)))
			max = max + max_digit
		end
		sum = sum + max
	end
	print(sum)
end

print(sum_of_maxima(input, 2))
print(sum_of_maxima(input, 12))

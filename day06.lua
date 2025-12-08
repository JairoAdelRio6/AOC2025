local lpeg = require("lpeg")

local Cc, Cp, Ct, P, R, S, V, match = lpeg.Cc, lpeg.Cp, lpeg.Ct, lpeg.P, lpeg.R, lpeg.S, lpeg.V, lpeg.match

local nums_grammar = P({
	"grammar",
	num = R("09") ^ 1 / tonumber,
	spaces = R("\t ") ^ 1,
	op = (Cc(true) * P("*")) + (Cc(false) * P("+")),
	ops = Ct(V("op") * (V("spaces") * V("op")) ^ 0),
	nums = Ct(V("num") * (V("spaces") * V("num")) ^ 0),
	grammar = V("spaces") ^ -1 * (V("ops") + V("nums")),
})

local chars_grammar = P({
	"grammar",
	grammar = Ct(((R("09") / tonumber) + (P(" ") * Cc(false))) ^ 1),
})

local breakpoints_grammar = P({
	"grammar",
	grammar = Ct((Cp() * S("*+") * P(" ") ^ 1) ^ 1) * P(-1),
})

local ops, breakpoints

local grid, char_grid = {}, {}

for line in io.lines("./input06.txt") do
	local row = match(nums_grammar, line)
	local chars = match(chars_grammar, line)
	if type(row[1]) == "number" then
		grid[#grid + 1] = row
		char_grid[#char_grid + 1] = chars
	else
		breakpoints = match(breakpoints_grammar, line)
		breakpoints[#breakpoints + 1] = #line + 2
		ops = row
	end
end

local first_sum, second_sum = 0, 0
for x = 1, #grid[1] do
	local op = ops[x]
	local acc = op and 1 or 0
	for y = 1, #grid do
		if op then
			acc = acc * grid[y][x]
		else
			acc = acc + grid[y][x]
		end
	end
	first_sum = first_sum + acc
end
print(first_sum)

for i = 1, #breakpoints - 1 do
	local op = ops[i]
	local acc = ops[i] and 1 or 0
	for x = breakpoints[i], breakpoints[i + 1] - 2 do
		local val = 0
		for y = 1, #grid do
			local digit = char_grid[y][x]
			if digit then
				val = 10 * val + digit
			end
		end
		if op then
			acc = acc * val
		else
			acc = acc + val
		end
	end
	second_sum = second_sum + acc
end
print(second_sum)

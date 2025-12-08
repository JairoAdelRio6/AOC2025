local lpeg = require("lpeg")
local Ct, P, R, V, match = lpeg.Ct, lpeg.P, lpeg.R, lpeg.V, lpeg.match

local input <close> = io.open("./input02.txt", "rb")

if not input then
	error("Input file failure!")
end

local data = input:read("*a")

local grammar = P({
	"grammar",
	range = Ct((R("09") ^ 1 / tonumber * P("-")) * (R("09") ^ 1 / tonumber)),
	grammar = Ct(V("range") * (P(",") * V("range")) ^ 0),
})

local ranges = match(grammar, data)

local first_sum, second_sum = 0, 0

local divisors = {
	{ 1 },
	{ 1 },
	{ 1 },
	{ 1, 2 },
	{ 1 },
	{ 1, 2, 3 },
	{ 1 },
	{ 1, 2, 4 },
	{ 1, 3 },
	{ 1, 2, 5 },
}

for _, range in ipairs(ranges) do
	local start, stop = table.unpack(range)
	for i = start, stop do
		local str = tostring(i)
		local len = #str
		if len % 2 == 0 then
			if str:sub(1, len // 2) == str:sub(len // 2 + 1, len) then
				first_sum = first_sum + i
			end
		end
		for _, d in ipairs(divisors[len]) do
			if len > 1 and str:sub(1, d):rep(len // d) == str then
				second_sum = second_sum + i
				break
			end
		end
	end
end

print(first_sum)
print(second_sum)

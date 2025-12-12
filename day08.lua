local points = {}
local edges = {}

for line in io.lines("./input08.txt") do
	local x, y, z = line:match("(%d+),(%d+),(%d+)")
	if x then
		x, y, z = tonumber(x), tonumber(y), tonumber(z)
	end
	local point = { x, y, z }
	points[#points + 1] = point
end

for i = 1, #points - 1 do
	local p1 = points[i]
	for j = i + 1, #points do
		local p2 = points[j]
		local distance = math.sqrt((p1[1] - p2[1]) ^ 2 + (p1[2] - p2[2]) ^ 2 + (p1[3] - p2[3]) ^ 2)
		edges[#edges + 1] = { p1, p2, distance }
	end
end

table.sort(edges, function(a, b)
	return a[3] < b[3]
end)

local n_selected = 1000
local selected_edges = {}
table.move(edges, 1, n_selected, 1, selected_edges)

local group_edges = function(t)
	local vertices, ids = {}, {}
	for _, e in ipairs(t) do
		local u, v = e[1], e[2]
		if not ids[u] then
			ids[u] = #vertices + 1
			vertices[#vertices + 1] = u
		end
		if not ids[v] then
			ids[v] = #vertices + 1
			vertices[#vertices + 1] = v
		end
	end
	local n = #vertices
	local parent = {}
	for i = 1, n do
		parent[i] = i
	end

	local find = function(x)
		while parent[x] ~= x do
			x = parent[x]
		end
		return x
	end

	local union = function(x, y)
		local rx, ry = find(x), find(y)
		if rx ~= ry then
			parent[ry] = rx
		end
	end

	for _, e in ipairs(t) do
		union(ids[e[1]], ids[e[2]])
	end

	local components = {}

	for _, e in ipairs(t) do
		local root = find(ids[e[1]])
		if not components[root] then
			components[root] = { edges = {}, vertex_ids = {}, vertex_set = {} }
		end
		table.insert(components[root].edges, e)
		components[root].vertex_ids[ids[e[1]]] = true
		components[root].vertex_ids[ids[e[2]]] = true
		components[root].vertex_set[e[1]] = true
		components[root].vertex_set[e[2]] = true
	end

	local result = {}
	for _, c in pairs(components) do
		local count = 0
		for _ in pairs(c.vertex_ids) do
			count = count + 1
		end
		table.insert(result, {
			vertices = c.vertex_set,
			edges = c.edges,
			n_points = count,
		})
	end

	return result
end

local closest_edges = group_edges(selected_edges)

table.sort(closest_edges, function(a, b)
	return a.n_points > b.n_points
end)

print(closest_edges[1].n_points * closest_edges[2].n_points * closest_edges[3].n_points)

local extra_edges = {}
local connected = {}
for i = 1, #closest_edges do
	connected[i] = false
end

local check = function(t)
	for i = 1, #t do
		if not t[i] then
			return false
		end
	end
	return true
end

for i = n_selected + 1, #edges do
	if check(connected) then
		break
	end
	local e = edges[i]
	local u, v = e[1], e[2]
	for j = 1, #closest_edges - 1 do
		local nu = closest_edges[j]
		for k = j + 1, #closest_edges do
			if not connected[j] or not connected[k] then
				local nv = closest_edges[k]
				if (nu.vertices[u] and nv.vertices[v]) or (nu.vertices[v] and nv.vertices[u]) then
					connected[j] = true
					connected[k] = true
					table.insert(extra_edges, e)
					break
				end
			end
		end
	end
end

local final = table.remove(extra_edges)

print(final[1][1] * final[2][1])

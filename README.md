# Deque

Deques are a generalization of stacks and queues.

The name is pronounced "deck" and is short for "double-ended queue".

Get it here:

* [Wally](https://wally.run/package/egomoose/deque)
* [Releases](https://github.com/EgoMoose/deque-luau/releases)

## Documentation

Documentation is available at https://egomoose.github.io/deque-luau.

## Examples

```lua
local function getDescendantsBFS(root: Instance)
	local descendants = {}
	local queue = Deque.new(root:GetChildren())

	while queue:getLength() > 0 do
		local front = queue:popFront()

		table.insert(descendants, front)

		for _, child in front:GetChildren() do
			queue:pushBack(child)
		end
	end
	
	return descendants
end
```

```lua
local function getDescendantsDFS(root: Instance)
	local descendants = {}
	local stack = Deque.new(root:GetChildren())
	stack:reverse()

	while stack:getLength() > 0 do
		local popped = stack:popBack()

		table.insert(descendants, popped)

		local children = popped:GetChildren()
		for i = #children, 1, -1 do
			stack:pushBack(children[i])
		end
	end

	return descendants
end
```
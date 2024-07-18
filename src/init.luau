--!strict

local DequeClass = {}
DequeClass.__index = DequeClass
DequeClass.ClassName = "Deque"

export type Deque<T> = typeof(setmetatable(
	{} :: {
		index: number,
		length: number,
		elements: { T },
	},
	DequeClass
))

-- Constructors

function DequeClass.raw<T>(elements: { T }): Deque<T>
	local self = setmetatable({}, DequeClass) :: Deque<T>

	self.index = 1
	self.length = #elements
	self.elements = elements

	return self
end

function DequeClass.new<T>(list: { T })
	return DequeClass.raw(table.clone(list))
end

-- Public Methods

function DequeClass.getElement<T>(self: Deque<T>, index: number)
	assert(index > 0 and index <= self.length, "Index out of range.")
	return self.elements[self.index + index - 1]
end

function DequeClass.getElements<T>(self: Deque<T>): { T }
	local elementsCopy = table.create(self.length, nil)
	table.move(self.elements, self.index, self.index + self.length, 1, elementsCopy)
	return elementsCopy
end

function DequeClass.getLength<T>(self: Deque<T>)
	return self.length
end

function DequeClass.find<T>(self: Deque<T>, element: T): number?
	for i = 1, self.length do
		local j = self.index + (i - 1)
		if self.elements[j] == element then
			return j
		end
	end
	return nil
end

function DequeClass.drain<T>(self: Deque<T>, from: number, length: number)
	assert(from > 0 and from <= self.length and length > 0 and from + length - 1 <= self.length, "Index out of range.")

	local drained = {}

	for i = from, from + length - 1 do
		local j = self.index + i - 1
		local popped = self.elements[j]
		self.elements[j] = nil
		table.insert(drained, popped)
	end

	local left = from - 1
	local right = self.length - (from + length - 1)

	if left < right then
		local newIndex = (self.index + from + length - 1) - left
		for i = left, 1, -1 do
			local j = self.index + i - 1
			self.elements[newIndex + i - 1] = self.elements[j]
			self.elements[j] = nil
		end
		self.index = newIndex
	else
		local fromIndex = (self.index + from - 1)
		local afterIndex = (self.index + from + length - 1)
		for i = 1, right do
			local j = afterIndex + i - 1
			self.elements[fromIndex + i - 1] = self.elements[j]
			self.elements[j] = nil
		end
	end

	self.length = self.length - length

	return drained
end

function DequeClass.insert<T>(self: Deque<T>, index: number, element: T)
	assert(index > 0 and index <= self.length + 1, "Index out of range.")

	local half = math.floor(self.length / 2)

	if index < half then
		-- shift everything < index to the left
		for i = 1, index - 1 do
			local j = self.index + i - 1
			self.elements[j - 1] = self.elements[j]
		end
		self.index = self.index - 1
	else
		-- shift everything >= index to the right
		for i = self.length, index, -1 do
			local j = self.index + i - 1
			self.elements[j + 1] = self.elements[j]
		end
	end

	self.elements[self.index + index - 1] = element
	self.length = self.length + 1
end

function DequeClass.remove<T>(self: Deque<T>, index: number)
	local drained = self:drain(index, 1)
	return drained[1]
end

function DequeClass.popBack<T>(self: Deque<T>)
	local drained = self:drain(self.length, 1)
	return drained[1]
end

function DequeClass.pushBack<T>(self: Deque<T>, element: T)
	self:insert(self.length + 1, element)
end

function DequeClass.popFront<T>(self: Deque<T>)
	local drained = self:drain(1, 1)
	return drained[1]
end

function DequeClass.pushFront<T>(self: Deque<T>, element: T)
	self:insert(1, element)
end

function DequeClass.replace<T>(self: Deque<T>, index: number, element: T)
	assert(index > 0 and index <= self.length + 1, "Index out of range.")
	self.elements[self.index + index - 1] = element
end

function DequeClass.swap<T>(self: Deque<T>, i: number, j: number)
	local iv = self:getElement(i)
	local jv = self:getElement(j)

	self:replace(i, jv)
	self:replace(j, iv)
end

function DequeClass.rotate<T>(self: Deque<T>, steps: number)
	if steps > 0 then
		for i = 1, steps do
			local element = self:popBack()
			self:pushFront(element)
		end
	elseif steps < 0 then
		for i = 1, math.abs(steps) do
			local element = self:popFront()
			self:pushBack(element)
		end
	end
end

function DequeClass.reverse<T>(self: Deque<T>)
	local half = math.floor(self.length / 2)
	local lastIndex = self.index + self.length - 1

	for i = 1, half do
		local j = self.index + i - 1
		local k = lastIndex - i + 1

		self.elements[j], self.elements[k] = self.elements[k], self.elements[j]
	end
end

function DequeClass.clone<T>(self: Deque<T>)
	local elements = self:getElements()
	return DequeClass.raw(elements)
end

function DequeClass.clear<T>(self: Deque<T>)
	self.index = 1
	self.length = 0
	self.elements = {}
end

--

return DequeClass

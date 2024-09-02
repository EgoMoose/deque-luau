--!strict

--[=[
	@class Deque

	Deques are a generalization of stacks and queues (the name is pronounced "deck" and is short for "double-ended queue").
]=]
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

--[=[
	@within Deque
	@tag Constructors

	Creates a deque with the provided elements list.

	@param elements { T } -- will not be mutated
	@return Deque<T>
]=]
function DequeClass.new<T>(elements: { T })
	return DequeClass.raw(table.clone(elements))
end

--[=[
	@within Deque
	@tag Constructors

	Creates a deque with the provided elements list.
	
	This constructor is more efficient if you don't care that the table provided will be mutated as it will not be cloned.
	If you are unsure what constructor to use then it's safer to use `.new` instead.

	@param elements { T } -- will be mutated
	@return Deque<T>
]=]
function DequeClass.raw<T>(elements: { T }): Deque<T>
	local self = setmetatable({}, DequeClass) :: Deque<T>

	self.index = 1
	self.length = #elements
	self.elements = elements

	return self
end

-- Public Methods

--[=[
	@within Deque
	@tag Methods

	Returns the element at the provided index. This method will error if the provided index is out of range.
	
	@param index number
	@return T
]=]
function DequeClass.getElement<T>(self: Deque<T>, index: number)
	assert(index > 0 and index <= self.length, "Index out of range.")
	return self.elements[self.index + index - 1]
end

--[=[
	@within Deque
	@tag Methods

	Returns all the elements in the deque as an array.
	
	@return { T }
]=]
function DequeClass.getElements<T>(self: Deque<T>): { T }
	local elementsCopy = table.create(self.length, nil)
	table.move(self.elements, self.index, self.index + self.length - 1, 1, elementsCopy)
	return elementsCopy
end

--[=[
	@within Deque
	@tag Methods

	Returns the number of elements in the deque.
	
	@return number
]=]
function DequeClass.getLength<T>(self: Deque<T>)
	return self.length
end

--[=[
	@within Deque
	@tag Methods

	Searches for the element in the deque and if found returns its index.
	
	@param element T
	@return number?
]=]
function DequeClass.find<T>(self: Deque<T>, element: T): number?
	for i = 1, self.length do
		local j = self.index + (i - 1)
		if self.elements[j] == element then
			return j
		end
	end
	return nil
end

--[=[
	@within Deque
	@tag Methods

	Removes multiple elements from the deque and returns them.

	The provided combination of `from` and `length` cannot fall out of the following bounds `[1, deque:getLength()]` or an error will occur.
	
	@param from number -- the starting index of the removal
	@param length number -- how many elements to remove
	@return { T }
]=]
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

--[=[
	@within Deque
	@tag Methods

	Inserts a new element in the provided index of the deque shifting as few existing elements as possible.

	The provided index cannot fall out of the following bounds `[1, deque:getLength() + 1]` or an error will occur.
	
	@param index number
	@param element T
]=]
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

--[=[
	@within Deque
	@tag Methods

	Removes the element at the provided index of the deque while shifting as few existing elements as possible.

	The provided index cannot fall out of the following bounds `[1, queue:getLength()]` or an error will occur.
	
	@param index number
	@return T
]=]
function DequeClass.remove<T>(self: Deque<T>, index: number)
	local drained = self:drain(index, 1)
	return drained[1]
end

--[=[
	@within Deque
	@tag Methods

	Removes the element at the end of the deque and returns it.

	If the deque is empty this method will error.
	
	@return T
]=]
function DequeClass.popBack<T>(self: Deque<T>)
	local drained = self:drain(self.length, 1)
	return drained[1]
end

--[=[
	@within Deque
	@tag Methods

	Appends the element at the end of the deque.
	
	@param element T
]=]
function DequeClass.pushBack<T>(self: Deque<T>, element: T)
	self:insert(self.length + 1, element)
end

--[=[
	@within Deque
	@tag Methods

	Removes the element at the front of the deque and returns it.

	If the deque is empty this method will error.
	
	@return T
]=]
function DequeClass.popFront<T>(self: Deque<T>)
	local drained = self:drain(1, 1)
	return drained[1]
end

--[=[
	@within Deque
	@tag Methods

	Prepends the element at the front of the deque.
	
	@param element T
]=]
function DequeClass.pushFront<T>(self: Deque<T>, element: T)
	self:insert(1, element)
end

--[=[
	@within Deque
	@tag Methods

	Replaces the element at the index in the deque.

	The provided index cannot fall out of the following bounds `[1, deque:getLength()]` or an error will occur.
	
	@param index number
	@param element T
]=]
function DequeClass.replace<T>(self: Deque<T>, index: number, element: T)
	assert(index > 0 and index <= self.length + 1, "Index out of range.")
	self.elements[self.index + index - 1] = element
end

--[=[
	@within Deque
	@tag Methods

	Swaps two elements already in the deque with each other.

	The provided indices cannot fall out of the following bounds `[1, deque:getLength()]` or an error will occur.
	
	@param i number -- the index of element A
	@param j number -- the index of element B
]=]
function DequeClass.swap<T>(self: Deque<T>, i: number, j: number)
	local iv = self:getElement(i)
	local jv = self:getElement(j)

	self:replace(i, jv)
	self:replace(j, iv)
end

--[=[
	@within Deque
	@tag Methods

	Rotate the deque n steps to the right. If n is negative, rotate to the left.

	Rotating one step to the right is equivalent to:
	```lua
	deque:pushFront(deque:popBack())
	```

	Rotating one step to the left is equivalent to:
	```lua
	deque:pushBack(deque:popFront())
	```
	
	@param n number
]=]
function DequeClass.rotate<T>(self: Deque<T>, n: number)
	if n > 0 then
		for i = 1, n do
			self:pushFront(self:popBack())
		end
	elseif n < 0 then
		for i = 1, math.abs(n) do
			self:pushBack(self:popFront())
		end
	end
end

--[=[
	@within Deque
	@tag Methods

	Reverses the elements of the deque in-place.
]=]
function DequeClass.reverse<T>(self: Deque<T>)
	local half = math.floor(self.length / 2)
	local lastIndex = self.index + self.length - 1

	for i = 1, half do
		local j = self.index + i - 1
		local k = lastIndex - i + 1

		self.elements[j], self.elements[k] = self.elements[k], self.elements[j]
	end
end

--[=[
	@within Deque
	@tag Methods

	Creates a shallow copy of the deque.

	@return Deque<T>
]=]
function DequeClass.clone<T>(self: Deque<T>)
	local elements = self:getElements()
	return DequeClass.raw(elements)
end

--[=[
	@within Deque
	@tag Methods

	Remove all elements from the deque leaving it with length 0.

	@return Deque<T>
]=]
function DequeClass.clear<T>(self: Deque<T>)
	self.index = 1
	self.length = 0
	self.elements = {}
end

--[=[
	@within Deque
	@tag Methods

	Provides an iterator that will travel through all elements of the deque.

	@param reversed boolean? -- if the iterator should travel backwards
	@return () -> (number, T)
]=]
function DequeClass.iterate<T>(self: Deque<T>, reversed: boolean?)
	local i = 0
	local sign = if reversed then -1 else 1
	local start = if reversed then self.length + 1 else 0
	return function()
		i = i + 1
		if i <= self.length then
			local j = start + (sign * i)
			return j, self.elements[self.index + j - 1]
		end
		return nil :: any, nil :: any
	end
end

--

return DequeClass

--!strict

local function generateAlphabet(length: number)
	local alphabet = {}
	for i = 1, math.min(length, 26) do
		table.insert(alphabet, string.char(97 + i - 1))
	end
	return alphabet
end

local ALPHABET = table.freeze(generateAlphabet(26))

return function()
	local DequeClass = require(script.Parent)

	describe(".raw()", function()
		it("should mutate the input elements list", function()
			local alphabet = table.clone(ALPHABET)
			local d = DequeClass.raw(alphabet)

			d:popBack()

			expect(#alphabet).to.equal(#ALPHABET - 1)
			expect(d:getElement(d:getLength())).to.equal(alphabet[#alphabet])
		end)
	end)

	describe(".new()", function()
		it("should not mutate the input elements list", function()
			local d = DequeClass.new(ALPHABET)

			d:popFront()

			expect(d:getLength()).to.never.equal(#ALPHABET)
			expect(d:getElement(1)).to.never.equal(ALPHABET[1])
		end)
	end)

	describe(":getElement()", function()
		it("should return the element at the index in the deque", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				expect(d:getElement(i)).to.equal(ALPHABET[i])
			end
		end)

		it("should error if the index is out of bounds", function()
			local d = DequeClass.new({})

			expect(function()
				d:getElement(2)
			end).to.throw()
		end)
	end)

	describe(":getElements()", function()
		it("should match after construction", function()
			local d = DequeClass.new(ALPHABET)
			local elements = d:getElements()

			expect(#elements).to.equal(#ALPHABET)

			for i = 1, #elements do
				expect(elements[i]).to.equal(ALPHABET[i])
			end
		end)

		it("should match after mutation", function()
			local d = DequeClass.new(ALPHABET)

			d:popFront()
			d:popBack()
			d:popFront()
			d:popBack()

			local elements = d:getElements()
			expect(#elements).to.equal(#ALPHABET - 4)

			for i = 1, #elements do
				expect(elements[i]).to.equal(ALPHABET[i + 2])
			end
		end)

		it("should match when a nil value is at the front of the deque", function()
			local d = DequeClass.new(ALPHABET :: { string? })
			d:pushFront(nil)

			local elements = d:getElements()
			expect(#elements).to.equal(#ALPHABET + 1)

			for i = 2, #elements do
				expect(elements[i]).to.equal(ALPHABET[i - 1])
			end

			expect(elements[1]).to.equal(nil)
		end)

		it("should match when a nil value is in the middle of the deque", function()
			local d = DequeClass.new(ALPHABET :: { string? })
			local middle = math.floor(#ALPHABET / 2)
			d:insert(middle, nil)

			local elements = d:getElements()
			expect(#elements).to.equal(#ALPHABET + 1)

			for i = 1, #elements do
				if i < middle then
					expect(elements[i]).to.equal(ALPHABET[i])
				elseif i == middle then
					expect(elements[i]).to.equal(nil)
				else
					expect(elements[i]).to.equal(ALPHABET[i - 1])
				end
			end
		end)
	end)

	describe(":getLength()", function()
		it("after construction", function()
			local d = DequeClass.new(ALPHABET)

			expect(d:getLength()).to.equal(#ALPHABET)
		end)

		it("after :popFront()", function()
			local d = DequeClass.new(ALPHABET)

			for i = #ALPHABET, 1, -1 do
				d:popFront()
				expect(d:getLength()).to.equal(i - 1)
			end
		end)

		it("after :pushFront()", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				d:pushFront(ALPHABET[i])
				expect(d:getLength()).to.equal(#ALPHABET + i)
			end
		end)

		it("after :popBack()", function()
			local d = DequeClass.new(ALPHABET)

			for i = #ALPHABET, 1, -1 do
				d:popBack()
				expect(d:getLength()).to.equal(i - 1)
			end
		end)

		it("after :pushBack()", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				d:pushBack(ALPHABET[i])
				expect(d:getLength()).to.equal(#ALPHABET + i)
			end
		end)

		it("after :insert()", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				d:insert(20, ALPHABET[i])
				expect(d:getLength()).to.equal(#ALPHABET + i)
			end
		end)

		it("after :remove()", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				d:remove(1)
				expect(d:getLength()).to.equal(#ALPHABET - i)
			end
		end)

		it("after :drain()", function()
			local d = DequeClass.new(ALPHABET)
			local half = math.floor(#ALPHABET / 2)

			d:drain(1, half)
			expect(d:getLength()).to.equal(#ALPHABET - half)
		end)

		it("after :clear()", function()
			local d = DequeClass.new(ALPHABET)

			d:clear()
			expect(d:getLength()).to.equal(0)
		end)

		it("after :swap()", function()
			local d = DequeClass.new(ALPHABET)
			local half = math.floor(#ALPHABET / 2)

			for i = 1, half do
				d:swap(i, #ALPHABET + 1 - i)
				expect(d:getLength()).to.equal(#ALPHABET)
			end
		end)

		it("after :clone()", function()
			local d = DequeClass.new(ALPHABET):clone()

			expect(d:getLength()).to.equal(#ALPHABET)
		end)

		it("after :reverse()", function()
			local d = DequeClass.new(ALPHABET)
			d:reverse()

			expect(d:getLength()).to.equal(#ALPHABET)
		end)
	end)

	describe(":find()", function()
		it("should return the index of things in the deque", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				expect(d:find(ALPHABET[i])).to.equal(i)
			end
		end)

		it("should return nil for things not in the deque", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				expect(d:find(tostring(i))).to.equal(nil)
			end
		end)
	end)

	describe(":drain()", function()
		it("remove a chunk from the deque", function()
			local d = DequeClass.new(ALPHABET)

			local half = math.floor(#ALPHABET / 2)
			d:drain(1, half)

			for i = half + 1, #ALPHABET do
				expect(d:getElement(i - half)).to.equal(ALPHABET[i])
			end
		end)

		it("return the removed elements", function()
			local d = DequeClass.new(ALPHABET)

			local fourth = math.floor(#ALPHABET / 4)
			local drained = d:drain(fourth, fourth)

			expect(#drained).to.equal(fourth)

			for i = fourth, (fourth * 2) - 1 do
				expect(drained[i - fourth + 1]).to.equal(ALPHABET[i])
			end
		end)

		it("should fail if the inputs are out of range", function()
			local d = DequeClass.new({})

			expect(function()
				d:drain(2, 3)
			end).to.throw()
		end)
	end)

	describe(":insert()", function()
		it("should match construction", function()
			local d = DequeClass.new(ALPHABET)
			local d2 = DequeClass.new({})

			for i = 1, #ALPHABET do
				d2:insert(d2:getLength() + 1, ALPHABET[i])
			end

			for i = 1, #ALPHABET do
				expect(d2:getElement(i)).to.equal(d:getElement(i))
			end
		end)

		it("should match :reverse()", function()
			local d = DequeClass.new(ALPHABET)
			d:reverse()
			local d2 = DequeClass.new({})

			for i = 1, #ALPHABET do
				d2:insert(1, ALPHABET[i])
			end

			for i = 1, #ALPHABET do
				expect(d2:getElement(i)).to.equal(d:getElement(i))
			end
		end)

		it("should fail if index is out of range", function()
			local d = DequeClass.new({})

			expect(function()
				d:insert(2, ALPHABET[1])
			end).to.throw()
		end)
	end)

	describe(":remove()", function()
		it("should remove from back", function()
			local d = DequeClass.new(ALPHABET)

			for i = #ALPHABET, 1, -1 do
				local popped = d:remove(i)
				expect(popped).to.equal(ALPHABET[i])
			end

			expect(d:getLength()).to.equal(0)
		end)

		it("should remove from front", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				local popped = d:remove(1)
				expect(popped).to.equal(ALPHABET[i])
			end

			expect(d:getLength()).to.equal(0)
		end)

		it("should remove from middle", function()
			local d = DequeClass.new(ALPHABET)
			local half = math.floor(#ALPHABET / 2)

			local mutatedAlphabet = table.clone(ALPHABET)
			local removed = table.remove(mutatedAlphabet, half)

			local popped = d:remove(half)

			expect(popped).to.equal(ALPHABET[half])
			expect(popped).to.equal(removed)
			expect(d:getLength()).to.equal(#mutatedAlphabet)

			for i = 1, #mutatedAlphabet do
				expect(d:getElement(i)).to.equal(mutatedAlphabet[i])
			end
		end)

		it("should fail if index is out of range", function()
			local d = DequeClass.new({})

			expect(function()
				d:remove(2)
			end).to.throw()
		end)
	end)

	describe(":popBack()", function()
		it("should remove from back", function()
			local d = DequeClass.new(ALPHABET)

			for i = #ALPHABET, 1, -1 do
				local popped = d:popBack()
				expect(popped).to.equal(ALPHABET[i])
			end

			expect(d:getLength()).to.equal(0)
		end)

		it("should fail if empty", function()
			local d = DequeClass.new({})

			expect(function()
				d:popBack()
			end).to.throw()
		end)
	end)

	describe(":pushBack()", function()
		it("should insert at the back", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				d:pushBack(ALPHABET[i])
			end

			for i = 1, #ALPHABET * 2 do
				expect(d:getElement(i)).to.equal(ALPHABET[(i - 1) % #ALPHABET + 1])
			end

			expect(d:getLength()).to.equal(#ALPHABET * 2)
		end)
	end)

	describe(":popFront()", function()
		it("should remove from front", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				local popped = d:popFront()
				expect(popped).to.equal(ALPHABET[i])
			end

			expect(d:getLength()).to.equal(0)
		end)

		it("should fail if empty", function()
			local d = DequeClass.new({})

			expect(function()
				d:popFront()
			end).to.throw()
		end)
	end)

	describe(":pushFront()", function()
		it("should insert at the front", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				d:pushFront(ALPHABET[i])
			end

			for i = 1, #ALPHABET do
				expect(d:getElement(i)).to.equal(ALPHABET[#ALPHABET - i + 1])
			end

			for i = 1, #ALPHABET do
				expect(d:getElement(#ALPHABET + i)).to.equal(ALPHABET[i])
			end

			expect(d:getLength()).to.equal(#ALPHABET * 2)
		end)
	end)

	describe(":replace()", function()
		it("should replace the element in the deque", function()
			local d = DequeClass.new(ALPHABET)

			for i = 1, #ALPHABET do
				local v = d:getElement(i)
				d:replace(i, v:upper())
				expect(d:getElement(i)).to.equal(ALPHABET[i]:upper())
			end
		end)

		it("should fail if index is out of range", function()
			local d = DequeClass.new({})

			expect(function()
				d:replace(2, ALPHABET[1])
			end).to.throw()
		end)
	end)

	describe(":swap()", function()
		it("should match :reverse()", function()
			local d = DequeClass.new(ALPHABET)
			local dr = d:clone()
			dr:reverse()

			for i = 1, math.floor(#ALPHABET / 2) do
				d:swap(i, #ALPHABET - i + 1)
			end

			for i = 1, #ALPHABET do
				expect(d:getElement(i)).to.equal(dr:getElement(i))
			end
		end)

		it("should fail if the inputs are out of range", function()
			local d = DequeClass.new({})

			expect(function()
				d:swap(2, 3)
			end).to.throw()
		end)
	end)

	describe(":rotate()", function()
		it("should shift elements to the right", function()
			for i = 1, #ALPHABET do
				local d = DequeClass.new(ALPHABET)
				d:rotate(i)
				for j = 1, #ALPHABET do
					local k = (j + i - 1) % #ALPHABET + 1
					expect(d:getElement(k)).to.equal(ALPHABET[j])
				end
			end
		end)

		it("should match shifting elements to the right by one", function()
			for i = 1, #ALPHABET do
				local d = DequeClass.new(ALPHABET)
				local d2 = DequeClass.new(ALPHABET)

				d:rotate(i)
				for j = 1, i do
					d2:rotate(1)
				end

				for j = 1, #ALPHABET do
					expect(d:getElement(j)).to.equal(d2:getElement(j))
				end
			end
		end)

		it("should shift elements to the left", function()
			for i = 1, #ALPHABET do
				local d = DequeClass.new(ALPHABET)
				d:rotate(-i)
				for j = 1, #ALPHABET do
					local k = (j - i - 1) % #ALPHABET + 1
					expect(d:getElement(k)).to.equal(ALPHABET[j])
				end
			end
		end)

		it("should match shifting elements to the left by one", function()
			for i = 1, #ALPHABET do
				local d = DequeClass.new(ALPHABET)
				local d2 = DequeClass.new(ALPHABET)

				d:rotate(-i)
				for j = 1, i do
					d2:rotate(-1)
				end

				for j = 1, #ALPHABET do
					expect(d:getElement(j)).to.equal(d2:getElement(j))
				end
			end
		end)

		it("should not shift when steps are zero", function()
			local d = DequeClass.new(ALPHABET)
			d:rotate(0)

			for i = 1, #ALPHABET do
				expect(d:getElement(i)).to.equal(ALPHABET[i])
			end
		end)
	end)

	describe(":reverse()", function()
		it("should match after construction", function()
			local d = DequeClass.new(ALPHABET)
			local dr = d:clone()
			dr:reverse()

			local length = d:getLength()
			expect(length).to.equal(dr:getLength())

			for i = 1, length do
				expect(d:getElement(i)).to.equal(dr:getElement(length - i + 1))
			end
		end)

		it("should match after mutation", function()
			local d = DequeClass.new(ALPHABET)

			d:popFront()
			d:popBack()
			d:popFront()
			d:popBack()

			local dr = d:clone()
			dr:reverse()

			local length = d:getLength()
			expect(length).to.equal(dr:getLength())

			for i = 1, length do
				expect(d:getElement(i)).to.equal(dr:getElement(length - i + 1))
			end
		end)
	end)

	describe(":clone()", function()
		it("should match after construction", function()
			local d = DequeClass.new(ALPHABET)
			local dc = d:clone()

			expect(d:getLength()).to.equal(dc:getLength())

			for i = 1, d:getLength() do
				expect(d:getElement(i)).to.equal(dc:getElement(i))
			end
		end)

		it("should match after mutation", function()
			local d = DequeClass.new(ALPHABET)

			d:popFront()
			d:popBack()
			d:popFront()
			d:popBack()

			local qc = d:clone()

			expect(d:getLength()).to.equal(qc:getLength())

			for i = 1, d:getLength() do
				expect(d:getElement(i)).to.equal(qc:getElement(i))
			end
		end)
	end)

	describe(":clear()", function()
		it("should empty the deque", function()
			local d = DequeClass.new(ALPHABET)
			d:clear()

			expect(d:getLength()).to.equal(0)
		end)
	end)
end

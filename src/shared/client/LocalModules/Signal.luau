--@icodedstevejobs Leila S.
-- CustomSignal.lua

local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = setmetatable({}, Signal)
	self._connections = {}
	self._isFiring = false
	self._pendingRemovals = {}
	return self
end

function Signal:Connect(callback)
	assert(typeof(callback) == "function", "Callback must be a function.")

	local connection = {
		Connected = true,
		Callback = callback,
		Disconnect = function(conn)
			conn.Connected = false
			if self._isFiring then
				table.insert(self._pendingRemovals, conn)
			else
				self._connections[conn] = nil
			end
		end
	}

	self._connections[connection] = true
	return connection
end

function Signal:Once(callback)
	assert(typeof(callback) == "function", "Callback must be a function.")

	local connection
	connection = self:Connect(function(...)
		if connection.Connected then
			connection:Disconnect()
			callback(...)
		end
	end)
	return connection
end

function Signal:Wait()
	local thread = coroutine.running()
	local connection
	connection = self:Connect(function(...)
		if connection.Connected then
			connection:Disconnect()
			coroutine.resume(thread, ...)
		end
	end)
	return coroutine.yield()
end

function Signal:Fire(...)
	self._isFiring = true
	for connection, _ in pairs(self._connections) do
		if connection.Connected then
			task.spawn(connection.Callback, ...)
		end
	end
	self._isFiring = false

	for _, conn in ipairs(self._pendingRemovals) do
		self._connections[conn] = nil
	end
	table.clear(self._pendingRemovals)
end

function Signal:DisconnectAll()
	for connection, _ in pairs(self._connections) do
		connection.Connected = false
	end
	table.clear(self._connections)
	table.clear(self._pendingRemovals)
end

function Signal:Destroy()
	self:DisconnectAll()
	setmetatable(self, nil)
end

export type Signal = typeof(Signal.new())

return Signal
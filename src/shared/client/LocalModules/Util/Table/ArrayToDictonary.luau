return function<T, U>(t: {[T]: U})
	local out = {}
	for _, v in t do
		out[v] = v
	end
	return out
end
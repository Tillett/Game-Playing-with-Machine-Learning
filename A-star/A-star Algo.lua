function input_beginning_string(input_string)
	local leaveLoop = false;
	local iterator = 1;
	local binInputs = {};
	
	while not leaveLoop do
		if not (input_string == nil) then
			if not (input_string[iterator] == nil) then
				binInputs = input_dec_to_bin(input_string[iterator]);
				
				advance_frames(binInputs);
				
				iterator = iterator + 1;
			else
				leaveLoop = true;
			end
		else
			leaveLoop = true;
		end
	end
end

function input_dec_to_bin(decimal)
	
	local tUp, tDown, tLeft, tRight, tA, tB;
	local finalInputs, current;
	
	--This holds the values for testing divisibility
	local tempDec = decimal;
	
	--convert to binary string
	local t={} -- will contain the bits
    while tempDec>0 do
        rest = math.fmod(tempDec,2);
        t[#t + 1] = rest;
        tempDec = (tempDec - rest) / 2;
    end
	
	if t[1] == 1 then
		tUp = true;
	else
		tUp = false;
	end
	
	if t[2] == 1 then
		tDown = true;
	else
		tDown = false;
	end
	
	if t[3] == 1 then
		tLeft = true;
	else
		tLeft = false;
	end
	
	if t[4] == 1 then
		tRight = true;
	else
		tRight = false;
	end
	
	if t[5] == 1 then
		tA = true;
	else
		tA = false;
	end
	
	if t[6] == 1 then
		tB = true;
	else
		tB = false;
	end
	
	
	finalInputs = {
        up      = tUp,
        down    = tDown,
        left    = tLeft,
        right   = tRight,
        A       = tA,
        B       = tB,
        start   = false,
        select  = false
    };
	
	return finalInputs;
end

function advance_frames(inputs)
	local amountOfFrames = 20;
	
	for i = 0, amountOfFrames do
		joypad.set(1, inputs);
		emu.frameadvance()
	end
	
	return true;
end

--When using this function, there must not be nil values between real values
function list_copy_unknown_size(list)
	local newList = {};
	local iterator = 1;
	local leaveLoop = false;
	
	while not leaveLoop do
		if not (list[iterator] == nil) then
			newList[iterator] = list[iterator];
			
			iterator = iterator + 1;
		else
			leaveLoop = true;
		end
	end
	
	return newList;
end

function list_copy_and_add(list, addition)
	local newList = {};
	local iterator = 1;
	local leaveLoop = false;
	
	while not leaveLoop do
		if not (list[iterator] == nil) then
			newList[iterator] = list[iterator];
			
			iterator = iterator + 1;
		else
			leaveLoop = true;
		end
	end
	
	newList[iterator] = addition;
	
	return newList;
end

function list_copy_and_subtract(list, subtraction)
	local tempList = {};
	local newList = {};
	local iterator = 1;
	local finalSize = 0;
	local leaveLoop = false;
	
	while not leaveLoop do
		if not (list[iterator] == nil) then
			tempList[iterator] = list[iterator];
			
			iterator = iterator + 1;
		else
			leaveLoop = true;
		end
	end
	
	finalSize = iterator - subtraction;
	
	for i = 1, finalSize do
		newList[i] = tempList[i];
	end
	
	return newList;
end

function list_copy_known_size(list, size)
	local newList = {};
	
	for i = 1, size do
		newList[i] = list[i];
	end
	
	return newList;
end

function generate_model_string(successes, maximum)
	local modelString = {};
	local i = 1;
	local leaveLoop = false;
	local nilCount = 0;
	local inputNumber;
	local inputList = {};
	
	while not leaveLoop do
		for j=1, maximum do
			if successes[j][i] == nil then
				nilCount = nilCount + 1;
			else
				input = successes[j][i];
				
				if inputList[input] == nil then
					inputList[input] = 1;
				else
					inputList[input] = inputList[input] + 1;
				end
			end
		end
		
		if nilCount == maximum then
			leaveLoop = true;
		else
			input = maximum_value_from_list(inputList);
			modelString = list_copy_and_add(modelString, input);
			inputList = {};
		end
		
		i = i + 1;
		inputList = {};
	end
	
	return modelString;
end

function maximum_value_from_list(list)
	local MIN_INDEX = 1;
	local MAX_INDEX = 70;
	local amount, value;
	local leaveLoop = false;
	local iterator = MIN_INDEX;
	
	amount = custom_max(list);
	print("Amount is "..amount);
	
	while not leaveLoop do
		if iterator < MAX_INDEX then
			if list[iterator] == amount then
				value = iterator;
				leaveLoop = true;
			else
				iterator = iterator + 1;
			end
		else
			value = 56;
			leaveLoop = true;
		end
	end
	
	return value;
end

function custom_max(list)
	local maxNumber = 0;
	local currentNumber;
	
	for i = 1, 64 do
		if list[i] == nil then
			currentNumber = 0;
		else
			currentNumber = list[i];
		end
		
		if currentNumber > maxNumber then
			maxNumber = currentNumber;
		end
	end
	
	return maxNumber;
end
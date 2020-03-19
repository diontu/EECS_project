note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
		do
			-- initialize output string
			create output.make
			create s.make_empty
			i := 0
		end

feature -- model attributes
	s : STRING
	i : INTEGER

	-- states

feature -- states
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end



feature -- output to the screen
		-- write output
	output: STRING

	out : STRING
		do
			create Result.make_empty
			Result := output
		end

end





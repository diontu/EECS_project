note
	description: "Summary description for {GAME_STATE_ACCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	GAME_STATE_ACCESS

feature
	gs: GAME_STATE
		once
			create Result.make
		end

invariant
	gs = gs

end

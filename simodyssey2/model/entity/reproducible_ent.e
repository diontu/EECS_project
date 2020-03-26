note
	description: "Summary description for {REPRODUCIBLE_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REPRODUCIBLE_ENT

inherit
	FUELED_ENT

feature -- actions left
	max_actions_left: INTEGER
		deferred
		end

	actions_left: INTEGER
		deferred
		end

	reset_actions
		deferred
		end

	decrement_actions
		deferred
		end

end

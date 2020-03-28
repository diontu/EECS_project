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

feature -- turns_left
	turns_left: INTEGER
		deferred
		end

	set_turns (amount: INTEGER)
		require
			valid_amount: amount >=0 and amount <= 3
		deferred
		end

	decrement_turns
		deferred
		end

end

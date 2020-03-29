note
	description: "Summary description for {FUELED_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FUELED_ENT

inherit
	ENTITY

feature -- fuel deferred
	max_fuel: INTEGER
		deferred
		end

	fuel: INTEGER
		deferred
		end

	increment_fuel_by(amount: INTEGER)
		require
			valid_amount: amount > 0
		deferred
		ensure
			valid_life: fuel <= max_fuel
		end

	decrement_fuel_by(amount: INTEGER)
		require
			valid_amount: amount > 0
		deferred
		ensure
			valid_fuel: fuel >= 0
		end

	change_fuel(amount: INTEGER)
		require
			valid_amount: amount <=3 and amount >=0
		deferred
		end

	entity : STRING
	deferred
	end

feature -- wormhole usage deferred
	used_wormhole: BOOLEAN
		deferred
		end

	in_wormhole
		deferred
		end

	not_in_wormhole
		deferred
		end

feature -- death of entity deferred
	death_row: INTEGER
		deferred
		end

	death_column: INTEGER
		deferred
		end

	died
		deferred
		end

	is_dead: BOOLEAN
		deferred
		end

	set_death (row: INTEGER; col:  INTEGER)
		deferred
		end

end

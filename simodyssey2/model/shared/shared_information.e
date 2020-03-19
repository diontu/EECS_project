note
	description: "[
		Common variables such as threshold for planet
		and constants such as number of stationary items for generation of the board.
		]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHARED_INFORMATION

create {SHARED_INFORMATION_ACCESS}
	make

feature{NONE}
	make
		do
			-------------------- ADDED start --------------------
			planet_id := default_planet_id
			stationary_id := default_stationary_id
			can_end_game := false
			-------------------- ADDED end --------------------
		end

feature

	number_rows: INTEGER = 5
        	-- The number of rows in the grid

	number_columns: INTEGER = 5
        	-- The number of columns in the  grid

	number_of_stationary_items: INTEGER = 10
			-- The number of stationary_items in the grid

    planet_threshold: INTEGER
		-- used to determine the chance of a planet being put in a location
		attribute
			Result := 50
		end

	max_capacity: INTEGER = 4
		 -- max number of objects that can be stored in a location

	-------------------- ADDED start --------------------
	planet_id: INTEGER

	stationary_id: INTEGER

	can_end_game: BOOLEAN
	-------------------- ADDED end --------------------

feature --commands
	set_planet_threshold(threshold:INTEGER)
		require
			valid_threshold:
				0 < threshold and threshold <= 101
		do
			planet_threshold:=threshold
		end

	-------------------- ADDED start --------------------
	reset_pid_sid
		do
			planet_id := default_planet_id
			stationary_id := default_stationary_id
		end

	end_game
		do
			can_end_game := true
		end

	reset_end_state
		do
			can_end_game := false
		end

	reset
		do
			reset_pid_sid
			reset_end_state
		end

	increment_planet_id
		do
			planet_id := planet_id + 1
		end

	decrement_stationary_id
		do
			stationary_id := stationary_id - 1
		end


feature {NONE} -- private attributes
	default_planet_id: INTEGER
		do
			Result := 1
		end

	default_stationary_id: INTEGER
		do
			Result := -2
		end
	-------------------- ADDED end --------------------

end

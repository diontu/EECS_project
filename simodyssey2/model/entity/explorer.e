note
	description: "Summary description for {EXPLORER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER

inherit
	ENTITY

create
	make

feature {NONE} -- constructor
	make
		do
			max_life := 3
			max_fuel := 3
			life := max_life
			fuel := max_fuel
			is_dead := false
			is_landed := false
			position := default_pos
			used_wormhole := false
		end

feature -- commands
	reset
		do
			life := max_life
			fuel := max_fuel
			is_dead := false
			is_landed := false
			position := default_pos
		end

	increment_fuel_by(amount: INTEGER)
		require
			valid_amount: amount > 0
		do
			if amount + fuel > max_fuel then
				fuel := max_fuel
			else
				fuel := fuel + amount
			end
		ensure
			valid_life: fuel <= max_fuel
		end

	decrement_fuel_by(amount: INTEGER)
		require
			valid_amount: amount > 0
		do
			if amount > fuel then
				fuel := 0
				life := 0
				is_dead := true
			else
				fuel := fuel - amount
			end
		ensure
			valid_fuel: fuel >= 0
		end

	change_fuel(amount: INTEGER)
		require
			valid_amount: amount <=3 and amount >=0
		do
			fuel := amount
		end

	increment_life_by(amount: INTEGER)
		require
			valid_amount: amount > 0
		do
			if amount + life > max_life then
				life := max_life
			else
				life := life + amount
			end
		ensure
			valid_life: life <= max_life
		end

	decrement_life_by(amount: INTEGER)
		require
			valid_amount: amount > 0
		do
			if amount > life then
				life := 0
				is_dead := true
			else
				life := life - amount
			end
		ensure
			valid_life: life >= 0
		end

	land
		do
			is_landed := true
		end

	liftoff
		do
			is_landed := false
		end

	add_pos(pos: TUPLE[INTEGER, INTEGER])
		do
			position := pos
		end

	explorer_in_wormhole
		do
			used_wormhole := true
		end

	explorer_not_in_wormhole
		do
			used_wormhole := false
		end

	set_death (row: INTEGER; col:  INTEGER)
		do
			death_row := row
			death_column := col
		end

feature -- explorer actions
	------------------ TEST ADDED start --------------
	lose_life
		do
			explorer_actions.lose_life
		end
	------------------ TEST ADDED end --------------


feature -- attributes
	life: INTEGER

	fuel: INTEGER

	is_dead: BOOLEAN

	is_landed: BOOLEAN

	position: TUPLE[INTEGER,INTEGER]

	death_row: INTEGER
	death_column: INTEGER

feature -- private attributes
	max_life: INTEGER
--		attribute
--			Result := 3
--		end
	max_fuel: INTEGER
--		attribute
--			Result := 3
--		end
	default_pos: TUPLE[INTEGER,INTEGER]
		attribute
			Result := [1,1]
		end

	used_wormhole: BOOLEAN

feature -- query
	explorer_actions: EXPLORER_ACTIONS
		do
			create Result.make(current)
		end

invariant
	valid_life: life >= 0 and life <= max_life
	valid_fuel: fuel >= 0 and fuel <= max_fuel

end

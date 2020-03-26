note
	description: "Summary description for {JANITAUR_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JANITAUR_ENT

inherit
	REPRODUCIBLE_ENT

create
	make

feature -- constructor
	make
		do
			max_fuel := 5
			fuel := max_fuel
			max_actions_left := 2
			actions_left := max_actions_left
			max_load_level := 2
			load_level := 0

			turns_left := 0
			position := [0,0]

			is_dead := false
			used_wormhole := false
			death_row := 0
			death_column := 0
		end

feature -- add the position	
	add_pos(pos: TUPLE[INTEGER, INTEGER])
		do
			position := pos
		end

feature -- fuel
	increment_fuel_by(amount: INTEGER)
		require else
			valid_amount: amount > 0
		do
			if amount + fuel > max_fuel then
				fuel := max_fuel
			else
				fuel := fuel + amount
			end
		ensure then
			valid_life: fuel <= max_fuel
		end

	decrement_fuel_by(amount: INTEGER)
		require else
			valid_amount: amount > 0
		do
			if amount > fuel then
				fuel := 0
				is_dead := true
			else
				fuel := fuel - amount
			end
		ensure then
			valid_fuel: fuel >= 0
		end

	change_fuel(amount: INTEGER)
		require else
			valid_amount: amount <=3 and amount >=0
		do
			fuel := amount
		end

feature -- wormhole
	in_wormhole
		do
			used_wormhole := true
		end

	not_in_wormhole
		do
			used_wormhole := false
		end


feature -- actions
	reset_actions
		do
			actions_left := max_actions_left
		end

	decrement_actions
		do
			actions_left := actions_left - 1
		end

feature -- turns
	set_turns (amount: INTEGER)
		require
			valid_amount: amount >=0 and amount <= 3
		do
			turns_left := amount
		end

	decrement_turns
		do
			turns_left := turns_left - 1
		end

feature -- load_level
	load_janitaur
		require
			available_load: load_level < 2
		do
			load_level := load_level + 1
		end

	empty_janitaur
		do
			load_level := 0
		end

	is_full: BOOLEAN
		do
			if load_level = 2 then
				Result := true
			else
				Result := false
			end
		end


feature -- is_dead?
	is_dead: BOOLEAN

	set_death (row: INTEGER; col:  INTEGER)
		do
			death_row := row
			death_column := col
		end

feature -- janitaur attributes
	load_level: INTEGER


	fuel: INTEGER
	actions_left: INTEGER

	turns_left: INTEGER
	position: TUPLE[INTEGER, INTEGER]

	used_wormhole: BOOLEAN

	death_row: INTEGER
	death_column: INTEGER

feature -- private attributes
	max_fuel: INTEGER
	max_actions_left: INTEGER
	max_load_level: INTEGER


end

note
	description: "Summary description for {MALEVOLENT_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MALEVOLENT_ENT

inherit
	ENTITY

create
	make

feature -- constructor
	make
		do
			max_fuel := 3
			fuel := max_fuel
			max_actions_left := 1
			actions_left := max_actions_left

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

feature -- is_dead?
	is_dead: BOOLEAN

	set_death (row: INTEGER; col:  INTEGER)
		do
			death_row := row
			death_column := col
		end

feature -- benign attributes
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

end

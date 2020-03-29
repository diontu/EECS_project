note
	description: "Summary description for {EXPLORER_ENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EXPLORER_ENT

inherit
	FUELED_ENT

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
			did_pass := false
		end


feature -- commands
	reset
		do
			life := max_life
			fuel := max_fuel
			is_dead := false
			is_landed := false
			position := default_pos
			used_wormhole := false
		end

	reset_turn_state
		do
			not_in_wormhole
			did_not_pass_turn
		end

	increment_fuel_by(amount: INTEGER)
		do
			if amount + fuel > max_fuel then
				fuel := max_fuel
			else
				fuel := fuel + amount
			end
		end

	decrement_fuel_by(amount: INTEGER)
		do
			if amount > fuel then
				fuel := 0
				life := 0
				is_dead := true
			else
				fuel := fuel - amount
			end
		end

	change_fuel(amount: INTEGER)
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

	change_life (amount: INTEGER)
		require
			valid_amount: life >= 0 and life <= 3
		do
			life := amount
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

	in_wormhole
		do
			used_wormhole := true
		end

	not_in_wormhole
		do
			used_wormhole := false
		end

	pass_turn
		do
			did_pass := true
		end

	did_not_pass_turn
		do
			did_pass := false
		end

	died
		do
			is_dead := true
		end

	set_death (row: INTEGER; col:  INTEGER)
		do
			death_row := row
			death_column := col
		end

	entity : STRING
	do
		Result := "explorer"
	end

feature -- attributes
	life: INTEGER

	fuel: INTEGER

	is_dead: BOOLEAN

	is_landed: BOOLEAN

	position: TUPLE[row: INTEGER; col: INTEGER]

	did_pass: BOOLEAN

	death_row: INTEGER
	death_column: INTEGER

feature -- private attributes
	max_life: INTEGER

	max_fuel: INTEGER

	default_pos: TUPLE[INTEGER,INTEGER]
		attribute
			Result := [1,1]
		end

	used_wormhole: BOOLEAN


invariant
	valid_life: life >= 0 and life <= max_life
	valid_fuel: fuel >= 0 and fuel <= max_fuel

end

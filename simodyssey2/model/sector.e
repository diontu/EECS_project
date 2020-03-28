note
	description: "Represents a sector in the galaxy."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SECTOR

create
	make, make_dummy

feature -- attributes
	shared_info_access : SHARED_INFORMATION_ACCESS

	shared_info: SHARED_INFORMATION
		attribute
			Result:= shared_info_access.shared_info
		end

	gen: RANDOM_GENERATOR_ACCESS

	contents: ARRAYED_LIST [detachable ENTITY_ALPHABET] --holds 4 quadrants

	row: INTEGER

	column: INTEGER

	entity_ids: ENTITY_IDS

feature -- constructor
	make(row_input: INTEGER; column_input: INTEGER; a_explorer:ENTITY_ALPHABET)
		--initialization
		require
			valid_row: (row_input >= 1) and (row_input <= shared_info.number_rows)
			valid_column: (column_input >= 1) and (column_input <= shared_info.number_columns)
		local
			entity_ids_access: ENTITY_IDS_ACCESS
		do
			-- entity_ids
			entity_ids := entity_ids_access.entity_ids
			row := row_input
			column := column_input
			create contents.make (shared_info.max_capacity) -- Each sector should have 4 quadrants
			contents.compare_objects
			if (row = 3) and (column = 3) then
				put (create {ENTITY_ALPHABET}.make ('O'), [row_input, column_input]) -- If this is the sector in the middle of the board, place a black hole
			else
				if (row = 1) and (column = 1) then
					put (a_explorer, [row_input, column_input]) -- If this is the top left corner sector, place the explorer there
				end
				populate([row_input, column_input]) -- Run the populate command to complete setup
			end -- if
		end

feature -- commands
	make_dummy
		--initialization without creating entities in quadrants
		local
			entity_ids_access: ENTITY_IDS_ACCESS
		do
			entity_ids := entity_ids_access.entity_ids
			create contents.make (shared_info.max_capacity)
			contents.compare_objects
		end

	populate(pos: TUPLE[INTEGER,INTEGER])
			-- this feature creates 1 to max_capacity-1 components to be intially stored in the
			-- sector. The component may be a planet or nothing at all.
		local
			threshold: INTEGER
			number_items: INTEGER
			loop_counter: INTEGER
			component: ENTITY_ALPHABET
			turn :INTEGER
		do
			number_items := gen.rchoose (1, shared_info.max_capacity-1)  -- MUST decrease max_capacity by 1 to leave space for Explorer (so a max of 3)
			from
				loop_counter := 1
			until
				loop_counter > number_items
			loop
				threshold := gen.rchoose (1, 100) -- each iteration, generate a new value to compare against the threshold values provided by `test` or `play`


				if threshold < shared_info.asteroid_threshold then
					create component.make('A')
				else
					if threshold < shared_info.janitaur_threshold then
						create component.make('J')
					else
						if (threshold < shared_info.malevolent_threshold) then
							create component.make('M')
						else
							if (threshold < shared_info.benign_threshold) then
								create component.make('B')
							else
								if threshold < shared_info.planet_threshold then
									create component.make('P')
								end
							end
						end
					end
				end


				if attached component as entity then
					put (entity, pos) -- add new entity to the contents list

					--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
					turn:=gen.rchoose (0, 2) -- Hint: Use this number for assigning turn values to the planet created
					-- The turn value of the planet created (except explorer) suggests the number of turns left before it can move.
					--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

					-------------------- ADDED start --------------------
					if attached {PLANET_ENT} entity.entity as planet_entity then
						planet_entity.set_turns(turn)
					elseif attached {BENIGN_ENT} entity.entity as benign_entity then
						benign_entity.set_turns (turn)
					elseif attached {MALEVOLENT_ENT} entity.entity as malevolent_entity then
						malevolent_entity.set_turns (turn)
					elseif attached {JANITAUR_ENT} entity.entity as janitaur_entity then
						janitaur_entity.set_turns (turn)
					elseif attached {ASTEROID_ENT} entity.entity as asteroid_entity then
						asteroid_entity.set_turns (turn)
					end
					-------------------- ADDED end --------------------

					component := void -- reset component object
				end

				loop_counter := loop_counter + 1
			end
		end

feature --command

	put (new_component: ENTITY_ALPHABET; pos: TUPLE[INTEGER, INTEGER]) -- adds the entity_alphabet on the board and the entity_ids if it doesn't already exist
			-- put `new_component' in contents array
		local
			loop_counter: INTEGER
			found: BOOLEAN
			does_exist_in_entities: BOOLEAN
			empty_space_found: BOOLEAN
			temp_contents: ARRAYED_LIST [detachable ENTITY_ALPHABET]

		do
			create temp_contents.make (shared_info.max_capacity)
			from
				loop_counter := 1
			until
				loop_counter > contents.count or found
			loop
				if contents [loop_counter] = new_component then
					found := TRUE
				end --if
				loop_counter := loop_counter + 1
			end -- loop

			-- find next available spot

			if not found then
				from
					loop_counter := 1
				until
					loop_counter > contents.count or empty_space_found
				loop
					if not attached contents[loop_counter] then
						contents[loop_counter] := new_component
						empty_space_found := true
						new_component.add_pos (pos)
						does_exist_in_entities := false
						across entity_ids.entity_ids as tuple loop
							if attached {INTEGER} tuple.item.at(1) as id then
								if id = new_component.id then
									does_exist_in_entities := true
								end
							end
						end
						if not does_exist_in_entities then
							entity_ids.add (new_component.id, new_component)
						end
					end
					loop_counter := loop_counter + 1
				end

				if not empty_space_found then
					if not is_full then
						contents.extend (new_component)
						new_component.add_pos (pos)
						does_exist_in_entities := false
						across entity_ids.entity_ids as tuple loop
							if attached {INTEGER} tuple.item.at(1) as id then
								if id = new_component.id then
									does_exist_in_entities := true
								end
							end
						end
						if not does_exist_in_entities then
							entity_ids.add (new_component.id, new_component)
						end
					end
				end
			end

		ensure
			component_put: not is_full implies contents.has (new_component)
		end

	delete(et: ENTITY_ALPHABET) -- gets rid of the entity_alphabet from the board and from the board and the entity_ids
		local
			loop_counter: INTEGER
			added: BOOLEAN
		do
--			contents.prune_all (et)
			from
				loop_counter := 1
				added := false
			until
				loop_counter > contents.count or added = true
			loop
				if attached contents[loop_counter] as content then
					if attached {ENTITY_ALPHABET} content as entity then
						if entity.id = et.id then
							contents[loop_counter] := void
							added := true
							entity_ids.delete_entity (entity.id)
						end
					end
				end
				loop_counter := loop_counter + 1
			end
		end

feature -- Queries

	print_sector: STRING
			-- Printable version of location's coordinates with different formatting
		do
			Result := ""
			Result.append (row.out)
			Result.append (":")
			Result.append (column.out)
		end

	is_full: BOOLEAN
			-- Is the location currently full?
		local
			loop_counter: INTEGER
			occupant: ENTITY_ALPHABET
			empty_space_found: BOOLEAN
		do
			if contents.count < shared_info.max_capacity then
				empty_space_found := TRUE
			end
			from
				loop_counter := 1
			until
				loop_counter > contents.count or empty_space_found
			loop
				occupant := contents [loop_counter]
				if not attached occupant  then
					empty_space_found := TRUE
				end
				loop_counter := loop_counter + 1
			end

			if contents.count = shared_info.max_capacity and then not empty_space_found then
				Result := TRUE
			else
				Result := FALSE
			end
		end

	has_stationary: BOOLEAN
			-- returns whether the location contains any stationary item
		local
			loop_counter: INTEGER
		do
			from
				loop_counter := 1
			until
				loop_counter > contents.count or Result
			loop
				if attached contents [loop_counter] as temp_item  then
					Result := temp_item.is_stationary
				end -- if
				loop_counter := loop_counter + 1
			end
		end

	has_wormhole: BOOLEAN
	local
	loop_counter : INTEGER
			-- returns whether the location contains any stationary item
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count or Result
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {WORMHOLE_ENT} content.entity then
							Result := true
						end -- if
					end
					loop_counter := loop_counter + 1
				end
		end

	has_bh: BOOLEAN
	local
	loop_counter : INTEGER
			-- returns whether the location contains any stationary item
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count or Result
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {BLACKHOLE_ENT} content.entity then
							Result := true
						end -- if
					end
					loop_counter := loop_counter + 1
				end
		end

	has_star: BOOLEAN
	local
	loop_counter : INTEGER
			-- returns whether the location contains any stationary item
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count or Result
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {STAR_ENT} content.entity then
							Result := true
						end -- if
					end
					loop_counter := loop_counter + 1
				end
		end

	has_bg: BOOLEAN
	local
	loop_counter : INTEGER
			-- returns whether the location contains any stationary item
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count or Result
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {BLUE_GIANT_ENT} content.entity then
							Result := true
						end -- if
					end
					loop_counter := loop_counter + 1
				end
		end

	has_yd: BOOLEAN
	local
	loop_counter : INTEGER
			-- returns whether the location contains any stationary item
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count or Result
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {YELLOW_DWARF_ENT} content.entity then
							Result := true
						end -- if
					end
					loop_counter := loop_counter + 1
				end
		end


	has_pl: BOOLEAN
	local
	loop_counter : INTEGER
			-- returns whether the location contains any stationary item
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count or Result
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {PLANET_ENT} content.entity then
							Result := true
						end -- if
					end
					loop_counter := loop_counter + 1
				end
		end

	has_benign: BOOLEAN
	local
	loop_counter : INTEGER
			-- returns whether the location contains any stationary item
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count or Result
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {BENIGN_ENT} content.entity then
							Result := true
						end -- if
					end
					loop_counter := loop_counter + 1
				end
		end

	return_quadrent_exp: INTEGER
local
	loop_counter : INTEGER
			-- returns quadrent of explorer
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {EXPLORER_ENT} content.entity then
							Result := loop_counter
						end -- if
						loop_counter := loop_counter + 1
					end
				end
		end
		return_quadrent_ben: INTEGER
local
	loop_counter : INTEGER
			-- returns quadrent of explorer
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {BENIGN_ENT} content.entity then
							Result := loop_counter
						end -- if
						loop_counter := loop_counter + 1
					end
				end
		end
		return_quadrent_mal: INTEGER
local
	loop_counter : INTEGER
			-- returns quadrent of explorer
		do
		from
					loop_counter := 1
				until
					loop_counter > contents.count
				loop
					if attached {ENTITY_ALPHABET} contents [loop_counter] as content then
						if attached {MALEVOLENT_ENT} content.entity then
							Result := loop_counter
						end -- if
						loop_counter := loop_counter + 1
					end
				end
		end
end

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


				if threshold < shared_info.planet_threshold then
					create component.make('P')
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
					end
					-------------------- ADDED end --------------------

					component := void -- reset component object
				end

				loop_counter := loop_counter + 1
			end
		end

feature --command

	put (new_component: ENTITY_ALPHABET; pos: TUPLE[INTEGER, INTEGER])
			-- put `new_component' in contents array
		local
			loop_counter: INTEGER
			other_counter: INTEGER
			found: BOOLEAN
			does_exist_in_entities: BOOLEAN
			emptY_space_found: BOOLEAN
			temp_contents: ARRAYED_LIST [detachable ENTITY_ALPHABET]

			next_available_spot: INTEGER
			found_next: BOOLEAN


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
--				from
--					other_counter := 1
--				until
--					other_counter >= contents.count
--				loop
--					if loop_counter = other_counter then
--						if attached temp_contents as temp then
--							temp_contents.extend (new_component)
--						end
--					else
--						if attached temp_contents as temp then
--							temp_contents.extend (contents[loop_counter])
--						end
--					end
--					other_counter := other_counter + 1
--				end

				from
					contents.start
				until
					contents.exhausted or empty_space_found
				loop
					if not attached contents.item then
						contents.replace (new_component)
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
					contents.forth
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
--				contents.extend (new_component)
--				if attached temp_contents as temp then
--					contents := temp_contents
--				end
--				new_component.add_pos (pos)
--				does_exist_in_entities := false
--				across entity_ids.entity_ids as tuple loop
--					if attached {INTEGER} tuple.item.at(1) as id then
--						if id = new_component.id then
--							does_exist_in_entities := true
--						end
--					end
--				end
--				if not does_exist_in_entities then
--					entity_ids.add (new_component.id, new_component)
--				end
			end

--		ensure
--			component_put: not is_full implies contents.has (new_component)
		end

	delete(et: ENTITY_ALPHABET)
		local
			temp: ENTITY_ALPHABET
			id: INTEGER
			loop_counter: INTEGER
			added: BOOLEAN
		do
--			contents.prune_all (et)
			loop_counter := 1
			from
				added := false
			until
				added = true
			loop
				if attached contents[loop_counter] as content then
					if attached {ENTITY_ALPHABET} content as entity then
						if entity.id = et.id then
							contents[loop_counter] := void
							added := true
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
					if attached contents [loop_counter] as temp_item  then
						Result := temp_item.is_wormhole
					end -- if
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
					if attached contents [loop_counter] as temp_item  then
						Result := temp_item.is_bh
					end -- if
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
					if attached contents [loop_counter] as temp_item  then
						Result := temp_item.is_yd
					end -- if
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
					if attached contents [loop_counter] as temp_item  then
						Result := temp_item.is_pl
					end -- if
					loop_counter := loop_counter + 1
				end
		end


end

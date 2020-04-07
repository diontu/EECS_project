note
	description: "Summary description for {MOVE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE

create
	make

feature  -- attributes
	-- game_state
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS

	-- entity_ids
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS

	-- direction
	direction: TUPLE[left_right_dir: INTEGER; up_down_dir: INTEGER]

feature -- constructor
	make
		do
			game_state := game_state_access.gs
			entity_ids := entity_ids_access.entity_ids
			create direction.default_create
		end

feature -- add direction
	add_direction (dir: TUPLE[INTEGER, INTEGER])
		do
			direction := dir
		end

feature -- execute
	execute
		local
			mu: MOVEMENT_UTILITY
			new_pos: TUPLE[row: INTEGER; col: INTEGER]

			-- explorer
			explorer: EXPLORER_ENT
			explorer_entity_alphabet: ENTITY_ALPHABET

			-- sector
			old_sector: SECTOR
			new_sector: SECTOR

			--quadrant
			quadrant: INTEGER
			found: BOOLEAN
			loop_counter: INTEGER
		do
			-- must attach game_state in whichever function it was used
			game_state := game_state_access.gs
			entity_ids := entity_ids_access.entity_ids

			-- set the explorer
			explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
			if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as exp then
				explorer := exp
			end

			if attached {EXPLORER_ENT} explorer as exp then
				-- check if in play or test mode -- error check
				if game_state.mode.is_equal ("none") then
					game_state.update_mini_state
					game_state.error_state
					game_state.states_msg_append ("%N")
					game_state.states_msg_append ("  ")
					game_state.states_msg_append ("Negative on that request:no mission in progress.")
					game_state.output_states
				else
					create mu.make
					new_pos := mu.transform (exp.position, direction)
					old_sector := game_state.galaxy.grid[exp.position.row, exp.position.col]
					new_sector := game_state.galaxy.grid[new_pos.row, new_pos.col]

					-- check if the explorer is currently landed -- error check
					if exp.is_landed then
						game_state.update_mini_state
						game_state.error_state
						game_state.states_msg_append ("%N")
						game_state.states_msg_append ("  ")
						game_state.states_msg_append ("Negative on that request:you are currently landed at Sector:")
						game_state.states_msg_append (exp.position.row.out)
						game_state.states_msg_append (":")
						game_state.states_msg_append (exp.position.col.out)
						game_state.output_states
					else
						-- check if the sector is full -- error check
						if new_sector.is_full then
							game_state.update_mini_state
							game_state.error_state
							game_state.states_msg_append ("%N")
							game_state.states_msg_append ("  ")
							game_state.states_msg_append ("Cannot transfer to new location as it is full.")
							game_state.output_states
						else
							-- remember to add to the movements_msg
							game_state.update_state
							game_state.ok_state
							game_state.an_entity_moved

							game_state.movements_msg_append ("%N")
							game_state.movements_msg_append ("    ")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (explorer_entity_alphabet.id.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (explorer_entity_alphabet.item.out)
							game_state.movements_msg_append ("]:")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (exp.position.row.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (exp.position.col.out)
							game_state.movements_msg_append (",")
							from
								quadrant := 1
								loop_counter := 1
								found := false
							until
								loop_counter > old_sector.contents.count or found
							loop
								if attached {ENTITY_ALPHABET} old_sector.contents[loop_counter] as ent_alpha then
									if ent_alpha.id = explorer_entity_alphabet.id then
										found := true
										quadrant := loop_counter
									end
								end
								loop_counter := loop_counter + 1
							end
							game_state.movements_msg_append (quadrant.out)
							game_state.movements_msg_append ("]")

							old_sector.delete (explorer_entity_alphabet)
							new_sector.put (explorer_entity_alphabet, new_pos)

							game_state.movements_msg_append ("->")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (exp.position.row.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (exp.position.col.out)
							game_state.movements_msg_append (",")
							from
								quadrant := 1
								loop_counter := 1
								found := false
							until
								loop_counter > new_sector.contents.count or found
							loop
								if attached {ENTITY_ALPHABET} new_sector.contents[loop_counter] as ent_alpha then
									if ent_alpha.id = explorer_entity_alphabet.id then
										found := true
										quadrant := loop_counter
									end
								end
								loop_counter := loop_counter + 1
							end
							game_state.movements_msg_append (quadrant.out)
							game_state.movements_msg_append ("]")
						end
					end
				end
			end
		end




end

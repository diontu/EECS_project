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
	-- model
	model: ETF_MODEL
	model_access: ETF_MODEL_ACCESS

	-- entity_ids
	entity_ids: ENTITY_IDS
	entity_ids_access: ENTITY_IDS_ACCESS

	-- direction
	direction: TUPLE[left_right_dir: INTEGER; up_down_dir: INTEGER]

feature -- constructor
	make
		do
			model := model_access.m
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
			-- must attach model in whichever function it was used
			model := model_access.m
			entity_ids := entity_ids_access.entity_ids

			-- set the explorer
			explorer_entity_alphabet := entity_ids.get_entity_alphabet (0)
			if attached {EXPLORER_ENT} explorer_entity_alphabet.entity as exp then
				explorer := exp
			end

			if attached {EXPLORER_ENT} explorer as exp then
				-- check if in play or test mode -- error check
				if model.mode.is_equal ("none") then
					model.update_mini_state
					model.error_state
					model.states_msg_append ("%N")
					model.states_msg_append ("  ")
					model.states_msg_append ("Negative on that request:no mission in progress.")
					model.output_states
				else
					create mu.make
					new_pos := mu.transform (exp.position, direction)
					old_sector := model.galaxy.grid[exp.position.row, exp.position.col]
					new_sector := model.galaxy.grid[new_pos.row, new_pos.col]

					-- check if the explorer is currently landed -- error check
					if exp.is_landed then
						model.update_mini_state
						model.error_state
						model.states_msg_append ("%N")
						model.states_msg_append ("  ")
						model.states_msg_append ("Negative on that request:you are currently landed at Sector:")
						model.states_msg_append (exp.position.row.out)
						model.states_msg_append (":")
						model.states_msg_append (exp.position.col.out)
					else
						-- check if the sector is full -- error check
						if new_sector.is_full then
							model.update_mini_state
							model.error_state
							model.states_msg_append ("%N")
							model.states_msg_append ("  ")
							model.states_msg_append ("Cannot transfer to new location as it is full.")
							model.output_states
						else
							-- remember to add to the movements_msg
							model.update_state
							model.ok_state
							model.an_entity_moved

							model.movements_msg_append ("%N")
							model.movements_msg_append ("    ")
							model.movements_msg_append ("[")
							model.movements_msg_append (explorer_entity_alphabet.id.out)
							model.movements_msg_append (",")
							model.movements_msg_append (explorer_entity_alphabet.item.out)
							model.movements_msg_append ("]:")
							model.movements_msg_append ("[")
							model.movements_msg_append (exp.position.row.out)
							model.movements_msg_append (",")
							model.movements_msg_append (exp.position.col.out)
							model.movements_msg_append (",")
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
									loop_counter := loop_counter + 1
								end
							end
							model.movements_msg_append (quadrant.out)
							model.movements_msg_append ("]")

							old_sector.delete (explorer_entity_alphabet)
							new_sector.put (explorer_entity_alphabet, new_pos)

							model.movements_msg_append ("->")
							model.movements_msg_append ("[")
							model.movements_msg_append (exp.position.row.out)
							model.movements_msg_append (",")
							model.movements_msg_append (exp.position.col.out)
							model.movements_msg_append (",")
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
									loop_counter := loop_counter + 1
								end
							end
							model.movements_msg_append (quadrant.out)
							model.movements_msg_append ("]")
						end
					end
				end
			end
		end


end

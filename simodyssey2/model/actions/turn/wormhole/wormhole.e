note
	description: "Summary description for {WORMHOLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WORMHOLE

create
	make

feature -- attributes
	game_state: GAME_STATE
	game_state_access: GAME_STATE_ACCESS

feature -- constructor
	make
		do
			game_state := game_state_access.gs
		end

feature -- execute --  should only allow the explorer, benign and malevolent use
	execute(entity_alphabet: ENTITY_ALPHABET)
	local
		explorer : EXPLORER_ENT
		benign : BENIGN_ENT
		malevolent : MALEVOLENT_ENT
		sector : SECTOR
		new_sector : SECTOR

		added: BOOLEAN
		temp_row : INTEGER
		temp_col : INTEGER
		random : RANDOM_GENERATOR_ACCESS

		do
			game_state := game_state_access.gs

			if game_state.mode.is_equal ("none") then
					game_state.update_mini_state
					game_state.error_state
					game_state.states_msg_append ("%N")
					game_state.states_msg_append ("  ")
					game_state.states_msg_append ("Negative on that request:no mission in progress.")
					game_state.output_states
			end

			if attached {EXPLORER_ENT} entity_alphabet.entity as exp then
				explorer := exp
				sector := game_state.galaxy.grid[explorer.position.row,explorer.position.col]

				if explorer.is_landed then
					game_state.update_mini_state
						game_state.error_state
						game_state.states_msg_append ("%N")
						game_state.states_msg_append ("  ")
						game_state.states_msg_append ("Negative on that request:you are currently landed at Sector:")
						game_state.states_msg_append (exp.position.row.out)
						game_state.states_msg_append (":")
						game_state.states_msg_append (exp.position.col.out)
						game_state.output_states

				elseif not sector.has_wormhole then
					game_state.update_mini_state
					game_state.error_state
					game_state.states_msg_append ("%N")
					game_state.states_msg_append ("  ")
					game_state.states_msg_append ("Explorer couldn't find wormhole at Sector:")
					game_state.states_msg_append (exp.position.row.out)
					game_state.states_msg_append (":")
					game_state.states_msg_append (exp.position.col.out)
					game_state.output_states
					else
					from
						added := false
					until
						added
					loop

						temp_row := random.rchoose (1, 5)
						temp_col := random.rchoose (1, 5)
						new_sector := game_state.galaxy.grid[temp_row,temp_col]
						if not new_sector.is_full then
							game_state.movements_msg_append ("%N")
							game_state.movements_msg_append ("    ")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (entity_alphabet.id.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (entity_alphabet.item.out)
							game_state.movements_msg_append ("]:")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (explorer.position.row.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (explorer.position.col.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (sector.return_quadrent_exp.out)
							game_state.movements_msg_append ("]")
							game_state.movements_msg_append ("->")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (temp_row.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (temp_col.out)
							game_state.movements_msg_append (",")
							explorer.add_pos (temp_row,temp_col)
							explorer.in_wormhole
							added := true
							sector.delete (entity_alphabet)
							new_sector.put (entity_alphabet,[temp_row,temp_col])
							game_state.movements_msg_append (new_sector.return_quadrent_exp.out)
							game_state.movements_msg_append ("]")

						end
						end
				end
			end

			if attached{BENIGN_ENT} entity_alphabet.entity as ben then
				benign := ben

				sector := game_state.galaxy.grid[benign.position.row,benign.position.col]

				if sector.has_wormhole then
					from
						added := false
					until
						added
					loop

						temp_row := random.rchoose (1, 5)
						temp_col := random.rchoose (1, 5)
						new_sector := game_state.galaxy.grid[temp_row,temp_col]
						if not new_sector.is_full then
							game_state.movements_msg_append ("%N")
							game_state.movements_msg_append ("    ")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (entity_alphabet.id.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (entity_alphabet.item.out)
							game_state.movements_msg_append ("]:")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (benign.position.row.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (benign.position.col.out)
							game_state.movements_msg_append (",")
							benign.add_pos (temp_row,temp_col)
							benign.in_wormhole
							added := true
							game_state.movements_msg_append (sector.return_quadrent_ben.out)
													game_state.movements_msg_append ("]")
													game_state.movements_msg_append ("->")
													game_state.movements_msg_append ("[")
													game_state.movements_msg_append (temp_row.out)
													game_state.movements_msg_append (",")
													game_state.movements_msg_append (temp_col.out)
													game_state.movements_msg_append (",")
							sector.delete (entity_alphabet)
							new_sector.put (entity_alphabet,[temp_row,temp_col])
							game_state.movements_msg_append (new_sector.return_quadrent_ben.out)
							game_state.movements_msg_append ("]")

						end
				end
				end
			end

			if attached {MALEVOLENT_ENT} entity_alphabet.entity as mal then
				malevolent := mal
				sector := game_state.galaxy.grid[malevolent.position.row, malevolent.position.col]

				if sector.has_wormhole then
				from
						added := false
					until
						added
					loop

						temp_row := random.rchoose (1, 5)
						temp_col := random.rchoose (1, 5)
						new_sector := game_state.galaxy.grid[temp_row,temp_col]
						if not new_sector.is_full then
							game_state.movements_msg_append ("%N")
							game_state.movements_msg_append ("    ")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (entity_alphabet.id.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (entity_alphabet.item.out)
							game_state.movements_msg_append ("]:")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (malevolent.position.row.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (malevolent.position.col.out)
							game_state.movements_msg_append (",")
							malevolent.in_wormhole
							added := true
							game_state.movements_msg_append (sector.return_quadrent_mal.out)
							game_state.movements_msg_append ("]")
							game_state.movements_msg_append ("->")
							game_state.movements_msg_append ("[")
							game_state.movements_msg_append (temp_row.out)
							game_state.movements_msg_append (",")
							game_state.movements_msg_append (temp_col.out)
							game_state.movements_msg_append (",")
							malevolent.add_pos (temp_row,temp_col)
							sector.delete (entity_alphabet)
							new_sector.put (entity_alphabet,[temp_row,temp_col])
							game_state.movements_msg_append (new_sector.return_quadrent_mal.out)
							game_state.movements_msg_append ("]")
						end
				end

			end
			end



		-- EXPLORER PART



		end

end

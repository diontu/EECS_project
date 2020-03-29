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
	model: ETF_MODEL
	model_access: ETF_MODEL_ACCESS

feature -- constructor
	make
		do
			model := model_access.m
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
			model := model_access.m

			if model.mode.is_equal ("none") then
					model.update_mini_state
					model.error_state
					model.states_msg_append ("%N")
					model.states_msg_append ("  ")
					model.states_msg_append ("Negative on that request:no mission in progress.")
					model.output_states
			end

			if attached {EXPLORER_ENT} entity_alphabet.entity as exp then
				explorer := exp
				sector := model.galaxy.grid[explorer.position.row,explorer.position.col]

				if explorer.is_landed then
					model.update_mini_state
						model.error_state
						model.states_msg_append ("%N")
						model.states_msg_append ("  ")
						model.states_msg_append ("Negative on that request:you are currently landed at Sector:")
						model.states_msg_append (exp.position.row.out)
						model.states_msg_append (":")
						model.states_msg_append (exp.position.col.out)
						model.output_states

				elseif not sector.has_wormhole then
					model.update_mini_state
					model.error_state
					model.states_msg_append ("%N")
					model.states_msg_append ("  ")
					model.states_msg_append ("Explorer couldn't find wormhole at Sector:")
					model.states_msg_append (exp.position.row.out)
					model.states_msg_append (":")
					model.states_msg_append (exp.position.col.out)
					model.output_states
					else
					from
						added := false
					until
						added
					loop

						temp_row := random.rchoose (1, 5)
						temp_col := random.rchoose (1, 5)
						new_sector := model.galaxy.grid[temp_row,temp_col]
						if not new_sector.is_full then
							model.movements_msg_append ("%N")
							model.movements_msg_append ("    ")
							model.movements_msg_append ("[")
							model.movements_msg_append (entity_alphabet.id.out)
							model.movements_msg_append (",")
							model.movements_msg_append (entity_alphabet.item.out)
							model.movements_msg_append ("]:")
							model.movements_msg_append ("[")
							model.movements_msg_append (explorer.position.row.out)
							model.movements_msg_append (",")
							model.movements_msg_append (explorer.position.col.out)
							model.movements_msg_append (",")
							model.movements_msg_append (sector.return_quadrent_exp.out)
							model.movements_msg_append ("]")
							model.movements_msg_append ("->")
							model.movements_msg_append ("[")
							model.movements_msg_append (temp_row.out)
							model.movements_msg_append (",")
							model.movements_msg_append (temp_col.out)
							model.movements_msg_append (",")
							explorer.add_pos (temp_row,temp_col)
							explorer.in_wormhole
							added := true
							sector.delete (entity_alphabet)
							new_sector.put (entity_alphabet,[temp_row,temp_col])
							model.movements_msg_append (new_sector.return_quadrent_exp.out)
							model.movements_msg_append ("]")

						end
						end
				end
			end

			if attached{BENIGN_ENT} entity_alphabet.entity as ben then
				benign := ben

				sector := model.galaxy.grid[benign.position.row,benign.position.col]

				if sector.has_wormhole then
					from
						added := false
					until
						added
					loop

						temp_row := random.rchoose (1, 5)
						temp_col := random.rchoose (1, 5)
						new_sector := model.galaxy.grid[temp_row,temp_col]
						if not new_sector.is_full then
							model.movements_msg_append ("%N")
							model.movements_msg_append ("    ")
							model.movements_msg_append ("[")
							model.movements_msg_append (entity_alphabet.id.out)
							model.movements_msg_append (",")
							model.movements_msg_append (entity_alphabet.item.out)
							model.movements_msg_append ("]:")
							model.movements_msg_append ("[")
							model.movements_msg_append (benign.position.row.out)
							model.movements_msg_append (",")
							model.movements_msg_append (benign.position.col.out)
							model.movements_msg_append (",")
							benign.add_pos (temp_row,temp_col)
							benign.in_wormhole
							added := true
							model.movements_msg_append (sector.return_quadrent_ben.out)
													model.movements_msg_append ("]")
													model.movements_msg_append ("->")
													model.movements_msg_append ("[")
													model.movements_msg_append (temp_row.out)
													model.movements_msg_append (",")
													model.movements_msg_append (temp_col.out)
													model.movements_msg_append (",")
							sector.delete (entity_alphabet)
							new_sector.put (entity_alphabet,[temp_row,temp_col])
							model.movements_msg_append (new_sector.return_quadrent_ben.out)
							model.movements_msg_append ("]")

						end
				end
				end
			end

			if attached {MALEVOLENT_ENT} entity_alphabet.entity as mal then
				malevolent := mal
				sector := model.galaxy.grid[malevolent.position.row, malevolent.position.col]

				if sector.has_wormhole then
				from
						added := false
					until
						added
					loop

						temp_row := random.rchoose (1, 5)
						temp_col := random.rchoose (1, 5)
						new_sector := model.galaxy.grid[temp_row,temp_col]
						if not new_sector.is_full then
							model.movements_msg_append ("%N")
							model.movements_msg_append ("    ")
							model.movements_msg_append ("[")
							model.movements_msg_append (entity_alphabet.id.out)
							model.movements_msg_append (",")
							model.movements_msg_append (entity_alphabet.item.out)
							model.movements_msg_append ("]:")
							model.movements_msg_append ("[")
							model.movements_msg_append (malevolent.position.row.out)
							model.movements_msg_append (",")
							model.movements_msg_append (malevolent.position.col.out)
							model.movements_msg_append (",")
							malevolent.in_wormhole
							added := true
							model.movements_msg_append (sector.return_quadrent_mal.out)
							model.movements_msg_append ("]")
							model.movements_msg_append ("->")
							model.movements_msg_append ("[")
							model.movements_msg_append (temp_row.out)
							model.movements_msg_append (",")
							model.movements_msg_append (temp_col.out)
							model.movements_msg_append (",")
							malevolent.add_pos (temp_row,temp_col)
							sector.delete (entity_alphabet)
							new_sector.put (entity_alphabet,[temp_row,temp_col])
							model.movements_msg_append (new_sector.return_quadrent_mal.out)
							model.movements_msg_append ("]")
						end
				end

			end
			end



		-- EXPLORER PART



		end

end

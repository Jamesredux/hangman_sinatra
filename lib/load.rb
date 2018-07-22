	#this is the save management class dealing with loading saved games and deleting them also.


	class Saves
		def initialize
			@save_names = []
			@save_id = 1
		end

	def list_saves
		puts "List of Saved Games:"
			Dir.glob("./saves/*").each do |file|
				@save_names<<file 
				file = file[8..-6]
					puts "Save Number #{@save_id} #{file}"
					@save_id += 1
			end
			
		if @save_id == 1
		puts "*****************"
		puts "There are no saved games. Hit the 'N' key to start a new game."
		puts "*****************"

		end	
				
	end

	def get_load_choice
		puts "Please choose which game you would like to load (number), or type \"N\" for a new game or \"D\" to delete all your saved games:"
		
		choice = gets.chomp
		
		if choice.downcase == "n"  
			player1 = Game.new
			player1.play_game
		elsif choice.downcase == "d"	
			delete_saves	
		elsif choice.to_i.between?(1, @save_id-1)	
			load_game(@save_names, choice)	
		else
			puts "Sorry, I didn't understand that:"
			choice = get_load_choice
		end				

	end


	def load_game(save_names, game_choice) 
		puts "Loading save number #{game_choice} please wait:\n"
		game_choice = game_choice.to_i
					
		file_index = game_choice - 1
		file_name = find_file(save_names, file_index)

		puts "Welcome Back\n\n" 
			
			loaded_game = YAML::load(File.open(file_name))
		
		puts "You have had #{loaded_game.guess_count} guesses"
		puts loaded_game.progress.join
		
		loaded_game.play_game

	end

	def find_file(save_names, file_index)
		save_names.each_with_index do |value, index|
			if index == file_index
				return value
			end
		end
		
	end

	def delete_saves
		puts "Are you sure you want to delete all files, this can not be undone: Confirm 'Y' to delete \n or any other key to continue: "
			confirm_choice = gets.downcase.chomp
				if confirm_choice == "y"
					Dir.glob("./saves/*").each do |file|
					File.delete(file)
					end
				else
					choice = get_load_choice
				end
			puts ""
	end		

end	
#problem game class from get does not seem to be carrying over
#to the post method. @pastletters etc

require 'sinatra'
require "sinatra/reloader" if development?
require "erb"

require "./lib/game.rb"
require "./lib/load.rb"

get '/' do 
	new_player = Game.new
	@progess = new_player.progress.join
	erb :layout
end	

post '/guess' do 
	@guess = params["guess"]
	@past_letters = []
	checker = Validator.new(@guess, @past_letters)
	if checker.valid?
		#check and print
		erb :index
	else
		@message = checker.message
		erb :layout
	end		
end	



class Validator

	def initialize(guess, past_letters)
		@guess = guess.downcase
		@past_letters = past_letters
		
	end

	def valid?
		validate
		@message.nil?
	end

	def message
		@message
	end

	def validate
		if @guess.empty?
			@message = "Please put a guess in the field"
		elsif valid_input?(@guess) == false
			@message = "I did not understand that choice, please try again."
		elsif already_tried?(@guess) == true			
			@message = "You have already picked that letter"
		end			
		
	end

	def valid_input?(guess)
		guess ===  /^[a-z]{1}$/  #not working		
	end

	def already_tried?(guess)
		@past_letters.include? guess	
	end


end	

class Hangman
	def initialize
		
		run_game
	end
	
	def run_game
		puts "Welcome to Hangman, please select 'N' for a new game or 'L' to load a previously saved game:"
		user_choice = gets.chomp.downcase
		if 
			user_choice == 'n'
			player1 = Game.new
			player1.play_game
		elsif 
			user_choice == 'l'
			player1 = Saves.new
			player1.list_saves
			player1.get_load_choice
		else
		 puts "I did not understand that choice, please input 'N' or 'L'"
		 run_game
		end 
	end



	
end

#trevor = Hangman.new

#it's new_game that has to be saved, not trevor
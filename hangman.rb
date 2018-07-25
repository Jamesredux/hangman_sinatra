#this is where the game will be run from
#game workings are in main.rb

require 'sinatra'
require "sinatra/reloader" if development?

require "./lib/game.rb"
require "./lib/load.rb"

get '/' do 
	erb :layout
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
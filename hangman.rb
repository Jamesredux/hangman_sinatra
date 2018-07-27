
require 'sinatra'
require "sinatra/reloader" if development?
require "erb"

enable :sessions

get '/' do 
	session[:game] = Game.new
	session[:progess] = session[:game].progress
	session[:answer] = session[:game].word
	session[:guess_count] = session[:game].guess_count
	@progess = session[:progess]
	@secret_word = session[:answer]
	@guess_count = session[:guess_count]
	erb :layout
end	

post '/guess' do 
	@guess = params["guess"]
	@past_letters = session[:game].past_letters
	checker = Validator.new(@guess, @past_letters)
	if checker.valid?
		session[:game].past_letters<<@guess
		session[:game].check_guess(session[:game].word_array, @guess)
		if session[:game].solved?
			redirect "/win"
		else
			if session[:game].time_up?
				redirect "./gameover"
			else		
				redirect "/guess"
			end		
		end
	else
		session[:guess_count] = session[:game].guess_count
		#@guess_count = session[:guess_count]

		@message = checker.message
		erb :layout
	end		
end	

get '/guess' do 
	session[:guess_count] = session[:game].guess_count
	#@guess_count = session[:guess_count]
	session[:progess] = session[:game].progress
	session[:answer] = session[:game].word
	@progess = session[:progess]
	@secret_word = session[:answer]
	erb :layout


end	


get '/win' do 
	session[:guess_count] = session[:game].guess_count
	#@guess_count = session[:guess_count]

	@message = "Congratulations you guessed the word - #{session[:answer]}"
	erb :layout
end	

get '/gameover' do 
	session[:guess_count] = session[:game].guess_count
	#@guess_count = session[:guess_count]
	@message = "You lose, the word was #{session[:answer]}"
	erb :layout

end

helpers do 


	class Game

	attr_accessor :progress, :guess_count, :past_letters, :word, :word_array

		def initialize
			@word = get_word 
			@word_array = @word.chars
			@guess_count = 4
			@progress = Array.new(@word_array.size) {"-"}
			@past_letters = []
			@game_over = false			
		end

		
		def get_word
			words = File.readlines("./data/dict3000.txt")   #there are 2 dics the one suggested has a lot of wierd words so i just used the 3000 most common english words
			word = words.select { |w| w.size > 4 && w.size <  13 }.sample
			word = word.downcase.chomp
		end	

		def check_guess(word_array, guess='$')
			@correct_guess = false
			x = 0
			word_array.each do |l|
				if guess.include? l
						@progress[x] = l
						x += 1				
						@correct_guess = true
				else
					x += 1
				end
			end

			@guess_count += 1 if @correct_guess == false

		end

		def solved?
			if @progress.include? "-"
				false
			else
				true
			end		

		end

		def time_up?
			if @guess_count > 9
				true
			end			
		end	



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
		elsif invalid_input?(@guess) == true
			@message = "I did not understand that choice, please try again."
		elsif already_tried?(@guess) == true			
			@message = "You have already picked that letter"
		end			
		
	end

	def invalid_input?(guess)
		(guess.match  /^[a-z]{1}$/).nil?		
	end

	def already_tried?(guess)
		@past_letters.include? guess	
	end


end	




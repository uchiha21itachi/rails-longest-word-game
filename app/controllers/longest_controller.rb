class LongestController < ApplicationController
  def game
    @grid = create_grid()
  end

  def score
    @attempt = params[:attempt]
    @grid = params[:grid]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @valid = attempt_check(@attempt,@grid)
    @time_taken = @end_time-@start_time
    @score = compute_score(@attempt,@time_taken)
    @result = {
      attempt: @attempt,
      time: @time_taken,
      score: @score
    }


  end

  def create_grid()
    random_letters = []
    for i in (1..9)
      random_letters << rand(97..122).chr
    end
    return random_letters
  end

  def attempt_check(attempt, grid)

    attempt_array = attempt.split("")
    ans = []
    for i in (1..attempt_array.size) do
      ans << grid.include?(attempt_array[i-1])
    end
    if ans.include?(false)
      ans = "false"
    else
      ans = "true"
    end

    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    dictionary = open(url).read
    dict = JSON.parse(dictionary)
    answer = dict["found"].to_s
    if answer=="true" && ans=="true"
      return true
    else
      return false
    end
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end



end



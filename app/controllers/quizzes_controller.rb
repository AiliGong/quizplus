class QuizzesController < ApplicationController
  def index 
  end

  def start_quiz
    limit = params[:number]
    category = params[:filter] ? params[:filter][:category] : nil
    difficulty = params[:filter] ? params[:filter][:diffculty] : nil
    
    response = getQuestions(limit, category, difficulty)
    questions = response.map{|h| Question.find_by_id_or_create(h['id'], h)}
    session[:questions] = questions.map{|q| q.id }
    session[:question_index] = 0;
    session.delete(:answers);

    redirect_to :action => "show_question"
  end

  def show_question
    @question = Question.find(session[:questions][session[:question_index]])
  end

  def submit_answer
    chosed_answers = params[:chosed_answers]
    if (!chosed_answers)
      flash[:notice] = "Plese choose your answer before moving on."
      redirect_to :action => "show_question"
      return
    end

    session[:question_index] += 1;
    index = session[:question_index];
    question_id = params[:question][:id];
    session[:answers] ||= Hash.new;
    session[:answers][question_id] = chosed_answers;

    if index == session[:questions].count 
      check_answers() # check all answers and show result
      redirect_to :action => "show_result"
    else
      redirect_to :action => "show_question"
    end
  end

  def reload
    if params[:restart] == 1

    else
    # redo
    session[:question_index] = 0;
    session.delete(:answers);
    redirect_to :action => "show_question"

    end
    
  end

  def show_result
  end

  private
  def request_api(url, limit)
    response = Excon.get(url)
   if response.status == 200
      return JSON.parse(response.body)
   else
    return read_from_local(limit)
   end
  end

  def getQuestions(limit, category, difficulty)
    category_q = category ? category[0] : nil
    difficulty_q = URI.encode("#{difficulty}");
    key = "lw4x9Tf7Qzt5qKUWWUlPb6WmD0O1SnYS9K4EmKEa"
    request_api(
    "https://quizapi.io/api/v1/questions?apiKey=#{key}&limit=#{limit}&difficulty=#{difficulty_q}&category=#{category_q}", limit)
  end

  def check_answers
    session[:answers]
    total_question_number = session[:questions].count
    correct_number = 0
    session[:answers].each do |key, value|
      Question.find(key).check_answers(value) && correct_number += 1
    end
    session[:results] ||= []
    session[:results].count == 5 && session[:results].shift
    session[:results].push([Time.now.strftime("%I:%M%p, %m/%d/%Y"), correct_number, total_question_number])
  end

  def read_from_local(limit)
    data = File.read("quiz.json")
    questions = JSON.parse(data).shuffle!.first(limit.to_i)
  end

end

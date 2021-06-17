Rails.application.routes.draw do

  root 'home#index'

  get 'quizzes', to: 'quizzes#index'
  post 'start_quiz', to: 'quizzes#start_quiz'
  get 'show_question', to: 'quizzes#show_question'
  post 'submit_answer', to: 'quizzes#submit_answer'
  get 'show_result', to: 'quizzes#show_result'
  get 'reload', to: 'quizzes#reload'
end

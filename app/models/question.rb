class Question < ApplicationRecord

    def check_answers(values)
      return_value = true;
      values && values.each do |a|
        if correct_answers[a+'_correct'] == "false"
          return_value = false;
        end 
      end
      if return_value
        return_value = (values.count == answer_number);
      end
      return return_value;
    end
  
    def multiple_answers?
        return answer_number > 1 
    end
  
    def self.find_by_id_or_create(id, data)
      obj = self.find_by_id(id)
      obj || self.create(data)
    end
  
    private
    def answer_number
      count = 0;
      correct_answers.each do |key, value|
        value == "true" && count += 1;
      end
      return count;
    end
end

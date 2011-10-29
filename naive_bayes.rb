
 ms = %w(a perfect world my perfect woman pretty woman)
 ss = %w(a perfect day electric storm another rainy day)

 K = 1.0
 KX = (ms + ss).uniq.size.to_f
 
         
 p_m = 0.5
 p_s = 0.5


 def p_word(word, given_list)
   (given_list.count(word).to_f + K) / (given_list.size.to_f + KX)
 end

 def p_words(words, given_list)
   words.inject(1.0) do |product, word|
     product * p_word(word, given_list)
   end
 end
 


 def p_list (list, negative_list,  given_words)
   p_words(given_words, list) * 0.5 / (p_words(given_words, list) * 0.5 + p_words(given_words, negative_list) * 0.5)
 end

 p_list(ms, ss, %w(perfect storm))

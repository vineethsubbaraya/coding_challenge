module AppHelper

  def get_exclude_words(text)
    text_arr = text.downcase.split
    text_arr = text_arr.uniq
    arr_len = text_arr.length
    exclude = []

    if arr_len >1
      rand_no = rand(1..arr_len)
      exclude = text_arr.sample(rand_no)
    end
    
    return exclude

  end

  def get_frequencies(text, exclude_arr)
    text_arr = text.downcase.split
    exclude_arr.map!(&:downcase)
    #text_arr.reject! {|item| exclude_arr.include?(item)}
    freq = Hash.new(0)
    for word in text_arr
      if !exclude_arr.include?(word)
        freq[word] += 1
      end
    end
    return freq
  end

  def check_frequencies(original, requested)
    requested = Hash[requested.map{ |key,val| [key.downcase, val]}]
    return original == requested
  end

  def check_prev_msg(text, exclude, client)
    if client.nil?
      return false
    else
      text = text.downcase
      exclude = exclude.join(",").downcase
      return client.text == text && client.exclude == exclude
    end
  end
end

class Bot < ActiveRecord::Base

  def self.search_words words
      CLIENT.search(words, lang: "en").first.text
  end


  # def self.loop words
  #   CLIENT.search(words, lang: "en").take(5).each { |t|
  #     # byebug
  #     tweets.push t.text
  #   } 
  #   return tweets
  # end

  # code to find insomniac tweets and respond to them
  def self.find_user number, words

    # find tweets
    CLIENT.search(words, lang: "en").take(number).each { |t|
      # record twitter user and tweet num.
      
      User.create(name: t.user.screen_name, tweet_id: t.id.to_s)

      # send flity message
      CLIENT.update(Bot.respond(t.user.screen_name), in_reply_to_status_id: t.id)
    }

  end

  def self.respond name
    "@" + name + " " + Response.order_by_rand.first.message
  end 
end

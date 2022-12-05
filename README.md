
# TicTacToe
Hello! :) I would like to explain and highlight my thought processes by following all the requirements you sent me.


## Invalid Entries and Interactive Messages

For **Invalid Entries**, I decided to make a method to deal with them. I planned to be used it in as many cases as possible.

```ruby
  def insert(valid, message = "")
    puts message unless message.empty?
    validated_message = gets.chomp
    raise unless valid.include?(validated_message)
    validated_message
  rescue
    puts 'Select a valid option!'
    retry
  end
```

About the parameters, **valid** expects an Array containing accepted entries. Any non accepted entry will raise an error, show a message, and restart the process. **Message** It's just If you want an entry followed by a message. 


For **Interactive Messages**, I implemented them according to the game types and always tried to make everything clear for the user.


## New Features

I impletmented two difficulties: easy and medium. To make this happens, I created a simple RNG system. Depending of difficulty, the CPU has a porcentage of chance to hit the best move.
```ruby
  def best_move_difficulty
    #Gets the percentage depending of the difficulty
    number = {'easy' => 60, 'medium' => 80, 'hard' => 100}[@config[:difficulty]]
    
    #Randomly decide if the cpu will make the best move
    case Random.rand(100)
    when 0...number then true
    when number...100 then false
    end
  end
```

About the game type, It can be chosen at the beginning of the game, in the configuration section.
## Closing Comments

On this test, I tried to follow all the criteria and show you guys a little bit of my knowledge in engineering and algorithm as well. I hope my test is worth your time spent on it. Thank you for the opportunity! :)

# Self-Check Questions

## Question 1
What is the goal of running bundle install?

- **[CORRECT]** To fetch the versions of gems specified in the Gemfile, update the old dependencies in the Gemfile.lock if the versions don't match, and store the Gemfile's new gems as dependencies in the Gemfile.lock
  - bundle install looks at the gems contained in the Gemfile, fetches them, installs the version specified in the Gemfile, and stores the dependencies in the Gemfile.lock. If a Gemfile.lock already exists, the updated gems in the Gemfile will be updated in the Gemfile.lock. Anything that's not specified in the Gemfile will default to the dependencies specified in the Gemfile.lock.
- **[INCORRECT]** To clear the Gemfile.lock of all dependencies, fetch the versions of gems specified in the Gemfile, and store them as new dependencies in the Gemfile.lock
  - bundle install keeps all of its old dependencies, even if those gems were deleted from the Gemfile. For example, if a gem called "Navbar" is installed as a dependency in the Gemfile.lock, it will stay there after bundle install calls even if "Navbar" was deleted in the Gemfile.

---

## Question 2
Why is it good practice to specify --without production when running bundle install on your development computer?

- **[INCORRECT]** To ensure that we install gems on our local computer rather than setting up a web server for production whose Gemfile.lock contains all dependencies specified in our Gemfile
  - bundle install does not set up web servers.
- **[CORRECT]** To omit gems that we only need during production from being downloaded as dependencies in the Gemfile.lock so that our only dependencies are the ones we will use during development
  - It's good practice to specify --without production while running on a development computer because in our Gemfile we can specify a group of gems that should only be downloaded for production versions of our project. Using --without production allows us to skip over downloading the gems we will only use for production, which means we can save time, space, and mental clutter during development.

---

## Question 3
What file in the Rails app directory structure is the code corresponding to the WordGuesserGame model?

- **[INCORRECT]** app/controllers/application_controller.rb
  - In Rails, it's the controller's job to route the client's requests to internal actions that control views and the model.
- **[INCORRECT]** app/controllers/game_controller.rb
  - In Rails, it's the controller's job to route the client's requests to internal actions that control views and the model. game_controller.rb contains the class GameController that contains the logic that allows users to create and manage sessions of the WordGuesser game.
- **[INCORRECT]** app/helpers/application_helper.rb
  - In Rails, helpers are meant to store code that will be reused multiple times across files. This way, you could edit a helper rather than editing multiple methods in multiple different files. ApplicationHelper is meant to store helpers that will be reused across your entire project, but it's better practice to create helper files specific to certain tasks (i.e. user_helper.rb).
- **[CORRECT]** app/models/word_guesser_game.rb
  - The methods initialize, guess, word_with_guesses, check_win_or_lose, and get_random_word control the letter internal guessing logic of WordGuesserGame instances.

---

## Question 4
In what file is the code that most closely corresponds to the logic in the Sinatra apps' app.rb file that handles incoming user actions?

- **[INCORRECT]** app/controllers/application_controller.rb
  - In Rails, it's the controller's job to route the client's requests to internal actions that control views and the model.
- **[CORRECT]** app/controllers/game_controller.rb
  - Notice that this uses get_game_from_session and store_game_in_session to save a user's session between requests. It also has methods to control the new, create, show, guess, win, and lose public endpoints.
- **[INCORRECT]** app/helpers/application_helper.rb
  - In Rails, helpers are meant to store code that will be reused multiple times across files. This way, you could edit a helper rather than editing multiple methods in multiple different files. ApplicationHelper is meant to store helpers that will be reused across your entire project, but it's better practice to create helper files specific to certain tasks (i.e. user_helper.rb).
- **[INCORRECT]** app/models/word_guesser_game.rb
  - In Rails, models represent the database and its actions.

---

## Question 5
What class contains that code (the code in Question 4)?

- **[INCORRECT]** ActionController::Base
  - ActionController::Base is meant to be the default class for ActionControllers to inherit from and edit.
- **[INCORRECT]** ApplicationController
  - ApplicationController contains the code that protects from a CSRF attack.
- **[CORRECT]** GameController
  - app/controllers/game_controller.rb contains the GameController class.

---

## Question 6
From what other class (which is part of the Rails framework) does that class inherit?

- **[INCORRECT]** ActionController::Base
  - ActionController::Base is meant to be the default class for ActionControllers to inherit from and edit.
- **[CORRECT]** ApplicationController
  - In Ruby, < in a class definition means "inherits from." So when we see class GameController < ApplicationController in application_controller.rb, it means that the GameController class inherits from the ApplicationController class.
- **[INCORRECT]** GameController
  - GameController doesn't inherit from itself.

---

## Question 7
In what directory is the code corresponding to the Sinatra app's views (new.erb, show.erb, etc.)?

- **[INCORRECT]** app/assets
  - app/assets contains the files that control the style of the project. It contains the images, javascripts, and stylesheets subdirectories.
- **[CORRECT]** app/views
  - app/views/game contains the Rails equivalents of lose, new, show, and win. The Rails equivalent of layout is in app/views/layout. Overall we could say the directory that contains all files in Sinatra Wordguesser's view directory is app/views (although the Rails case is broken up into subdirectories).
- **[INCORRECT]** app/controllers
  - In Rails, it's the controller's job to route the client's requests to internal actions that control views and the model.
- **[INCORRECT]** app/helpers
  - In Rails, helpers are meant to store code that will be reused multiple times across files. This way, you could edit a helper rather than editing multiple methods in multiple different files.
- **[INCORRECT]** app/models
  - In Rails, models represent the database and its actions.

---

## Question 8
The filename suffixes for these views are different in Rails than they were in the Sinatra app. What information does the rightmost suffix of the filename (e.g.: in foobar.abc.xyz, the suffix .xyz) tell you about the file contents?

- **[CORRECT]** The file contains Embedded Ruby
  - The differences between the mentioned files in the Rails app in comparison to the Sinatra app are that the files in the Rails app end with ".html.erb" while the files in the Sinatra app only end with ".erb". The ".erb" at the end means the file contains "Embedded Ruby." This is useful in the HTML case because Rails will use the Embedded Ruby to dynamically update the file's data then generate an HTML page.
- **[INCORRECT]** The file contains HTML
  - Although the first suffix is .html, the secondmost (rightmost) suffix is .erb (which stands for "Embedded Ruby").

---

## Question 9
What information does the other suffix tell you about what Rails is being asked to do with the file?

- **[CORRECT]** Use the code in the file to output a HTML file
  - From a super high level, the ".html" suffix in the files that contain ".html.erb" means that Rails is being asked to structure a web page and its content. More specifically, the ".html" tells Ruby to output a page of pure HTML to be rendered.
- **[INCORRECT]** Use the code in the file to output a Ruby file
  - The first suffix is .html which means "HyperText Markup Language."

---

## Question 10
In what file is the information in the Rails app that maps routes (e.g. GET /new) to controller actions?

- **[INCORRECT]** app/controllers/application_controller.rb
  - application_controller.rb contains the class ApplicationController that the GameController class in game_controller.rb inherits from.
- **[INCORRECT]** app/controllers/game_controller.rb
  - In Rails, it's the controller's job to route the client's requests to internal actions that control views and the model. game_controller.rb contains the class GameController that contains the logic that allows users to create and manage sessions of the WordGuesser game.
- **[INCORRECT]** config/application.rb
  - In Rails, config files are meant to specify the settings you want all of your components to have on initialization.
- **[CORRECT]** config/routes.rb
  - Notice that get 'new', post 'create', get 'show', post 'guess', get 'win', and get 'lose' define HTTP requests for the public endpoints in quotes.
- **[INCORRECT]** config/secrets.yml
  - secrets.yml stores the secret_key_base, access tokens, external API keys, configuration options, etc. These are used to verify the integrity of actions during the request-response dynamic and more.

---

## Question 11
What is the role of the :as => 'name' option in the route declarations of config/routes.rb? (Hint: look at the views.)

- **[CORRECT]** To form a named route so you could reference the generated path in the views
  - For example post 'create' => 'game#create', :as => 'create_game' in routes.rb generates the path create_game_path that could then be referenced in the views (i.e. <%= form_tag create_game_path, :method => :post do %> in app/views/game/new.html.erb).
- **[INCORRECT]** To assign a variable named as to the string name
  - The :key => "value" notation format specifies means we are creating a symbol.

---

## Question 12
In the Sinatra version, before do...end and after do...end blocks are used for session management. What is the closest equivalent in this Rails app, and in what file do we find the code that does it?

- **[CORRECT]** before_action and after_action from app/controllers/game_controller.rb
  - The closest equivalent in the Rails app is before_action and after_action (or :get_game_from_session and :store_game_in_session). Session management is specifically managed using Rails sessions. We find the code that does it in app/controllers/game_controller.rb.
- **[INCORRECT]** initialize and check_win_or_lose from app/models/word_guesser_game.rb
  - initialize and check_win_or_lose are meant to initialize a word guessing game with a new word and check if the player has correctly guessed a word or failed to do so respectively.

---

## Question 13
In the Sinatra version, each controller action ends with either redirect (which as you can see becomes redirect_to in Rails) to redirect the player to another action, or erb to render a view. Why are there no explicit calls corresponding to erb in the Rails version? (Hint: Based on the code in the app, can you discern the Convention-over-Configuration rule that is at work here?)

- **[CORRECT]** Convention-over-Configuration
  - There are no explicit calls corresponding to erb in the Rails version. Under Convention-over-Configuration, the developer only needs to specify unconventional aspects of the application. Since the erbs in the Sinatra app are named the same as the functions they are called in, in the Rails version we wouldn't have to explicitly make the erb calls. These calls are implicitly made (see the "unless" checks for an example).
- **[INCORRECT]** Configuration-over-Convention
  - Rails uses Convention-over-Configuration to simplify the code-writing parts of development.

---

## Question 14
In the Sinatra version, we directly coded an HTML form using the <form> tag, whereas in the Rails version we are using a Rails method form_tag, even though it would be perfectly legal to use raw HTML <form> tags in Rails. Can you think of a reason Rails might introduce this "level of indirection"?

- **[CORRECT]** So we can perform repetitive tasks without having to rewrite the same boilerplate code
  - The Rails method form_tag is useful because it generates a form, renders the HTML, and generates an Authenticity Token, all of which we would've had to do manually without it. This level of indirection heavily streamlines the process of making apps and follows the concept of using Embedded Ruby to generate HTML that we discussed earlier.
- **[INCORRECT]** To make Rails apps harder to understand
  - Convention-over-Configuration is confusing at first, but makes it far easier to be productive when writing code and reading others' in the long term.

---

## Question 15
How are form elements such as text fields and buttons handled in Rails? (Again, raw HTML would be legal, but what's the motivation behind the way Rails does it?)

- **[CORRECT]** Using similar built-in helpers such as form_tag for Convention-over-Configuration
  - Form elements also can be generated and implemented into the pipeline using the built-in helpers in Rails. The motivation is to comply with the Convention-over-Configuration ideology where developers need to make less decisions while coding.
- **[INCORRECT]** Using similar built-in helpers such as form_tag for Configuration-over-Convention
  - Remember that Ruby on Rails follows the Convention-over-Configuration principle.

---

## Question 16
In the Sinatra version, the show, win, and lose views re-use the code in the new view that offers a button for starting a new game. Which of the following Rails mechanisms allow those views to be re-used in the Rails version?

- **[INCORRECT]** <% render :template => 'game/new' %>
  - <% %> executes the Ruby code inside of the brackets without printing.
- **[CORRECT]** <%= render :template => 'game/new' %>
  - <%= %> prints to the erb file.
- **[INCORRECT]** <%== render :template => 'game/new' %>
  - <%== %> prints something verbatim (i.e. w/o escaping) into erb file.

---

## Question 17
What is a qualitative explanation for why the Cucumber scenarios and step definitions didn't need to be modified at all to work equally well with the Sinatra or Rails versions of the app? Note that the Sinatra and Rails apps appear the same to a user.

- **[CORRECT]** Cucumber scenarios test only what users can see, so if functionality persists across versions we don't need to update tests
  - The Cucumber scenarios and step definitions didn't need to be modified at all to work equally well with the Sinatra or Rails versions of the app because they can only do what the user can do. Since Sinatra and Rails are back end, if they are set up in a way where the functionality is the same for a human user of the webpage, the scenarios and definitions should not be affected. TLDR: Since the Cucumber scenarios and step definitions look at the front-end, changes to the back-end that preserve front-end functionality will not require modifications.
- **[INCORRECT]** Sinatra and Rails compile down to the same code, so both versions will be interpreted by Cucumber in exactly the same way
  - There is no guarantee that Sinatra and Rails compile to the same code. Think about what Cucumber has access to see.

# CHIPS 5.3: RottenPotatoes — Filtering, Sorting, and Deploying

## Part 0 (A): Preparation — get RottenPotatoes running locally

### GitHub setup

As in previous CHIPS, you will need to authenticate git with GitHub to clone the repository for this assignment. The clone URL below will require that you use public key authentication. Fork this repo:

https://github.com/saasbook/hw-rails-intro

```sh
git clone <insert SSH URL here> rottenpotatoes-rails-intro
cd rottenpotatoes-rails-intro
```

It's a good habit to get into the practice of making a branch for changes you want to make, so you can later create a pull request before merging into main (which gives you the power to document your sets of commits thoroughly).

A good name for this branch would be something like `add-filtering`, which is descriptive of the feature you'll be adding in the next part of this assignment. You're also welcome to continue to choose a pair programming partner in your team for this CHIPS, in which case you should pick a repository to use between the two of you and add the other member as a collaborator to the repository. If you work in a pair, you should add both team members' GitHub usernames to the branch name so we can more easily see who worked with whom.

```sh
git checkout -b <BRANCH_NAME>
git push -u origin <BRANCH_NAME>
```

You will now have a local branch to make edits that is connected to an identically named remote branch on the GitHub repo to which you should push frequently using the following commands:

```sh
git status # review your changes
git add [...] # you will need to include your own files!
git commit -m "your message here"
git push origin
```

Whenever you start working on a Rails project, the first thing you should do is to run Bundler, to make sure all the app's gems are installed. Switch to the app's root directory (presumably `rottenpotatoes-rails-intro`) and run `bundle config set without 'production'` (you only need to specify `without 'production'` the first time, as this setting will be remembered on future runs of Bundler for this project).

Finally, run the initial migration, which (since it's the very first migration) will also create the database itself:

```sh
bundle exec rake db:migrate
```

You can probably get away with just running `rake db:migrate` directly, but starting your commands with `bundle exec` asks bundler to run the command in the context of the dependencies specified in the current app's Gemfile (rather than potentially pulling in a version of rake installed globally on the server you're using, which can cause dependency headaches down the line). It's a good habit to get into.

**Self Check Question:** How does Rails decide where and how to create the development database? (Hint: check the `db` and `config` subdirectories)

**Self Check Question:** What tables got created by the migrations?

Now insert "seed data" into the database. (Seeds are initial data items that the app needs to run):

```sh
bundle exec rake db:seed
```

**Self Check Question:** What seed data was inserted and where was it specified? (Hint: `rake -T db:seed` explains the seed task; `rake -T` explains other available Rake tasks)

At this point you should be able to run the app locally and visit it from a browser to make sure it's working before you go on.

#### If developing in Codio

You can click the Box URL button like in previous CHIPS. If you want to do it manually, you can obtain your Codio subdomain name by going into any Codio terminal window and saying `hostname`. Your subdomain will be a pair of random words.

1. Start the app in a terminal: `bundle exec rails server -b 0.0.0.0`
2. Open a regular browser window to `<subdomain>-3000.codio.io` to visit the app's home page

#### If developing Locally

1. Start the app in a terminal: `bundle exec rails server` (omit `-b 0.0.0.0`)
2. Open a regular browser window to `localhost:3000/` to visit the app's home page

---

## Part 0 (B): Preparation — deploy to Render

### Initial Render Deployment

Log in to your Render account by visiting https://dashboard.render.com.

For CHIPS 5.3, you will need to complete the Render deployment to your own individual Render app, not your team app. Even if you are pair programming, you should complete a deployment on your own.

Before deploying, make sure your application is configured for PostgreSQL in production. Open your `Gemfile` and make sure it contains:

```ruby
group :production do
  gem 'pg'
end
```

Also make sure your `config/database.yml` production section is configured as follows:

```yaml
production:
  adapter: postgresql
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  url: <%= ENV['DATABASE_URL'] %>
```

If you haven't yet made a commit to your new branch, do that now (you probably have a change in the `db` folder):

```sh
git status # make sure you're on your new branch
git add [..] # stage the updated files
git commit -m [..] # write a message
git push origin <YOUR_BRANCH>
```

Create a PostgreSQL database on Render by clicking **New +** → **PostgreSQL** and selecting the Free plan.

Then create a Web Service, connect your GitHub repository, and configure it with:

- **Build Command:** `./bin/render-build.sh`
- **Start Command:** `bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-production}`

Add the following environment variables to your Web Service:

- `DATABASE_URL` = the Internal Connection String from your Render PostgreSQL database
- `RAILS_MASTER_KEY` = the contents of your local `config/master.key` file
- If there is no local `config/master.key` file, generate a new master key using:

```sh
cd rottenpotatoes-rails-intro
rm config/credentials.yml.enc
bin/rails credentials:edit
```

Make sure to commit these changes. Render will automatically build and deploy your application from GitHub.

As with the previous assignment "Hello Rails", the build script (`bin/render-build.sh`) will automatically run the initial migration and import the seed data during deployment:

```sh
bundle exec rails db:migrate
bundle exec rails db:seed
```

Now you should be able to navigate to your app's URL.

**Note:** don't proceed past this point until you are able to complete the above successfully, or you won't be able to receive a grade for this assignment!

---

## Part 1: Filter the list of movies by rating

**Suggestion:** Read this whole page before starting to code! There are hints and an overview of the big picture here!

Enhance RottenPotatoes as follows. At the top of the All Movies listing, add some checkboxes that allow the user to filter the list to show only movies with certain MPAA ratings.

The filter should be included somewhere below the page heading. It should have a checkbox for each rating, followed by a "Refresh" button.

When the Refresh button is pressed, the list of movies is redisplayed showing only those movies whose ratings were checked. If no boxes are checked, after a user hits the Refresh button, all movies should be listed, and all checkboxes should be checked. It also applies to the first time when the user visits the page (i.e. when the user visits the page, all checkboxes should be checked).

This will require a couple of pieces of code. We have provided the code that generates the checkboxes form, which you can include in the `index.html.erb` template. (The id attributes on some of the elements are required for the autograder to work, so don't change/delete them.)

```erb
<%= form_tag movies_path, method: :get, id: 'ratings_form', local: true do %>
  Include:
  <% @all_ratings.each do |rating| %>
    <div class="form-check  form-check-inline">
      <%= check_box_tag "ratings[#{rating}]", "1", @ratings_to_show.include?(rating), class: 'form-check-input' %>
      <%= label_tag "ratings[#{rating}]", rating, class: 'form-check-label' %>
    </div>
  <% end %>
  <%= submit_tag 'Refresh', id: 'ratings_submit', class: 'btn btn-primary' %>
<% end %>
```

BUT, you have to do a bit of work to use the above code:

- As you can see, it expects the variable `@all_ratings` to be an enumerable collection of all possible values of a movie rating, such as `['G','PG','PG-13','R']`. The controller action needs to set up this variable. And since the possible values of movie ratings are really the responsibility of the Movie model, it's best if the controller sets this variable by consulting the Model. Hence, good form would be to create a class method of Movie that returns an appropriate value for this collection, say `Movie.all_ratings`, and have the controller assign that to the appropriate instance variable for the view to pick up.
- The Rails documentation for `check_box_tag` says that the third value, evaluated as a Boolean, tells whether the checkbox should be displayed as checked or not. In the code above, `@ratings_to_show` is assumed to be a collection of which ratings should be checked. So `@ratings_to_show.include?('G')` would be true if 'G' was a member of the collection. The controller action must also set up this array, even if no check boxes are checked.

**Why must the controller set up a default value for `@ratings_to_show` even if nothing is checked?**

You will also need code in the controller that knows (i) how to figure out which boxes the user checked and (ii) how to restrict the database query based on that result.

Regarding (i), try viewing the source of the movie listings with the checkbox form, and you'll see that the checkboxes have field names like `ratings[G]`, `ratings[PG]`, etc. This trick will cause Rails to aggregate the values into a single hash called `ratings`, whose keys will be the names of the checked boxes only, and whose values will be the value attribute of the checkbox (which is "1" by default). That is, if the user checks the G and R boxes, params will include `:ratings=>{"G"=>"1", "R"=>"1"}`. Check out the Hash documentation for an easy way to grab just the keys of a hash, since we don't care about the values in this case (checkboxes that weren't checked don't appear in the params hash at all).

Regarding (ii), you'll probably end up replacing `Movie.all` in the controller method. Since most interesting code should go in the model rather than exposing details of the schema to the controller, consider defining a class-level method in the model such as `Movie.with_ratings(ratings)` that takes an array of ratings (e.g. `["r", "pg-13"]`) and returns an ActiveRecord relation of movies whose rating matches (case-insensitively) anything in that array. To do its job, this method can make use of `Movie.where`, which has various options to help you restrict the database query.

**Hint:** read the documentation about `ActiveRecord::Base` for examples of how to use `where` to do queries like this. You may also find `.present?` convenient.

### IMPORTANT for grading purposes

- As in the code above, your form tag should have the id `ratings_form` and the form submit button for filtering by ratings should have the id `ratings_submit`.
- Each checkbox should have an HTML element id of `ratings_#{rating}`, where the interpolated rating should be the rating itself, such as `ratings_PG-13`, `ratings_G`, and so on.

### More Hints

We suggest adding a class method in Movie as follows:

```ruby
class Movie < ApplicationRecord
  def self.with_ratings(ratings_list)
  # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  #  movies with those ratings
  # if ratings_list is nil, retrieve ALL movies
  end
end
```

Using the debugger, take a look at what is in `params[]` when the form is submitted with various checkboxes checked, and particularly, what is in `params[:ratings]` (or `params['ratings']`).

Notice that you will need to use the `params[:ratings]` values in two ways in the controller: to determine what values to pass to `Movie.with_ratings`, and to set a variable that can be used by the view so that the appropriate checkboxes show up as checked when the filtered view is loaded.

### To pay attention to…

**Labels:** These labels are critical for a properly functioning form! Primarily, they tell users what checkbox they are about to select. However, labels also provide built-in accessibility features (such as for blind users) or handy shortcuts like clicking "G" to apply the "G" checkbox.

**Reminder:** Don't put logic in your views! If you find yourself doing computation in your views, set up an instance variable in the controller and do the computation there instead. And if the computation is anything more than trivial, it probably belongs in a model, not in the controller.

### Deploying this feature

Once you've verified that your code works (by running the Rails server locally and trying it), we'll try deploying what we've made so far to the Render Web Service. This time, let's use the `main` branch of your repository. That means we'll have to merge our current branch into `main`, which is most easily accomplished with a pull request on GitHub.

First, make a commit to your feature branch with all of your changes, then push the branch's updates to GitHub. Use the same technique as in previous CHIPS to create a pull request, then merge that pull request into your repository's `main` branch.

Once you've done this, your GitHub repository's `main` branch will be up to date with your latest changes. Check out the `main` branch on your local repository:

```sh
git checkout main
```

Then, you can pull the new, updated version of `main` from the origin remote (your GitHub repository) into your local repository:

```sh
git pull origin main
```

And, since you won't need the feature branch anymore, you can clean up by deleting the local branch:

```sh
git branch -d <OLD_BRANCH_NAME>
```

There's also a button on GitHub that will do this for you for the copy of the branch that existed on the remote.

Now, we can deploy the updated `main` branch to Render. Different teams will have different approaches, but it's common to deploy to the production web server only from the `main` branch, rather than making deploys from potentially out-of-date feature branches.

```sh
git push origin main
```

Render should automatically detect the new commit and begin deploying your application. If it does not, go to your Render Web Service and select Manual Deploy → Deploy latest commit.

Have a peek at the new changes and make sure they're working properly before moving onto the next section.

---

## Part 2: Sort the list of movies

First, let's make a new feature branch for the next step. This time, we're adding a sorting functionality, so consider naming your branch something relevant to the feature you'll be implementing.

```sh
git checkout -b <NEW_BRANCH_NAME>
```

On the list of all movies page, add a drop-down with "Title" and "Release Date" as options. Selecting one of them and clicking the Refresh button should cause the list to be reloaded but sorted in ascending order on that column. For example, using the "release date" column should redisplay the list of movies with the earliest-released movies first; using the "title" header should list the movies alphabetically by title. (For movies whose names begin with non-letters, the sort order should match the behavior of `String#<=>`.) You can add this code right before the submit tag:

```erb
<div>
    <label class="form-label me-2" for="sort_by">Sort by:</label>
    <%= select_tag :sort_by,
                   options_for_select([["Title", "title"],
                                       ["Release date", "release_date"]],
                                       @sort_by),
                   id:    "sort_by",
                   class: "form-select d-inline w-auto" %>
</div>
```

When the listing page is redisplayed with sorting-on-a-column enabled, the column that was selected for sorting should appear in the drop-down.

**Note:** Initially, you will probably find that when you click on a sort column, the app will "forget" which checkboxes have been checked. Similarly, when you sort on a column but then you change which checkboxes are checked, the app will "forget" the desired sort order. We'll fix these cases later.

### IMPORTANT for grading purposes

- As in the code above, your select tag should have the id `sort_by` and the form submit button for filtering by ratings should have the id `ratings_submit`.
- Both pieces of the provided code, Part 1 and Part 2 of this assignment, should be placed inside the same `form_tag`.

### Hint: Adding parameters to existing RESTful routes

The current RottenPotatoes views use the Rails-provided "resource-based routes" helper `movies_path` to generate the correct URI for the movies index page. You may find it helpful to know that if you pass this helper method a hash of additional parameters, those parameters will be parsed by Rails and available in the `params[]` hash. To play around with this behavior, you can test out routes in the Rails console.

So, when you are converting those column headers into clickable links (for which it's best to use the `link_to` helper) that point to the RESTful route for fetching the movie list (best done using the route helper `movies_path()`), think about how you might modify the call that generates the route helper in order to include information visible in params that would tell you which column header was clicked. **Hint:** every parameter in a route has a key and a value, so any argument you pass to `movies_path` would have to be a hash.

### Hint: displaying things in the right order

Databases are pretty good at returning collections of rows in sorted order according to one or more attributes. Before you rush to sort the collection returned from the database, look at the documentation for `ActiveRecord.order` and see if you can get the database to do the work for you.

Don't put logic in your views! The view shouldn't have to sort the collection itself—its job is just to show stuff. The controller should spoon-feed the view exactly what is to be displayed.

### Remembering both the sort order and filtering order

At this point, you should have sort columns working, but you probably noticed that sorting on a column "forgets" the values of which checkboxes were checked. Let's fix that.

The key to fixing it is to remember that when we constructed the form for the checkboxes in part 1, the only thing that was needed to pass to the controller was the info about which checkboxes were checked. For example, if the boxes whose field names were `ratings_G` and `ratings_PG` were checked, `params[:ratings]` would contain a hash `{'G': '1', 'PG': '1'}`.

So if we could also include this info in the link when the user clicks a column name, the info would be passed into the controller action along with the column name itself!

Now, the view already knows that the value `@ratings_to_show` is an array containing only the values for the boxes that were checked–for example, something like `['G','R']`. But to make it look right for params, we need to pass `movies_path()` something that looks more like `{'G':'1', 'R':'1'}` (or really, any value other than '1' is fine, since it's just the presence of the key that matters).

Judiciously using a search engine or AI, find and test a concise way to derive a hash whose keys are the values of an array, and whose value for all the keys is some constant like '1'. With that in hand, modify the arguments to the `movies_path()` route helper already used by your column headers to include that hash, such that the information about which checkboxes were checked on the form appears as part of the route.

At this point, you should be able to refresh the view by either clicking on a column header or clicking the Refresh button, and both types of changes should be "remembered".

There is a minor corner case though—changing the checkbox filters and then clicking on a column header (instead of the submit button) should not cause the changes to ratings filters be "remembered" and should not result in the checkbox filter changing when the page is refreshed.

### Deploying again

We could use the same strategy as the last part to deploy. This time, though, let's do it without a pull request. Pull requests are great, but it's good to see how branch merging works straight from the command line, rather than always relying on the big green button in GitHub to make a merge commit for you.

First, stage your changes and commit them to the feature branch you created. Then, check out your `main` branch:

```sh
git checkout main
```

When you're about to merge one branch into another, it's always good practice to start by making sure your target branch is up to date with the remote:

```sh
git pull origin main
```

Of course, you won't have any new changes on main to pull, since there's no one else making changes to the repository right now. Still, it's good to get in the habit of checking that you're up-to-date with the remote! Even on solo projects, it's easy to get tripped up by working on multiple computers.

Now, let's manually merge the new feature branch into main. This is what GitHub is doing when you press the "Merge pull request" button. The `--no-edit` command just prevents Git from opening up an editor for the merge commit message (the default is fine).

```sh
git merge --no-edit <FEATURE_BRANCH_NAME>
```

**Self Check Question:** What would happen if, while you were working on your feature branch, someone else had made changes to the main branch of the remote on the same parts of the same files you just edited?

This will update the `main` branch to include the commits from your feature branch. Now, you can delete the feature branch and push `main` to the remote:

```sh
git branch -d <FEATURE_BRANCH_NAME>
git push origin main
```

Again, when you're merging into main, it's typically better to use the pull request flow; we used the manual merge technique here just to give you a peek under the hood. One risk of doing the merge-to-main process yourself is that things get messy if two people try to merge their feature branches into main at the same time.

Now that we've got our code on the `main` branch, we can once again deploy our `main` branch to Render:

```sh
git push origin main
```

Render should automatically detect the new commit and begin deploying your application. If it does not, go to your Render Web Service and select Manual Deploy → Deploy latest commit.

Check that it's working on the Render site!

---

## Part 3: Remember the sorting and filtering settings

Make another feature branch for this part.

**Why not just make every change in one big branch/PR? Why are we splitting them up into smaller feature branches?**

OK, so the user can now click on the "Title" or "Release Date" drop-down and see movies sorted by those columns, and can additionally use the checkboxes to restrict the listing to movies with certain ratings only. And we have preserved RESTfulness, because the URI itself always contains the parameters that will control sorting and filtering. And changing one setting doesn't forget the other settings. We did all this by carefully controlling which parameters get passed in the form submit button (which uses `GET`).

But there's one more problem. If you navigate away from the Index view (say, to view the details of a movie) and then click the Back to List button to go back to the Index view, it seems to forget the sorting and filtering settings as well. (Go ahead and verify this.)

**Why is the sorting/checkbox-filtering setting "forgotten" when you navigate to a Movie Details page and then click the Back to List button?**

So the last step is to remember these settings even if the user navigates away from and then back to the list of movies.

Fortunately, HTTP-based SaaS has a way to "remember" state across otherwise-stateless requests: cookies. In Rails, the `session[]` hash provides a nice abstraction for using cookies: anything you put in there will basically be preserved for as long as that user's browser continues to correctly maintain cookies for your app. In other words, comparing it to something you've seen before, the session is like the `flash[]`, except that once you set something in the `session[]` it is remembered "forever" until you reset the session with `session.clear` or selectively delete things from it with `session.delete(:some_key)`.

A big caveat: Since the default storage for the contents of `session` is a browser cookie, (a) users who reset or clear their cookies will also reset the session for RottenPotatoes, and (b) the contents of the `session`, once serialized, cannot exceed the size of an HTTP cookie (4 KiB).

### Hints and caveats

Once you have determined the correct sorting and filtering settings, before you render the view, use `session[]` to hold on to the those settings.

Now modify the `index` action to detect whether no `params[]` were passed that indicate sorting or filtering: this would be one way to tell that the user is landing on the home page not having followed one of the special links we made in parts 1 and 2.

**What might be some other ways to tell if this is the case?**

Be careful: If the user explicitly includes new sorting/filtering settings in `params[]`, the new values of those settings should then be saved.

As before, if a user unchecks all checkboxes, it means "display all ratings."

Now, deploy to Render again. You should first commit your changes to the new feature branch, then choose whether to make a pull request and merge through GitHub (as in part 1) or merge locally (as in part 2). Either way, make sure your changes have made their way to the `main` branch, then deploy as before.

---

## How to submit when you're all done

Deploying your finished app to Render by the homework deadline is part of the grading process. Even if you have code checked in that works properly, you still need to also deploy it to Render to get full credit. Each team member, even if pair programming for this assignment, should complete a Render deploy and submit the link for their own personal Render app individually.

Once you're confident the functionality works correctly on Render, submit the URI of your deployed Render app in the text file to the left with no other contents. If Codio has not opened a text file for you, create a text file in your workspace folder called `rottenpotatoes-url.txt`.

Please be careful to use https, that is, submit `https://your-app.onrender.com`.

Click the button below to submit your Render URL to the auto-grader.

**CAUTION:** The first time you run this autograder, it is installing gems and could take up to several minutes. This is not a problem with Codio, this was a design decision by the autograder author. Please be patient. It will be much faster for subsequent submissions.

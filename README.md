## Tic Tac Toe

### Install
clone repo from github.  This app uses ruby 2.4.0.

### Play
Run ```$ ruby app.rb``` from the root directory of the application.

### Extend

#### Development Instalation
This application has a few dependencies which, while not required to use the game, are required to change it.  These dependancies will automatically be installed by running ```$ bundle install``` from the root directory of the application.  *Note this operation requires bundler, if you do not already have bundler on your machine you can find it [here](https://github.com/bundler/bundler).

#### Run Tests
This application uses RSpec for testing.  Tests can be run individual using ```$ bundle exec rspec spec/my_dir/my_file_spec.rb``` or collectively using ```$ bundle exec rspec```.

## Tic Tac Toe

This is a project I did for a code challenge on a private repo (copied over w/ permission), where the challenge was to take a horribly built, untested, malfunctioning program and bring it to a usable state + extend it.  In order to protect the privacy of the company who's code challenge it was, I've wiped out the commit history.  But I was proud of the craftsmanship of my final product and wanted to show it off, so here it is.

### Install
clone repo from github.

### Play
Run ```$ ruby app.rb``` from the root directory of the application.

### Extend

#### Development Instalation
This application has a few dependencies which, while not required to use the game, are required to change it.  These dependancies will automatically be installed by running ```$ bundle install``` from the root directory of the application.  *Note this operation requires bundler, if you do not already have bundler on your machine you can find it [here](https://github.com/bundler/bundler).

#### Run Tests
This application uses RSpec for testing.  Tests can be run individual using ```$ bundle exec rspec spec/my_dir/my_file_spec.rb``` or collectively using ```$ bundle exec rspec```.

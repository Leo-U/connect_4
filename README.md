## Connect 4
This is a command line based [Connect Four](https://en.wikipedia.org/wiki/Connect_Four) game, which I have completed as a student of [The Odin Project](https://www.theodinproject.com/about).

It can be played [here](https://replit.com/@LeoU1/connect4?v=1).

This project was built using RSpec, a Ruby testing framework.

The tricky part of this project was detecting diagonals.

Basically, my solution was to use Ruby's `#rotate` method on each row to line up the diagonals vertically, and then `#transpose` the result.


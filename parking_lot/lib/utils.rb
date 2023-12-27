# frozen_string_literal: true


def quit?
  begin
    # See if a 'Q' has been typed yet
    while (c = STDIN.read_nonblock(1))
      puts "I found a #{c}"
      return true if c == 'Q'
    end
    # No 'Q' found
    false
  rescue Errno::EINTR, Errno::EAGAIN
    false
  rescue EOFError
    # quit on the end of the input stream
    # (user hit CTRL-D)
    true
  end
end
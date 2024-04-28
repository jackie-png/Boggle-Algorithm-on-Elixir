defmodule Tester do

  def func() do
    board = {
      {"A", "B", "C", "D"},
      {"E", "F", "G", "H"},
      {"I", "J", "K", "L"},
      {"M", "N", "O", "P"}
    }
    words =  ["ABCD", "EFGH", "IJKL", "MNOP", "AEIM", "BFJN", "CGKO", "DHLP"]
    Boggle.boggle(board,words)
  end
end

IO.inspect "hello tehre"
IO.inspect Tester.func()

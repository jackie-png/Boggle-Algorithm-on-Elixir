
defmodule Boggle do
  import TrieNode
  @moduledoc """
    Add your boggle function below. You may add additional helper functions if you desire.
    Test your code by running 'mix test' from the tester_ex_simple directory.
  """

  def boggle(board, words) do
    # Your code here!
    root = insertAll(words, %TrieNode{}) #insert all the words of the wordlist into the root
    #findAllWords(board, words, root, "", %{}) #returns a map at the end
    tracker = {makeVisitedGrid(board),0,0,%{}}
    result = rowLoop(0, board, tracker, root);
    elem(result, 3)
  end

  #looping through the array and triggering the dfs
  def rowLoop(row, grid, tracker, root) when row < tuple_size(grid) do
    #IO.puts"----rowLOOP------"
    #IO.inspect tracker
    #IO.inspect grid
    #IO.inspect row
    #IO.puts"--------------"

    tracker = colLoop(0, grid, row, tracker, root) #row is a tuple, not good, find a way to print the row number not the row itself
    rowLoop(row+1, grid, tracker, root)
  end
  def rowLoop(_row,_grid, tracker,_root), do: tracker

  def colLoop(c, grid, row, tracker, root) when c < tuple_size(elem(grid,row)) do

    #IO.puts"----ColLoop-----"
    #IO.inspect grid
    #IO.inspect row
    #IO.inspect c
    visited = makeVisitedGrid(grid)
    #IO.inspect visited
    #IO.puts"--------------"
    tracker = dfs({visited, [], [], elem(tracker, 3)}, grid, root, row, c) #change this to be the dfs function
    colLoop(c+1, grid, row, tracker, root)
  end

  def colLoop(_c, _grid, _row, tracker,_root) do
    #IO.puts c < tuple_size(elem(grid,row))
    tracker
  end

  #making the visited grid to keep track of which letter has been visited
  def makeVisitedGrid(grid) do
    makeVisitedGrid(0, grid, {})
  end

  def makeVisitedGrid(row, grid, acc) when row < tuple_size(grid) do
    acc = Tuple.append(acc, makeVisitedCol(0, elem(grid, row), {}))
    makeVisitedGrid(row+1, grid, acc)
  end
  def makeVisitedGrid(_row, _grid, acc), do: acc

  def makeVisitedCol(c, row, acc) when c < tuple_size(row) do
    acc = Tuple.append(acc, false)
    makeVisitedCol(c+1, row, acc)
  end

  def makeVisitedCol(_c, _row, acc), do: acc

  def visitCell(visited, row, col) do
    put_elem(visited,row,put_elem(elem(visited,row),col,true))
  end
  def unvisitCell(visited, row, col) do
    put_elem(visited,row,put_elem(elem(visited,row),col,false))
  end
  def isVisited(visited, row, col), do: elem(elem(visited, row), col)

  defp dfs({visited, acc, path, wordList}, grid, root, row, col) when (row >= 0) and (row < tuple_size(grid)) and (col >= 0) and (col < tuple_size(elem(grid, 0))) and ((elem(elem(visited, row),col) == false)) do
    #triggers when 0 <= row < maxRowSize, 0 <= col < maxColSize, current cell is not visited

    #mark cell as visited
    visited = visitCell(visited, row, col)

    #add current cell in path
    path = List.insert_at(path, (length(path)), {row, col})

    #concatinate acc with the current letter
    acc = List.insert_at(acc, (length(acc)), elem(elem(grid,row), col))
    word = List.to_string(acc)

    #check if the current acc is a word in the root
    #IO.puts word
    #IO.puts TrieNode.isPrefix(word, root)

    if TrieNode.isPrefix(word, root) do
      wordList = TrieNode.isWord(word, root, wordList, path)
      tracker = {visited, acc, path, wordList}

      #traverse into neighbors
      tracker = dfs(tracker, grid, root, row+1, col)
      tracker = dfs(tracker, grid, root, row-1, col)
      tracker = dfs(tracker, grid, root, row, col+1)
      tracker = dfs(tracker, grid, root, row, col-1)
      tracker = dfs(tracker, grid, root, row+1, col+1)
      tracker = dfs(tracker, grid, root, row+1, col-1)
      tracker = dfs(tracker, grid, root, row-1, col+1)
      tracker = dfs(tracker, grid, root, row-1, col-1)
      tracker = backtrack(tracker, row, col);
      #IO.puts "is prefix"
      #IO.inspect tracker
      tracker

    else
      tracker = {visited, acc, path, wordList}
      tracker = backtrack(tracker, row, col);
      #IO.puts "is not prefix"
      #IO.inspect tracker
      tracker
    end

  end

  defp dfs({visited, acc, path, wordList}, grid, _root, row, col) when (row < 0) or (row >= tuple_size(grid)) or (col < 0) or (col >= tuple_size(elem(grid, 0))) or ((elem(elem(visited,row),col) == true)) do
    #youll need to remake this part,


    #IO.puts "---------dfs no guard----------"
    #IO.inspect tracker
    #IO.inspect row
    #IO.inspect col
    #IO.puts "-------------------"

    {visited, acc, path, wordList}
  end

  defp backtrack({visited, acc, path, wordList}, row, col) when length(path) > 1 do
    visited = unvisitCell(visited, row, col)
    acc = List.delete_at(acc, length(acc) - 1)
    path = List.delete_at(path, length(path) - 1)
    {visited, acc, path, wordList}
  end
  defp backtrack(tracker, _row, _col), do: tracker

end

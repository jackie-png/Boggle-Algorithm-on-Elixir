defmodule TrieNode do
  defstruct letter: 0 ,children: %{}, isEndOfWord: false

  # convert the string into a character list
  def insert(word, root) do
    insertp(to_charlist(word), root)
  end

  #when there is one letter and it is already inside the trie
  defp insertp([letter], root) when is_map_key(root.children, letter)do
    %{root| isEndOfWord: true}
  end

  #when there is one letter left and it isnt in the trie yet
  defp insertp([letter], root) do
    newLetter = %TrieNode{letter: letter, isEndOfWord: true}
    %{root| children: (Map.put(root.children, letter, newLetter))}
  end

  #when there is more than one letter left and the first letter it is in the trie already
  defp insertp([letter|rest], root) when is_map_key(root.children, letter) do
    newChildren = Map.put(root.children, letter, insertp(rest, Map.get(root.children, letter)))
    %{root| children: newChildren}
  end

  #when there is more than one letter left and the first letter is not in the trie
  defp insertp([letter|rest], root) do
    newChild = %TrieNode{letter: letter}
    newChildren = Map.put(root.children, letter, insertp(rest, newChild))
    %{root| children: newChildren}
  end

  def insertAll([word], root) do
    insert(word, root)
  end

  def insertAll([word|rest], root) do
    insertAll(rest, insertp(to_charlist(word), root))
  end



  #make the word into a charlist
  def traverse(word, root) do
    traversep(to_charlist(word), root)
  end

  #if there are no more letters in the list, return the node's end of word var
  defp traversep([], root) do
    root.isEndOfWord
  end

  #if there are letters, traverse throught the nodes
  defp traversep([letter|rest], root) when is_map_key(root.children, letter)do
    traversep(rest, Map.get(root.children, letter))
  end

  #catch all, you reach a letter that isnt in the trie yet given previous sequence
  defp traversep([_letter|_rest], _root) do
    false
  end

  def isWord(word, root, wordList, path) do
    if traverse(word, root) do
      Map.put(wordList, word, path)
    else
      wordList
    end
  end

  def isPrefix(pref, root) do
    isPrefixp(to_charlist(pref), root)
  end

  defp isPrefixp([], root) when (map_size(root.children) > 0) or (root.isEndOfWord == true) do
    true
  end



  defp isPrefixp([head|rest], root) when is_map_key(root.children, head) do
    isPrefixp(rest, Map.get(root.children, head))
  end

  defp isPrefixp(_, _root) do
    false
  end


end

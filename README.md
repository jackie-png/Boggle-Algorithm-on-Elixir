# Boggle On Elixir
This is a Boggle Algorithm that finds all the words on a given board
It uses a Trie data structure that can  
1. Store words and traverse throught the trie to find if a given word is a word inside the Trie
2. An isPrefix function to check if the current prefix is a prefix to any word such that it won't have to have the program traverse down the Trie if the prefix has no words beginning with it 

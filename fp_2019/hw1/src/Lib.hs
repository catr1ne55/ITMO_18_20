module Lib
      (Dictionary, empty, get, put, remove, foldd)
      where

import Data.List
import Data.Maybe
import Data.Bifunctor
import Safe

data Node v = Node {value :: Maybe v, next :: [(Char, Node v)]} deriving Eq
newtype Trie v = Trie {root :: Node v}
type Dictionary = Trie String

emptyNode :: Node v --пустой узел
emptyNode = Node Nothing []

empty :: Dictionary -- пустой словарь
empty = Trie emptyNode

get :: String -> Dictionary -> Maybe String -- выдает значение по ключу
get key dictionary = getFromNode key (root dictionary) where
    getFromNode :: String -> Node String -> Maybe String -- вспомогательная функция для get из узла
    getFromNode "" node = value node
    getFromNode (x:xs) (Node _ nextNodes) = find ((x==) . fst) nextNodes >>= getFromNode xs . snd

getNode :: String -> Node String -> Maybe (Node String) -- получить узел
getNode "" node = Just node
getNode (x:xs) (Node _ nextNodes) = find ((x==) . fst) nextNodes >>= getNode xs . snd

put :: String -> String -> Dictionary -> (Maybe String, Dictionary) -- заменяет или добавляет значение с заданным ключом
put key val dictionary = (previousValue, newDict) where
    previousValue =  get key dictionary
    newDict = Trie (putToNode key val (root dictionary)) where
      putToNode :: String -> String -> Node String -> Node String -- то же, что и put, но для узла
      putToNode "" valN node = Node (Just valN) (next node)
      putToNode (x:xs) valN node = Node (value node) (zip (map fst nextNodes) (map ((\ n -> if n == nodeToPut then putToNode xs valN n else n) . snd) nextNodes)) where
          nodeToPut = fromJust (getNode [x] (Node (value node) nextNodes))
          nextNodes  = putChar x (next node) where
                    putChar :: Char -> [(Char, Node String)] -> [(Char, Node String)] -- вспомогательная функция для посимвольного сравнения ключа и добавление его в следующие узлы
                    putChar x [] = [(x, emptyNode)]
                    putChar x n@(l:ls) | x == fst l = n
                                       | otherwise = if x > fst l then l: putChar x ls else (x, emptyNode):n

remove :: String -> Dictionary -> (Maybe String, Dictionary) -- удаляет слово из словаря
remove key dictionary = (removedValue, newDict) where
    removedValue = get key dictionary
    newDict = if isNothing removedValue
              then dictionary
              else Trie (removeFromNode key (root dictionary)) where
                  removeFromNode :: String -> Node String -> Node String -- remove из узла
                  removeFromNode "" node = Node Nothing (next node)
                  removeFromNode (x:xs) node = Node (value node) (map removeFromNext (next node)) where
                        removeFromNext (c, n) = (c, if c == x then removeFromNode xs n else n)

foldd :: ((String, String) -> a -> a) -> a -> Dictionary -> a -- свертка словаря в порядке убывания ключей
foldd function initial dictionary = foldNode function initial "" (root dictionary) where
     foldNode :: ((String, String) -> a -> a) -> a -> String -> Node String -> a
     foldNode func initValue current (Node Nothing nextNodes) = foldr (funcForFold foldNode func current) initValue nextNodes
     foldNode func initValue current (Node (Just val) nextNodes) = func (current, val) (foldNode func initValue current (Node Nothing nextNodes))

funcForFold :: (((String, String) -> a -> a) -> a -> String -> Node String -> a) -> ((String, String) -> a -> a) -> String -> (Char, Node String) -> a -> a
funcForFold foldfunc func cur node x = foldfunc func x (cur ++ [fst node]) (snd node)

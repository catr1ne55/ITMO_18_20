module Lib
    ( Graph, distance
    ) where
import Prelude hiding (lookup, filter)

import qualified Data.Map as Map
import Data.Map (Map, (!), lookup, insert, adjust, filter, singleton, keys, elems)
import Data.Maybe (isNothing)

type Arc = (String, Integer)
type Graph = String -> [Arc]

distance :: Graph -> String -> String -> Maybe Integer
distance graph v1 v2 = if isNothing value then Nothing else fmap fst value where
    value = lookup v2 (dijkstra graph v2 (singleton v1 (0, False)))

dijkstra :: Graph -> String -> Data.Map.Map String (Integer, Bool) -> Data.Map.Map String (Integer, Bool)
dijkstra graph vertexTo distances | fmap snd (lookup vertexTo distances) == Just True || all (== True) (map snd (elems distances)) = distances
                                  | otherwise = dijkstra graph vertexTo new_distances where
                                      unvisited = keys (filter (\(x, y) -> not y) distances)
                                      minimal_vertex = nearest graph unvisited distances
                                      arcs = graph minimal_vertex
                                      inserted_distances = insert minimal_vertex (fmap fst distances ! minimal_vertex, True) distances
                                      almost_new_distances = relax minimal_vertex arcs inserted_distances
                                      new_distances = insert minimal_vertex (fmap fst distances ! minimal_vertex, True) almost_new_distances

nearest :: Graph -> [String] -> Data.Map.Map String (Integer, Bool) -> String
nearest graph unvisited distances = Prelude.foldr (\v v1 -> if fmap fst distances ! v < fmap fst distances ! v1 then v else v1) (head unvisited) unvisited

relax :: String -> [Arc] -> Data.Map.Map String (Integer, Bool) -> Data.Map.Map String (Integer, Bool)
relax vertex arcs distances = foldr func4fold distances arcs where
    current_distance = fst (distances ! vertex)
    func4fold :: Arc -> Data.Map.Map String (Integer, Bool) -> Data.Map.Map String (Integer, Bool)
    func4fold (current_vertex, weight) distances | fmap snd (lookup current_vertex distances) == Just True = distances
                                                 | isNothing (lookup current_vertex distances) = insert current_vertex (current_distance + weight, False) distances
                                                 | otherwise = adjust func current_vertex distances where
                                                          func (x, a) = (min x (current_distance + weight), a)

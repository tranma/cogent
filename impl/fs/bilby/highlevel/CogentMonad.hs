{-# LANGUAGE InstanceSigs #-}
{- LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE RankNTypes #-}

module CogentMonad where

-- import Control.Monad
import Data.Set as S
import Prelude hiding (return, (>>=), (>>))

type Cogent_monad a = Set a

-- copied from http://hackage.haskell.org/package/set-extra-1.4
flatten :: (Ord a) => Set (Set a) -> Set a
flatten ss' = fold union empty ss'
--flatten = unions . toList

image :: (a -> b) -> Set a -> Set b
image f s = S.mapMonotonic f s  -- may not hold

instance Functor Set where
  fmap = image

-- instance Applicative Set where
--   pure = return
--   (<*>) = ap

-- instance Monad Set where
return :: a -> Set a
return = singleton
  
infixl 1 >>=, >>

(>>=) :: (Ord b) => Set a -> (a -> Set b) -> Set b
m >>= f = flatten (f `image` m)

(>>) :: (Ord b) => Set a -> Set b -> Set b
x >> y = x >>= \_ -> y

select :: Set a -> Cogent_monad a
select = id

alternative :: (Ord a) => Cogent_monad a -> Cogent_monad a -> Cogent_monad a
alternative = union


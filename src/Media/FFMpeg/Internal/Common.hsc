{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

{- |

Description : Internal utility module for the ffmpeg bindings
Copyright   : (c) Vasyl Pasternak, 2009
                  Callum Lowcay, 2015
License     : BSD3
Stability   : experimental

Internal utility module for the ffmpeg bindings

-}

module Media.FFMpeg.Internal.Common (
	AVRational(..),
	ExternalPointer (..),

	FieldAccessType(..),
	Field(..),
	chasePointers,
	getField,
	setField,
	modField,
	getFieldString,

	CEnum (..),
	CFlags (..),
	fromVersionNum,
	justPtr
) where

import Control.Applicative
import Control.Monad.IO.Class
import Data.Bits
import Data.Monoid
import Data.Ratio
import Data.Version
import Data.Word
import Foreign.C.String
import Foreign.C.Types
import Foreign.ForeignPtr
import Foreign.ForeignPtr.Unsafe
import Foreign.Marshal.Alloc
import Foreign.Ptr
import Foreign.Storable

-- | Rational type with a Storable instance
newtype AVRational = AVRational {fromAVRational :: Rational}
	deriving (Eq, Show, Ord, Num, Fractional, RealFrac, Real)

instance Storable (Maybe AVRational) where
	sizeOf _ = #{size int} * 2
	alignment _ = 8
	peek ptr = do
		num <- peek (castPtr ptr) :: IO CInt
		den <- peek (ptr `plusPtr` #{size int}) :: IO CInt
		if (den == 0) then return Nothing
			else return . Just . AVRational$ fromIntegral num % fromIntegral den
	poke ptr (Just (AVRational v)) = do
		poke (castPtr ptr) (fromIntegral$ numerator v :: CInt)
		poke (ptr `plusPtr` #{size int}) (fromIntegral$ denominator v :: CInt)
	poke ptr Nothing = do
		poke (castPtr ptr) (0 :: CInt)
		poke (ptr `plusPtr` #{size int}) (0 :: CInt)

-- | Similar to 'Foreign.Marshal.Utils.with' but without needing the Storable
-- constraint (and also more generic)
class ExternalPointer a where
	type UnderlyingType a :: *
	withThis :: MonadIO m => a -> (Ptr (UnderlyingType a) -> m b) -> m b
	withOrNull :: MonadIO m => Maybe a -> (Ptr (UnderlyingType a) -> m b) -> m b
	withOrNull Nothing io = io nullPtr
	withOrNull (Just x) io = withThis x io

instance ExternalPointer (Ptr a) where
	type UnderlyingType (Ptr a) = a
	withThis ptr action = action ptr

instance ExternalPointer (ForeignPtr a) where
	type UnderlyingType (ForeignPtr a) = a
	withThis fptr action = do
		r <- action$ unsafeForeignPtrToPtr fptr
		liftIO$ touchForeignPtr fptr
		return r

instance ExternalPointer [Char] where
	type UnderlyingType String = CChar
	withThis string action = do
		s <- liftIO$ newCString string
		r <- action s
		liftIO$ free s
		return r

-- | How a Field may be accessed
data FieldAccessType = ReadOnly | ReadWrite

-- | Represents a field in a struct
data Field a t (ro :: FieldAccessType) = Field Int [Int]

-- | Compose Fields
fthen :: Field a b rol -> Field b t ror -> Field a t ror
fthen (Field offset offsets) (Field offsetr offsetsr) = Field offset (offsets ++ [offsetr] ++ offsetsr)

-- | Read a named field
getField :: (MonadIO m, ExternalPointer a, Storable t) => Field a t ro -> a -> m t
getField (Field offset offsets) x =
	withThis x$ \px -> liftIO$ peek =<< (castPtr <$> chasePointers px offset offsets)

chasePointers :: Ptr a -> Int -> [Int] -> IO (Ptr ())
chasePointers p offset [] = return$ p `plusPtr` offset
chasePointers p offset (o:os) = do
	p' <- peek$ p `plusPtr` offset
	chasePointers p' o os

-- | Write to a named field
setField :: (MonadIO m, ExternalPointer a, Storable t) => Field a t ReadWrite -> a -> t -> m ()
setField (Field offset offsets) x v = withThis x$ \px -> liftIO$ do
	ptr <- castPtr <$> chasePointers px offset offsets
	poke ptr v

-- | Apply a function inside a field
modField :: (MonadIO m, ExternalPointer a, Storable t) => Field a t ReadWrite -> a -> (t -> t) -> m t
modField (Field offset offsets) x f = withThis x$ \px -> liftIO$ do
	ptr <- castPtr <$> chasePointers px offset offsets
	r <- f <$> peek ptr
	poke ptr r
	return r

-- | Get a String valued field
getFieldString :: (MonadIO m, ExternalPointer a) => Field a String ro -> a -> m String
getFieldString (Field offset offsets) x =
	liftIO.withThis x$ \px -> do
		p <- castPtr <$> chasePointers px offset offsets
		if p == nullPtr then return "" else peekCString p

-- | Used for marshalling enumerations and flags
class CEnum a where
	fromCEnum :: a -> CInt
	toCEnum :: CInt -> a

instance CEnum CInt where
	fromCEnum = id
	toCEnum = id

-- | Class for working with flags
class CFlags a where
	funion :: a -> a -> a
	fintersection :: a -> a -> a
	fminus :: a -> a -> a
	fhasAny :: a -> a -> Bool
	fhasAll :: a -> a -> Bool
	fhas :: a -> a -> Bool
	fhas = fhasAll
	flagsToInt :: a -> CInt
	fempty :: a

instance CFlags CInt where
	funion = (.|.)
	fintersection = (.&.)
	x `fminus` y = x .&. (complement y)
	x `fhasAny` y = (x .&. y) /= 0
	x `fhasAll` y = (x .&. y) == y
	flagsToInt = fromIntegral
	fempty = 0

instance CFlags Word64 where
	funion = (.|.)
	fintersection = (.&.)
	x `fminus` y = x .&. (complement y)
	x `fhasAny` y = (x .&. y) /= 0
	x `fhasAll` y = (x .&. y) == y
	flagsToInt = fromIntegral
	fempty = 0

instance CFlags Word32 where
	funion = (.|.)
	fintersection = (.&.)
	x `fminus` y = x .&. (complement y)
	x `fhasAny` y = (x .&. y) /= 0
	x `fhasAll` y = (x .&. y) == y
	flagsToInt = fromIntegral
	fempty = 0

instance CFlags a => Monoid a where
	mempty = fempty
	mappend = funion

-- | Parse libAV version numbers
fromVersionNum :: Int -> Version
fromVersionNum v =
	Version {
		versionBranch = map (flip (.&.) 0xFF . shift v) [(-16), (-8), 0],
		versionTags = []
	}

-- |Returns Nothing in the case the p == nullPtr
justPtr :: Ptr a -> Maybe (Ptr a)
justPtr p | p == nullPtr  = Nothing
          | otherwise = Just p


-- -*- haskell -*-
{-# LANGUAGE ForeignFunctionInterface, FlexibleContexts #-}

{- |

Description : Bindings to libavformat
Copyright   : (c) Callum Lowcay, 2015
License     : BSD3
Stability   : experimental

Bindings to dict.c

-}

module Media.FFMpeg.Util.Dict (
	av_dict_match_case,
	av_dict_ignore_suffix,
	av_dict_dont_overwrite,
	av_dict_append,

	AVDictionary,
	newAVDictionary,
	dictGet,
	dictCount,
	dictSet,
	dictSetInt,
	dictCopy,
	dictGetString
) where

#include "ffmpeg.h"

import Control.Applicative
import Control.Monad
import Control.Monad.Except
import Data.Bits
import Data.Int
import Data.Monoid
import Foreign.C.String
import Foreign.C.Types
import Foreign.ForeignPtr
import Foreign.Marshal.Alloc
import Foreign.Ptr
import Foreign.Storable

import Media.FFMpeg.Common

foreign import ccall "&b_free_dictionary" pb_free_dictionary :: FunPtr (Ptr (Ptr ()) -> IO ())

foreign import ccall "av_dict_get" av_dict_get :: Ptr () -> CString -> Ptr () -> CInt -> IO (Ptr ())
foreign import ccall "av_dict_count" av_dict_count :: Ptr () -> IO CInt
foreign import ccall "av_dict_set" av_dict_set :: Ptr (Ptr ()) -> CString -> CString -> CInt -> IO CInt
foreign import ccall "av_dict_set_int" av_dict_set_int :: Ptr (Ptr ()) -> CString -> Int64 -> CInt -> IO CInt
foreign import ccall "av_dict_copy" av_dict_copy :: Ptr (Ptr ()) -> Ptr () -> CInt -> IO ()
foreign import ccall "av_dict_get_string" av_dict_get_string :: Ptr () -> Ptr CString -> CChar -> CChar -> IO CInt

-- re-imported for local use
foreign import ccall "av_freep" av_freep :: Ptr a -> IO ()

-- | Flags
newtype DictFlag = DictFlag {unDictFlag :: CInt}
#{enum DictFlag, DictFlag,
	av_dict_match_case = AV_DICT_MATCH_CASE,
	av_dict_ignore_suffix = AV_DICT_IGNORE_SUFFIX,
	av_dict_dont_overwrite = AV_DICT_DONT_OVERWRITE,
	av_dict_append = AV_DICT_APPEND
}

instance Monoid DictFlag where
	mempty = DictFlag 0
	(DictFlag a) `mappend` (DictFlag b) = DictFlag$ a .|. b

instance CEnum DictFlag where
	fromCEnum = unDictFlag
	toCEnum = DictFlag

-- | AVDictionary type
newtype AVDictionary = AVDictionary (ForeignPtr (Ptr ()))

instance ExternalPointer AVDictionary where
	withThis (AVDictionary d) io = withForeignPtr d (io . castPtr)

-- | Allocate a new AVDictionary
newAVDictionary :: MonadIO m => m AVDictionary
newAVDictionary = liftIO$ do
	fp <- mallocForeignPtr
	withForeignPtr fp$ \p -> poke p nullPtr
	addForeignPtrFinalizer pb_free_dictionary fp
	return$ AVDictionary fp

-- | Get all the dictionary entries associated with a particular key
dictGet :: MonadIO m =>
	AVDictionary             -- ^the dictionary
	-> String                -- ^the key
	-> [DictFlag]            -- ^flags
	-> m [(String, String)]  -- ^a list of all the entries matching the key
dictGet dict key flags = liftIO$
	withThis dict$ \ppd ->
		withCString key$ \ckey -> do
			pd <- peek ppd
			let results = \prev -> do
				next <- av_dict_get pd ckey prev cflags
				if next == nullPtr then return [] else fmap (next :) (results next)

			rs <- results nullPtr
			forM rs $ \p -> do
				k <- peekCString =<< (#{peek AVDictionaryEntry, key} p :: IO CString)
				v <- peekCString =<< (#{peek AVDictionaryEntry, value} p :: IO CString)
				return (k, v)

	where cflags = fromCEnum$ mconcat flags

-- | Count the number of entries in a dictionary
dictCount :: MonadIO m => AVDictionary -> m Int
dictCount dict = liftIO$ do
	withThis dict$ \ppd -> do
		pd <- peek ppd
		fromIntegral <$> av_dict_count pd

-- | Set a dictionary entry
dictSet :: (MonadIO m, MonadError String m) =>
	AVDictionary           -- ^the dictionary to set
	-> (String, String)    -- ^the (key, value) pair to set
	-> [DictFlag]          -- ^flags
	-> m ()
dictSet dict (key, value) flags = do
	r <- liftIO$
		withThis dict$ \ppd ->
		withCString key$ \ckey ->  -- av_dict_set duplicates the keys, so this is safe
		withCString value$ \cvalue -> av_dict_set ppd ckey cvalue cflags

	when (r < 0)$ throwError$ "dictSet: failed with error code " ++ (show r)

	where cflags = fromCEnum$ mconcat flags

-- | Set a dictionary entry to a number, converting it to a string
dictSetInt :: (MonadIO m, MonadError String m) =>
	AVDictionary           -- ^the dictionary to set
	-> (String, Int64)     -- ^the (key, value) pair.  The value is converted to a decimal string
	-> [DictFlag]          -- ^flags
	-> m ()
dictSetInt dict (key, value) flags = do
	r <- liftIO$
		withThis dict$ \ppd ->
		withCString key$ \ckey ->  -- av_dict_set duplicates the keys, so this is safe
			av_dict_set_int ppd ckey value cflags

	when (r < 0)$ throwError$ "dictSetInt: failed with error code " ++ (show r)

	where cflags = fromCEnum$ mconcat flags

-- | Generate a copy of a dictionary
dictCopy :: MonadIO m =>
	AVDictionary             -- ^the dictionary to set
	-> [DictFlag]            -- ^flags
	-> m AVDictionary        -- ^a new dictionary that is a copy of the original
dictCopy src flags = do
	dst <- newAVDictionary
	liftIO$
		withThis dst$ \ppd ->
		withThis src$ \pps -> do
			ps <- peek pps
			av_dict_copy ppd ps cflags
	return dst
	where cflags = fromCEnum$ mconcat flags

-- | Get a string representation of a dictionary
dictGetString :: (MonadIO m, MonadError String m) =>
	AVDictionary     -- ^the dictionary to convert
	-> Char          -- ^character to separate keys and values
	-> Char          -- ^character to separate pairs of keys and values
	-> m String      -- ^a string representation of the dictionary
dictGetString dict keyValSep pairsSep = do
	pbuffer <- liftIO$ malloc
	liftIO$ poke pbuffer nullPtr
	r <- liftIO$
		withThis dict$ \ppd -> do
			pd <- peek ppd
			av_dict_get_string
				pd pbuffer
				(castCharToCChar keyValSep)
				(castCharToCChar pairsSep)

	if r < 0 then do
		liftIO$ do
			av_freep pbuffer
			free pbuffer
		throwError$ "dictGetString: failed with error code " ++ (show r)
	else liftIO$ do
		s <- peekCString =<< peek pbuffer
		liftIO$ do
			av_freep pbuffer
			free pbuffer
		return s

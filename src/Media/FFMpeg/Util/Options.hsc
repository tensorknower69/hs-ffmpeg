{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies #-}

{- |
 
Description : Bindings to libavutil
Copyright   : (c) Callum Lowcay, 2015
License     : BSD3
Stability   : experimental

Bindings to libavutil.

-}

module Media.FFMpeg.Util.Options (
	AVClass,
	OptionName,
	AVOption(..),
	AVOptionConst(..),
	ImageSize(..),

	getAVOption,
	decodeAVOption,
	decodeAVConst,
	parseDefaultValue,
	AVOptionValue(..),
	HasOptions(..),
	getAVOptions,
	getAVOptionConsts,
	getClassAVOptions,
	getClassAVOptionConsts,
	withOptionPtr,
	AVOptionType,

	getOption,
	getOptionString,
	setOption,
	setOptionString
) where

#include "ffmpeg.h"

import Control.Applicative
import Control.Monad
import Control.Monad.Except
import Data.Int
import Data.Maybe
import Data.Monoid
import Data.Ratio
import Data.Word
import Foreign.C.String
import Foreign.C.Types
import Foreign.Marshal.Alloc
import Foreign.Ptr
import Foreign.Storable
import qualified Data.ByteString as B

import Media.FFMpeg.Codec.Enums
import Media.FFMpeg.Internal.Common
import Media.FFMpeg.Util.ChannelLayout
import Media.FFMpeg.Util.Classes
import Media.FFMpeg.Util.Dict
import Media.FFMpeg.Util.Enums
import Media.FFMpeg.Util.Error

foreign import ccall "av_free" av_free :: Ptr a -> IO ()

foreign import ccall "av_opt_find" av_opt_find :: Ptr () -> CString -> CString -> CInt -> CInt -> IO (Ptr (AVOption a t))
foreign import ccall "av_opt_next" av_opt_next :: Ptr (Ptr (AVClass a)) -> Ptr (AVOption a t) -> IO (Ptr (AVOption a t))
foreign import ccall "av_opt_set" av_opt_set :: Ptr () -> CString -> CString -> CInt -> IO CInt
foreign import ccall "av_opt_get" av_opt_get :: Ptr () -> CString -> CInt -> Ptr CString -> IO CInt
foreign import ccall "av_opt_ptr" av_opt_ptr :: Ptr (Ptr (AVClass a)) -> Ptr (UnderlyingType a) -> CString -> IO (Ptr t)

foreign import ccall "av_opt_set_int" av_opt_set_int :: Ptr () -> CString -> Int64 -> CInt -> IO CInt
foreign import ccall "av_opt_set_double" av_opt_set_double :: Ptr () -> CString -> Double -> CInt -> IO CInt
foreign import ccall "b_av_opt_set_q" av_opt_set_q :: Ptr () -> CString -> CInt -> CInt -> CInt -> IO CInt
foreign import ccall "av_opt_set_bin" av_opt_set_bin :: Ptr () -> CString -> Ptr Word8 -> CInt -> CInt -> IO CInt
foreign import ccall "av_opt_set_image_size" av_opt_set_image_size :: Ptr () -> CString -> CInt -> CInt -> CInt -> IO CInt
foreign import ccall "av_opt_set_pixel_fmt" av_opt_set_pixel_fmt :: Ptr () -> CString -> CInt -> CInt -> IO CInt
foreign import ccall "av_opt_set_sample_fmt" av_opt_set_sample_fmt :: Ptr () -> CString -> CInt -> CInt -> IO CInt
foreign import ccall "b_av_opt_set_video_rate" av_opt_set_video_rate :: Ptr () -> CString -> CInt -> CInt -> CInt -> IO CInt
foreign import ccall "av_opt_set_channel_layout" av_opt_set_channel_layout :: Ptr () -> CString -> AVChannelLayout -> CInt -> IO CInt
foreign import ccall "av_opt_set_dict_val" av_opt_set_dict_val :: Ptr () -> CString -> Ptr AVDictionary -> CInt -> IO CInt

foreign import ccall "av_opt_get_int" av_opt_get_int :: Ptr () -> CString -> CInt -> Ptr Int64 -> IO CInt
foreign import ccall "av_opt_get_double" av_opt_get_double :: Ptr () -> CString -> CInt -> Ptr Double -> IO CInt
foreign import ccall "av_opt_get_q" av_opt_get_q :: Ptr () -> CString -> CInt -> Ptr AVRational -> IO CInt
foreign import ccall "av_opt_get_image_size" av_opt_get_image_size :: Ptr () -> CString -> CInt -> Ptr CInt -> Ptr CInt -> IO CInt
foreign import ccall "av_opt_get_pixel_fmt" av_opt_get_pixel_fmt :: Ptr () -> CString -> CInt -> Ptr CInt -> IO CInt
foreign import ccall "av_opt_get_sample_fmt" av_opt_get_sample_fmt :: Ptr () -> CString -> CInt -> Ptr CInt -> IO CInt
foreign import ccall "b_av_opt_get_video_rate" av_opt_get_video_rate :: Ptr () -> CString -> CInt -> Ptr CInt -> Ptr CInt -> IO CInt
foreign import ccall "av_opt_get_channel_layout" av_opt_get_channel_layout :: Ptr () -> CString -> CInt -> Ptr AVChannelLayout -> IO CInt
foreign import ccall "av_opt_get_dict_val" av_opt_get_dict_val :: Ptr () -> CString -> CInt -> Ptr (Ptr AVDictionary) -> IO CInt

-- | AVClass struct
newtype AVClass a = AVClass (Ptr (AVClass a))

-- | Type for option names
newtype OptionName a t = OptionName {unOptionName :: String} deriving (Eq, Show)
instance ExternalPointer (OptionName a t) where
	type UnderlyingType (OptionName a t) = CChar
	withThis (OptionName s) = withThis s

-- | AVOption struct
data AVOption a t = AVOption {
		option_name :: OptionName a t,
		option_help :: String,
		option_type :: AVOptType,
		option_default :: Maybe t,
		option_flags :: AVOptionFlags,
		option_unit :: String
	}

-- | Constants encoded in an AVOption struct
data AVOptionConst a t = AVOptionConst {
		const_name :: String,
		const_option :: OptionName a t,
		const_help :: String,
		const_type :: AVOptType,
		const_value :: t
	}

-- | Get the named AVOption from an object
getAVOption :: (MonadIO m, HasOptions a) =>
	OptionName a t                 -- ^ Name of the option to search for
	-> Bool                        -- ^ True to search children
	-> a                           -- ^ Object to search
	-> m (Maybe (AVOption a AVOptionValue))
getAVOption (OptionName name) searchChildren obj = do
	popt <-
		withThis obj$ \pobj ->
		liftIO.withCString name$ \pname ->
			av_opt_find (castPtr pobj) pname nullPtr (-1) sflags
	
	if popt == nullPtr then return Nothing else do
		r <- decodeAVOption popt
		return$ Just r

	where sflags = fromCEnum$
		if searchChildren then av_opt_search_children else mempty

-- | Get an AVOption out of a pointer
decodeAVOption :: MonadIO m => Ptr (AVOption a t) -> m (AVOption a AVOptionValue)
decodeAVOption po = liftIO$ do
	_name <- OptionName <$> (peekCString =<< #{peek AVOption, name} po)
	_help <- peekCString =<< #{peek AVOption, help} po
	_type <- #{peek AVOption, type} po
	_flags <- #{peek AVOption, flags} po
	_unit <- peekCString =<< #{peek AVOption, unit} po

	_default <- parseDefaultValue po _type

	return$ AVOption
		_name _help
		_type _default
		_flags _unit

-- | Decode an AVOptionConst out of a pointer
decodeAVConst :: MonadIO m => AVOption a t -> Ptr (AVOption a AVOptionValue) -> m (Maybe (AVOptionConst a AVOptionValue))
decodeAVConst opt po = do
	_type <- liftIO$ #{peek AVOption, type} po
	if _type /= av_opt_type_const then return Nothing
	else liftIO$ do
		_name <- peekCString =<< #{peek AVOption, name} po
		_help <- peekCString =<< #{peek AVOption, help} po
		_option <- OptionName <$> (peekCString =<< #{peek AVOption, unit} po)

		_value <- parseDefaultValue po (option_type opt)
		case _value of
			Nothing -> return Nothing
			Just v ->
				return.Just$ AVOptionConst
					_name _option
					_help (option_type opt) v

-- | Parse the default value field
parseDefaultValue :: MonadIO m => Ptr (AVOption a t) -> AVOptType -> m (Maybe AVOptionValue)
parseDefaultValue pOpt t = liftIO$ case t of
	av_opt_type_flags ->
		Just . AVOptionFlags <$> #{peek AVOption, default_val} pOpt
	av_opt_type_int ->
		Just . AVOptionInt <$> #{peek AVOption, default_val} pOpt
	av_opt_type_int64 ->
		Just . AVOptionInt64 <$> #{peek AVOption, default_val} pOpt
	av_opt_type_double ->
		Just . AVOptionDouble <$> #{peek AVOption, default_val} pOpt
	av_opt_type_float ->
		Just . AVOptionFloat <$> #{peek AVOption, default_val} pOpt
	av_opt_type_string ->
		Just . AVOptionString <$> (peekCString =<< #{peek AVOption, default_val} pOpt)
	av_opt_type_rational ->
		Just . AVOptionRational . fromAVRational <$> #{peek AVOption, default_val} pOpt
	av_opt_type_pixel_fmt ->
		Just . AVOptionPixelFormat <$> #{peek AVOption, default_val} pOpt
	av_opt_type_sample_fmt ->
		Just . AVOptionSampleFormat <$> #{peek AVOption, default_val} pOpt
	av_opt_type_video_rate ->
		Just . AVOptionVideoRate . fromAVRational <$> #{peek AVOption, default_val} pOpt
	av_opt_type_channel_layout ->
		Just . AVOptionChannelLayout <$> #{peek AVOption, default_val} pOpt
	_ -> return Nothing

-- | Value for an option where we don't know the type until runtime
data AVOptionValue =
	AVOptionFlags CInt |
	AVOptionInt CInt |
	AVOptionInt64 Int64 |
	AVOptionDouble Double |
	AVOptionFloat Float |
	AVOptionString String |
	AVOptionRational Rational |
	AVOptionBinary B.ByteString |
	AVOptionDict AVDictionary |
	AVOptionImageSize ImageSize |
	AVOptionPixelFormat PixelFormat |
	AVOptionSampleFormat AVSampleFormat |
	AVOptionVideoRate Rational |
	AVOptionDuration Int64 |       -- what is the proper type for this option?
	AVOptionColor String |         -- what is the proper type for this option?
	AVOptionChannelLayout AVChannelLayout

-- | Class of objects that have options
class ExternalPointer a => HasOptions a where
	withClass :: MonadIO m => a -> (Ptr (Ptr (AVClass a)) -> m b) -> m b

-- | Enumerate the options of an object
getAVOptions :: (MonadIO m, HasOptions a) => a -> m [AVOption a AVOptionValue]
getAVOptions obj = withClass obj getClassAVOptions

-- | Enumerate the constants of an option
getAVOptionConsts :: (MonadIO m, HasOptions a) => a -> AVOption a t -> m [AVOptionConst a AVOptionValue]
getAVOptionConsts obj opt = withClass obj$ \pclass -> getClassAVOptionConsts pclass opt

-- | Enumerate the options of a class
getClassAVOptions :: MonadIO m => Ptr (Ptr (AVClass a)) -> m [AVOption a AVOptionValue]
getClassAVOptions pclass = mapM decodeAVOption =<< (allAVOptions pclass)

-- | Enumerate the constants of a class
getClassAVOptionConsts :: forall a t m. MonadIO m =>
	Ptr (Ptr (AVClass a)) -> AVOption a t -> m [AVOptionConst a AVOptionValue]
getClassAVOptionConsts pclass opt = do
	(return.catMaybes) =<< mapM (decodeAVConst opt) =<< filterM isConstOfOpt =<< allAVOptions pclass

	where
		isConstOfOpt :: Ptr (AVOption a t2) -> m Bool
		isConstOfOpt popt = do
			_type <- liftIO$ #{peek AVOption, type} popt
			if _type /= av_opt_type_const then return False else do
				unit <- liftIO$ peekCString =<< #{peek AVOption, unit} popt
				return$ unit == (unOptionName$ option_name opt)

-- | Get pointers to all the AVOptions associated with a class
allAVOptions :: MonadIO m => Ptr (Ptr (AVClass a)) -> m [Ptr (AVOption a AVOptionValue)]
allAVOptions pclass = liftIO$ allAVOptions nullPtr
	where allAVOptions' prev = do
		next <- av_opt_next pclass prev
		if next == nullPtr then return [] else (next:) <$> allAVOptions' next

-- | Execute an action on a pointer to a named field
withOptionPtr :: (MonadIO m, HasOptions a) => OptionName a t -> a -> (Maybe (Ptr t) -> m b) -> m b
withOptionPtr (OptionName name) obj action = do
	pfield <- liftIO$
		withClass obj$ \pclass ->
		withThis obj$ \pobj ->
		withCString name$ \pname ->
			av_opt_ptr pclass pobj pname
	
	if pfield == nullPtr then action Nothing else action$ Just pfield

instance HasOptions AVCodecContext where
	withClass obj action = withThis obj$ \pobj -> action (castPtr pobj)

instance HasOptions AVFormatContext where
	withClass obj action = withThis obj$ \pobj -> action (castPtr pobj)

class AVOptionType t where
	getOption0 :: (MonadIO m, Applicative m, HasOptions a) => a -> CString -> AVOptionSearchFlags -> m (Either CInt t)
	setOption0 :: (MonadIO m, Applicative m, HasOptions a) => a -> CString -> t -> AVOptionSearchFlags -> m CInt

getOptionType :: (MonadIO m, Applicative m, HasOptions a) => a -> CString -> AVOptionSearchFlags -> m (Maybe AVOptType)
getOptionType obj pname flags =
	withThis obj$ \pobj -> do
		r <- liftIO$ av_opt_find (castPtr pobj) pname nullPtr 0 (fromCEnum flags)
		if r == nullPtr then return Nothing else liftIO$ Just . toCEnum <$> #{peek AVOption, type} r

instance AVOptionType AVOptionValue where
	getOption0 obj pname flags = do
		mt <- getOptionType obj pname flags
		case mt of
			Nothing -> return.(Left).fromCEnum$ averror_option_not_found
			Just t -> case t of
				av_opt_type_flags ->
					fmap AVOptionFlags <$> getOption0 obj pname flags
				av_opt_type_int ->
					fmap AVOptionInt <$> getOption0 obj pname flags
				av_opt_type_int64 ->
					fmap AVOptionInt64 <$> getOption0 obj pname flags
				av_opt_type_double ->
					fmap AVOptionDouble <$> getOption0 obj pname flags
				av_opt_type_float ->
					fmap AVOptionFloat <$> getOption0 obj pname flags
				av_opt_type_string ->
					fmap AVOptionString <$> getOption0 obj pname flags
				av_opt_type_rational ->
					fmap (AVOptionRational . fromAVRational) <$> getOption0 obj pname flags
				av_opt_type_binary ->
					fmap AVOptionBinary <$> getOption0 obj pname flags
				av_opt_type_dict ->
					fmap AVOptionDict <$> getOption0 obj pname flags
				av_opt_type_image_size ->
					fmap AVOptionImageSize <$> getOption0 obj pname flags
				av_opt_type_pixel_fmt ->
					fmap AVOptionPixelFormat <$> getOption0 obj pname flags
				av_opt_type_sample_fmt ->
					fmap AVOptionSampleFormat <$> getOption0 obj pname flags
				av_opt_type_video_rate ->
					fmap (AVOptionVideoRate . fromAVRational) <$> getOption0 obj pname flags
				av_opt_type_duration ->
					fmap AVOptionDuration <$> getOption0 obj pname flags
				av_opt_type_color ->
					fmap AVOptionColor <$> getOption0 obj pname flags
				av_opt_type_channel_layout ->
					fmap AVOptionChannelLayout <$> getOption0 obj pname flags
				_ -> return.(Left).fromCEnum$ averror_option_not_found
	
	setOption0 obj pname val flags = do
		case val of
			AVOptionFlags v -> setOption0 obj pname v flags
			AVOptionInt v -> setOption0 obj pname v flags
			AVOptionInt64 v -> setOption0 obj pname v flags
			AVOptionDouble v -> setOption0 obj pname v flags
			AVOptionFloat v -> setOption0 obj pname v flags
			AVOptionString v -> setOption0 obj pname v flags
			AVOptionRational v -> setOption0 obj pname (AVRational v) flags
			AVOptionBinary v -> setOption0 obj pname v flags
			AVOptionDict v -> setOption0 obj pname v flags
			AVOptionImageSize v -> setOption0 obj pname v flags
			AVOptionPixelFormat v -> setOption0 obj pname v flags
			AVOptionSampleFormat v -> setOption0 obj pname v flags
			AVOptionVideoRate v -> setOption0 obj pname (AVRational v) flags
			AVOptionDuration v -> setOption0 obj pname v flags
			AVOptionColor v -> setOption0 obj pname v flags
			AVOptionChannelLayout v -> setOption0 obj pname v flags

instance AVOptionType CInt where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get_int (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else do
				out <- peek pout
				return.Right$ fromIntegral out

	setOption0 obj pname v flags = withThis obj$ \pobj ->
		liftIO$ av_opt_set_int (castPtr pobj) pname (fromIntegral v) (fromCEnum flags)

instance AVOptionType Int where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get_int (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else (Right).fromIntegral <$> peek pout

	setOption0 obj pname v flags = withThis obj$ \pobj ->
		liftIO$ av_opt_set_int (castPtr pobj) pname (fromIntegral v) (fromCEnum flags)

instance AVOptionType Int64 where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get_int (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else (Right).fromIntegral <$> peek pout

	setOption0 obj pname v flags = withThis obj$ \pobj ->
		liftIO$ av_opt_set_int (castPtr pobj) pname v (fromCEnum flags)

instance AVOptionType Double where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get_double (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else Right <$> peek pout

	setOption0 obj pname v flags = withThis obj$ \pobj ->
		liftIO$ av_opt_set_double (castPtr pobj) pname v (fromCEnum flags)

instance AVOptionType Float where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get_double (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else (Right).realToFrac <$> peek pout

	setOption0 obj pname v flags = withThis obj$ \pobj ->
		liftIO$ av_opt_set_double (castPtr pobj) pname (realToFrac v) (fromCEnum flags)

instance AVOptionType [Char] where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else do
				ps <- peek pout
				s <- peekCString ps
				av_free ps
				return$ Right s

	setOption0 obj pname v flags = withThis obj$ \pobj ->
		liftIO.withCString v$ \pv -> av_opt_set (castPtr pobj) pname pv (fromCEnum flags)

instance AVOptionType AVRational where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get_q (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else do
				out <- peek pout
				return$ Right out
		
	setOption0 obj pname v flags =
		let
			rat = toRational v
			num = numerator rat
			den = denominator rat
		in withThis obj$ \pobj -> liftIO$ av_opt_set_q
			(castPtr pobj) pname (fromIntegral num) (fromIntegral den) (fromCEnum flags)

instance AVOptionType B.ByteString where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else do
				ps <- peek pout
				s <- B.packCString ps
				av_free ps
				return$ Right s

	setOption0 obj pname v flags =
		withThis obj$ \pobj ->
		liftIO.(B.useAsCStringLen) v$ \(pv, len) ->
			av_opt_set_bin (castPtr pobj) pname (castPtr pv) (fromIntegral len) (fromCEnum flags)

instance AVOptionType AVDictionary where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \ppdict -> do
			r <- av_opt_get_dict_val (castPtr pobj) pname (fromCEnum flags) ppdict
			if r /= 0 then return$ Left r else do
				pdict <- peek ppdict
				s <- unsafeDictCopyFromPtr pdict []
				av_dict_free ppdict
				return$ Right s

	setOption0 obj pname d flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \ppdict -> do
			r <- av_opt_get_dict_val (castPtr pobj) pname (fromCEnum flags) ppdict

			when (r /= 0)$ av_dict_free ppdict
			withThis d$ \ppsrc -> do
				psrc <- peek ppsrc
				av_dict_copy ppdict psrc 0

			pdict <- peek ppdict
			av_opt_set_dict_val (castPtr pobj) pname pdict (fromCEnum flags)

instance AVOptionType ImageSize where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO$
			alloca$ \pw ->
			alloca$ \ph -> do
				r <- av_opt_get_image_size (castPtr pobj) pname (fromCEnum flags) pw ph
				if r /= 0 then return$ Left r else
					Right <$> (ImageSize <$>
						(fromIntegral <$> peek pw) <*>
						(fromIntegral <$> peek ph))

	setOption0 obj pname (ImageSize w h) flags = withThis obj$ \pobj ->
		liftIO$ av_opt_set_image_size (castPtr pobj) pname
			(fromIntegral w) (fromIntegral h) (fromCEnum flags)

instance AVOptionType PixelFormat where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get_pixel_fmt (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else Right . toCEnum <$> peek pout

	setOption0 obj pname v flags = withThis obj$ \pobj ->
		liftIO$ av_opt_set_pixel_fmt (castPtr pobj) pname (fromCEnum v) (fromCEnum flags)

instance AVOptionType AVSampleFormat where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get_sample_fmt (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else Right . toCEnum <$> peek pout

	setOption0 obj pname v flags = withThis obj$ \pobj ->
		liftIO$ av_opt_set_sample_fmt (castPtr pobj) pname (fromCEnum v) (fromCEnum flags)

instance AVOptionType AVChannelLayout where
	getOption0 obj pname flags =
		withThis obj$ \pobj ->
		liftIO.alloca$ \pout -> do
			r <- av_opt_get_channel_layout (castPtr pobj) pname (fromCEnum flags) pout
			if r /= 0 then return$ Left r else Right <$> peek pout

	setOption0 obj pname v flags = withThis obj$ \pobj ->
		liftIO$ av_opt_set_channel_layout (castPtr pobj) pname v (fromCEnum flags)

-- | Get the value of an option
getOption :: (MonadIO m, Applicative m, MonadError String m, HasOptions a, AVOptionType t) =>
	AVOption a t -> a -> m t
getOption option obj = do
	r <- withThis (option_name option)$ \pname ->
		getOption0 obj pname av_opt_search_children

	case r of
		Left err -> throwError$
			"getOption: av_opt_get_ failed with error code " ++ (show err)
		Right v -> return v

-- | Get the value of an option as a string
getOptionString :: (MonadIO m, MonadError String m, HasOptions a) => AVOption a t -> a -> m String
getOptionString opt obj =	do
	(r, s) <-
		withThis (option_name opt)$ \pname ->
		withThis obj$ \pobj ->
		liftIO.alloca$ \ppout -> do
			r <- av_opt_get (castPtr pobj) pname (fromCEnum av_opt_search_children) ppout
			if (r /= 0) then return (r, "") else do
				pout <- peek ppout
				outs <- peekCString pout
				av_free pout
				return (r, outs)

	when (r /= 0)$ throwError$
		"getOptionString: av_opt_get failed with error code " ++ (show r)
	return s

-- | Set the value of an option
setOption :: (MonadIO m, MonadError String m, Applicative m, HasOptions a, AVOptionType t) =>
	AVOption a t -> a -> t -> m ()
setOption option obj val =
	withThis (option_name option)$ \pname -> do
		r <- setOption0 obj pname val av_opt_search_children

		when (r /= 0)$ throwError$
			"setOption: av_opt_set_ failed with error code " ++ (show r)

-- | Set the value of a string
setOptionString :: (MonadIO m, MonadError String m, HasOptions a) => AVOption a t -> a -> String -> m ()
setOptionString opt obj v =
	withThis (option_name opt)$ \pname ->
	withThis v$ \pval ->
	withThis obj$ \pobj -> do
		r <- liftIO$ av_opt_set (castPtr pobj) pname pval (fromCEnum av_opt_search_children)

		when (r /= 0)$ throwError$
			"setOptionString: av_opt_set failed with error code " ++ (show r)

data ImageSize = ImageSize Int Int deriving (Eq, Show)
instance Storable ImageSize where
	sizeOf _ = #{size int} * 2
	alignment _ = 8
	peek ptr = do
		w <- peek (castPtr ptr) :: IO CInt
		h <- peek$ ptr `plusPtr` #{size int} :: IO CInt
		return$ ImageSize (fromIntegral w) (fromIntegral h)
	poke ptr (ImageSize w h) = do
		poke (castPtr ptr) (fromIntegral w :: CInt)
		poke (ptr `plusPtr` #{size int}) (fromIntegral h :: CInt)

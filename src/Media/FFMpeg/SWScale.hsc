-- -*- haskell -*-
{-# LANGUAGE ForeignFunctionInterface #-}

{- |
	Module 'Media.FFMpeg.SWScale' implements bindings to SWScale library

	(c) 2009 Vasyl Pasternak
-}

module Media.FFMpeg.SWScale (
	libSWScaleVersion,
	module Media.FFMpeg.SWScaleEnums_,
	SwsContext,
	getContext,
	scale
) where

#include "ffmpeg.h"

import Control.Applicative
import Data.Int
import Data.Monoid
import Data.Version
import Foreign.C.Types
import Foreign.ForeignPtr
import Foreign.Marshal.Error
import Foreign.Ptr

import Media.FFMpeg.Common
import Media.FFMpeg.SWScaleEnums_
import Media.FFMpeg.Util

-- | Which version of libswscale are we using?
libSWScaleVersion :: Version
libSWScaleVersion = fromVersionNum #{const LIBSWSCALE_VERSION_INT}

-- | SwsContext struct
newtype SwsContext = SwsContext (ForeignPtr SwsContext)

instance ExternalPointer SwsContext where
    withThis (SwsContext ctx) io = withForeignPtr ctx (io . castPtr)

-- | Get SWScale context
getContext ::
	(Int, Int, PixelFormat) ->
	(Int, Int, PixelFormat) ->
	[ScaleAlgorithm] -> IO SwsContext
getContext  (srcW, srcH, srcPf) (dstW, dstH, dstPf) flags = do
	ret <- throwIf (==nullPtr)
		(\_ -> "getContext: failed to create SWScale context")
		(_sws_getContext (cFromInt srcW) (cFromInt srcH) (fromCEnum srcPf)
			(cFromInt dstW) (cFromInt dstH) (fromCEnum dstPf)
			(fromCEnum.mconcat$ flags) nullPtr nullPtr nullPtr)
	(SwsContext . castForeignPtr) <$> newFinForeignPtr _sws_freeContext ret

foreign import ccall "sws_getContext" _sws_getContext :: 
	CInt -> CInt -> CInt -> 
	CInt -> CInt -> CInt ->
	CInt -> Ptr () -> Ptr () -> Ptr () -> IO (Ptr ())

foreign import ccall "sws_freeContext" _sws_freeContext :: Ptr () -> IO ()

-- | scale - a scale function
scale :: SwsContext -> Ptr () -> Ptr () -> Int -> Int -> Ptr () -> Ptr () -> IO ()
scale ctx srcSlice srcStride srcSliceY srcSliceH dstSlice dstStride =
	withThis ctx $ \ctx' -> do
		_sws_scale ctx' srcSlice srcStride 
			(cFromInt srcSliceY) (cFromInt srcSliceH)
			dstSlice dstStride
		return ()

foreign import ccall "sws_scale" _sws_scale ::
	Ptr () -> Ptr () -> Ptr () -> CInt -> CInt -> Ptr () -> Ptr () -> IO CInt


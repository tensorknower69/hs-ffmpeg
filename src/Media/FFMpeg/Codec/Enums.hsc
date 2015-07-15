---- -*- haskell -*- 
{-# LANGUAGE ForeignFunctionInterface #-}

{- |

Description : Enumerations for libavcodec
Copyright   : (c) Vasyl Pasternak, 2009
                  Callum Lowcay, 2015
License     : BSD3
Stability   : experimental

Enumerations for libavcodec.

-}

module Media.FFMpeg.Codec.Enums (
	AVMediaType,
	AVSampleFormat,
	AVCodecId,
	avmedia_type_unknown,
	avmedia_type_video,
	avmedia_type_audio,
	avmedia_type_data,
	avmedia_type_subtitle,
	avmedia_type_attachment,
	avmedia_type_nb,
	av_sample_fmt_none,
	av_sample_fmt_u8,
	av_sample_fmt_s16,
	av_sample_fmt_s32,
	av_sample_fmt_flt,
	av_sample_fmt_dbl,
	av_sample_fmt_u8p,
	av_sample_fmt_s16p,
	av_sample_fmt_s32p,
	av_sample_fmt_fltp,
	av_sample_fmt_dblp,
	av_sample_fmt_nb,
	av_codec_id_none,
	av_codec_id_mpeg1video,
	av_codec_id_mpeg2video,
	av_codec_id_h261,
	av_codec_id_h263,
	av_codec_id_rv10,
	av_codec_id_rv20,
	av_codec_id_mjpeg,
	av_codec_id_mjpegb,
	av_codec_id_ljpeg,
	av_codec_id_sp5x,
	av_codec_id_jpegls,
	av_codec_id_mpeg4,
	av_codec_id_rawvideo,
	av_codec_id_msmpeg4v1,
	av_codec_id_msmpeg4v2,
	av_codec_id_msmpeg4v3,
	av_codec_id_wmv1,
	av_codec_id_wmv2,
	av_codec_id_h263p,
	av_codec_id_h263i,
	av_codec_id_flv1,
	av_codec_id_svq1,
	av_codec_id_svq3,
	av_codec_id_dvvideo,
	av_codec_id_huffyuv,
	av_codec_id_cyuv,
	av_codec_id_h264,
	av_codec_id_indeo3,
	av_codec_id_vp3,
	av_codec_id_theora,
	av_codec_id_asv1,
	av_codec_id_asv2,
	av_codec_id_ffv1,
	av_codec_id_4xm,
	av_codec_id_vcr1,
	av_codec_id_cljr,
	av_codec_id_mdec,
	av_codec_id_roq,
	av_codec_id_interplay_video,
	av_codec_id_xan_wc3,
	av_codec_id_xan_wc4,
	av_codec_id_rpza,
	av_codec_id_cinepak,
	av_codec_id_ws_vqa,
	av_codec_id_msrle,
	av_codec_id_msvideo1,
	av_codec_id_idcin,
	av_codec_id_8bps,
	av_codec_id_smc,
	av_codec_id_flic,
	av_codec_id_truemotion1,
	av_codec_id_vmdvideo,
	av_codec_id_mszh,
	av_codec_id_zlib,
	av_codec_id_qtrle,
	av_codec_id_tscc,
	av_codec_id_ulti,
	av_codec_id_qdraw,
	av_codec_id_vixl,
	av_codec_id_qpeg,
	av_codec_id_png,
	av_codec_id_ppm,
	av_codec_id_pbm,
	av_codec_id_pgm,
	av_codec_id_pgmyuv,
	av_codec_id_pam,
	av_codec_id_ffvhuff,
	av_codec_id_rv30,
	av_codec_id_rv40,
	av_codec_id_vc1,
	av_codec_id_wmv3,
	av_codec_id_loco,
	av_codec_id_wnv1,
	av_codec_id_aasc,
	av_codec_id_indeo2,
	av_codec_id_fraps,
	av_codec_id_truemotion2,
	av_codec_id_bmp,
	av_codec_id_cscd,
	av_codec_id_mmvideo,
	av_codec_id_zmbv,
	av_codec_id_avs,
	av_codec_id_smackvideo,
	av_codec_id_nuv,
	av_codec_id_kmvc,
	av_codec_id_flashsv,
	av_codec_id_cavs,
	av_codec_id_jpeg2000,
	av_codec_id_vmnc,
	av_codec_id_vp5,
	av_codec_id_vp6,
	av_codec_id_vp6f,
	av_codec_id_targa,
	av_codec_id_dsicinvideo,
	av_codec_id_tiertexseqvideo,
	av_codec_id_tiff,
	av_codec_id_gif,
	av_codec_id_dxa,
	av_codec_id_dnxhd,
	av_codec_id_thp,
	av_codec_id_sgi,
	av_codec_id_c93,
	av_codec_id_bethsoftvid,
	av_codec_id_ptx,
	av_codec_id_txd,
	av_codec_id_vp6a,
	av_codec_id_amv,
	av_codec_id_vb,
	av_codec_id_pcx,
	av_codec_id_sunrast,
	av_codec_id_indeo4,
	av_codec_id_indeo5,
	av_codec_id_mimic,
	av_codec_id_rl2,
	av_codec_id_escape124,
	av_codec_id_dirac,
	av_codec_id_bfi,
	av_codec_id_cmv,
	av_codec_id_motionpixels,
	av_codec_id_tgv,
	av_codec_id_tgq,
	av_codec_id_tqi,
	av_codec_id_aura,
	av_codec_id_aura2,
	av_codec_id_v210x,
	av_codec_id_tmv,
	av_codec_id_v210,
	av_codec_id_dpx,
	av_codec_id_mad,
	av_codec_id_frwu,
	av_codec_id_flashsv2,
	av_codec_id_cdgraphics,
	av_codec_id_r210,
	av_codec_id_anm,
	av_codec_id_binkvideo,
	av_codec_id_iff_ilbm,
	av_codec_id_iff_byterun1,
	av_codec_id_kgv1,
	av_codec_id_yop,
	av_codec_id_vp8,
	av_codec_id_pictor,
	av_codec_id_ansi,
	av_codec_id_a64_multi,
	av_codec_id_a64_multi5,
	av_codec_id_r10k,
	av_codec_id_mxpeg,
	av_codec_id_lagarith,
	av_codec_id_prores,
	av_codec_id_jv,
	av_codec_id_dfa,
	av_codec_id_wmv3image,
	av_codec_id_vc1image,
	av_codec_id_utvideo,
	av_codec_id_bmv_video,
	av_codec_id_vble,
	av_codec_id_dxtory,
	av_codec_id_v410,
	av_codec_id_xwd,
	av_codec_id_cdxl,
	av_codec_id_xbm,
	av_codec_id_zerocodec,
	av_codec_id_mss1,
	av_codec_id_msa1,
	av_codec_id_tscc2,
	av_codec_id_mts2,
	av_codec_id_cllc,
	av_codec_id_mss2,
	av_codec_id_vp9,
	av_codec_id_aic,
	av_codec_id_escape130_deprecated,
	av_codec_id_g2m_deprecated,
	av_codec_id_webp_deprecated,
	av_codec_id_hnm4_video,
	av_codec_id_hevc_deprecated,
	av_codec_id_fic,
	av_codec_id_alias_pix,
	av_codec_id_brender_pix_deprecated,
	av_codec_id_paf_video_deprecated,
	av_codec_id_exr_deprecated,
	av_codec_id_vp7_deprecated,
	av_codec_id_sanm_deprecated,
	av_codec_id_sgirle_deprecated,
	av_codec_id_mvc1_deprecated,
	av_codec_id_mvc2_deprecated,
	av_codec_id_brender_pix,
	av_codec_id_y41p,
	av_codec_id_escape130,
	av_codec_id_exr,
	av_codec_id_avrp,
	av_codec_id_012v,
	av_codec_id_g2m,
	av_codec_id_avui,
	av_codec_id_ayuv,
	av_codec_id_targa_y216,
	av_codec_id_v308,
	av_codec_id_v408,
	av_codec_id_yuv4,
	av_codec_id_sanm,
	av_codec_id_paf_video,
	av_codec_id_avrn,
	av_codec_id_cpia,
	av_codec_id_xface,
	av_codec_id_sgirle,
	av_codec_id_mvc1,
	av_codec_id_mvc2,
	av_codec_id_snow,
	av_codec_id_webp,
	av_codec_id_smvjpeg,
	av_codec_id_hevc,
	av_codec_id_h265,
	av_codec_id_vp7,
	av_codec_id_apng,
	av_codec_id_first_audio,
	av_codec_id_pcm_s16le,
	av_codec_id_pcm_s16be,
	av_codec_id_pcm_u16le,
	av_codec_id_pcm_u16be,
	av_codec_id_pcm_s8,
	av_codec_id_pcm_u8,
	av_codec_id_pcm_mulaw,
	av_codec_id_pcm_alaw,
	av_codec_id_pcm_s32le,
	av_codec_id_pcm_s32be,
	av_codec_id_pcm_u32le,
	av_codec_id_pcm_u32be,
	av_codec_id_pcm_s24le,
	av_codec_id_pcm_s24be,
	av_codec_id_pcm_u24le,
	av_codec_id_pcm_u24be,
	av_codec_id_pcm_s24daud,
	av_codec_id_pcm_zork,
	av_codec_id_pcm_s16le_planar,
	av_codec_id_pcm_dvd,
	av_codec_id_pcm_f32be,
	av_codec_id_pcm_f32le,
	av_codec_id_pcm_f64be,
	av_codec_id_pcm_f64le,
	av_codec_id_pcm_bluray,
	av_codec_id_pcm_lxf,
	av_codec_id_s302m,
	av_codec_id_pcm_s8_planar,
	av_codec_id_pcm_s24le_planar_deprecated,
	av_codec_id_pcm_s32le_planar_deprecated,
	av_codec_id_pcm_s24le_planar,
	av_codec_id_pcm_s32le_planar,
	av_codec_id_pcm_s16be_planar,
	av_codec_id_adpcm_ima_qt,
	av_codec_id_adpcm_ima_wav,
	av_codec_id_adpcm_ima_dk3,
	av_codec_id_adpcm_ima_dk4,
	av_codec_id_adpcm_ima_ws,
	av_codec_id_adpcm_ima_smjpeg,
	av_codec_id_adpcm_ms,
	av_codec_id_adpcm_4xm,
	av_codec_id_adpcm_xa,
	av_codec_id_adpcm_adx,
	av_codec_id_adpcm_ea,
	av_codec_id_adpcm_g726,
	av_codec_id_adpcm_ct,
	av_codec_id_adpcm_swf,
	av_codec_id_adpcm_yamaha,
	av_codec_id_adpcm_sbpro_4,
	av_codec_id_adpcm_sbpro_3,
	av_codec_id_adpcm_sbpro_2,
	av_codec_id_adpcm_thp,
	av_codec_id_adpcm_ima_amv,
	av_codec_id_adpcm_ea_r1,
	av_codec_id_adpcm_ea_r3,
	av_codec_id_adpcm_ea_r2,
	av_codec_id_adpcm_ima_ea_sead,
	av_codec_id_adpcm_ima_ea_eacs,
	av_codec_id_adpcm_ea_xas,
	av_codec_id_adpcm_ea_maxis_xa,
	av_codec_id_adpcm_ima_iss,
	av_codec_id_adpcm_g722,
	av_codec_id_adpcm_ima_apc,
	av_codec_id_adpcm_vima_deprecated,
	av_codec_id_adpcm_vima,
	av_codec_id_adpcm_afc,
	av_codec_id_adpcm_ima_oki,
	av_codec_id_adpcm_dtk,
	av_codec_id_adpcm_ima_rad,
	av_codec_id_adpcm_g726le,
	av_codec_id_amr_nb,
	av_codec_id_amr_wb,
	av_codec_id_ra_144,
	av_codec_id_ra_288,
	av_codec_id_roq_dpcm,
	av_codec_id_interplay_dpcm,
	av_codec_id_xan_dpcm,
	av_codec_id_sol_dpcm,
	av_codec_id_mp2,
	av_codec_id_mp3,
	av_codec_id_aac,
	av_codec_id_ac3,
	av_codec_id_dts,
	av_codec_id_vorbis,
	av_codec_id_dvaudio,
	av_codec_id_wmav1,
	av_codec_id_wmav2,
	av_codec_id_mace3,
	av_codec_id_mace6,
	av_codec_id_vmdaudio,
	av_codec_id_flac,
	av_codec_id_mp3adu,
	av_codec_id_mp3on4,
	av_codec_id_shorten,
	av_codec_id_alac,
	av_codec_id_westwood_snd1,
	av_codec_id_gsm,
	av_codec_id_qdm2,
	av_codec_id_cook,
	av_codec_id_truespeech,
	av_codec_id_tta,
	av_codec_id_smackaudio,
	av_codec_id_qcelp,
	av_codec_id_wavpack,
	av_codec_id_dsicinaudio,
	av_codec_id_imc,
	av_codec_id_musepack7,
	av_codec_id_mlp,
	av_codec_id_gsm_ms,
	av_codec_id_atrac3,
	av_codec_id_ape,
	av_codec_id_nellymoser,
	av_codec_id_musepack8,
	av_codec_id_speex,
	av_codec_id_wmavoice,
	av_codec_id_wmapro,
	av_codec_id_wmalossless,
	av_codec_id_atrac3p,
	av_codec_id_eac3,
	av_codec_id_sipr,
	av_codec_id_mp1,
	av_codec_id_twinvq,
	av_codec_id_truehd,
	av_codec_id_mp4als,
	av_codec_id_atrac1,
	av_codec_id_binkaudio_rdft,
	av_codec_id_binkaudio_dct,
	av_codec_id_aac_latm,
	av_codec_id_qdmc,
	av_codec_id_celt,
	av_codec_id_g723_1,
	av_codec_id_g729,
	av_codec_id_8svx_exp,
	av_codec_id_8svx_fib,
	av_codec_id_bmv_audio,
	av_codec_id_ralf,
	av_codec_id_iac,
	av_codec_id_ilbc,
	av_codec_id_opus_deprecated,
	av_codec_id_comfort_noise,
	av_codec_id_tak_deprecated,
	av_codec_id_metasound,
	av_codec_id_paf_audio_deprecated,
	av_codec_id_on2avc,
	av_codec_id_ffwavesynth,
	av_codec_id_sonic,
	av_codec_id_sonic_ls,
	av_codec_id_paf_audio,
	av_codec_id_opus,
	av_codec_id_tak,
	av_codec_id_evrc,
	av_codec_id_smv,
	av_codec_id_dsd_lsbf,
	av_codec_id_dsd_msbf,
	av_codec_id_dsd_lsbf_planar,
	av_codec_id_dsd_msbf_planar,
	av_codec_id_first_subtitle,
	av_codec_id_dvd_subtitle,
	av_codec_id_dvb_subtitle,
	av_codec_id_text,
	av_codec_id_xsub,
	av_codec_id_ssa,
	av_codec_id_mov_text,
	av_codec_id_hdmv_pgs_subtitle,
	av_codec_id_dvb_teletext,
	av_codec_id_srt,
	av_codec_id_microdvd,
	av_codec_id_eia_608,
	av_codec_id_jacosub,
	av_codec_id_sami,
	av_codec_id_realtext,
	av_codec_id_stl,
	av_codec_id_subviewer1,
	av_codec_id_subviewer,
	av_codec_id_subrip,
	av_codec_id_webvtt,
	av_codec_id_mpl2,
	av_codec_id_vplayer,
	av_codec_id_pjs,
	av_codec_id_ass,
	av_codec_id_first_unknown,
	av_codec_id_ttf,
	av_codec_id_bintext,
	av_codec_id_xbin,
	av_codec_id_idf,
	av_codec_id_otf,
	av_codec_id_smpte_klv,
	av_codec_id_dvd_nav,
	av_codec_id_timed_id3,
	av_codec_id_bin_data,
	av_codec_id_probe,
	av_codec_id_mpeg2ts,
	av_codec_id_mpeg4systems,
	av_codec_id_ffmetadata
) where

#include "ffmpeg.h"

import Foreign.C.Types

import Media.FFMpeg.Internal.Common

-- | AVMediaType
newtype AVMediaType = AVMediaType {unAVMediaType :: CInt} deriving (Eq, Show)
instance CEnum AVMediaType where
	fromCEnum = unAVMediaType
	toCEnum = AVMediaType

#{enum AVMediaType, AVMediaType,
	avmedia_type_unknown = AVMEDIA_TYPE_UNKNOWN,
	avmedia_type_video = AVMEDIA_TYPE_VIDEO,
	avmedia_type_audio = AVMEDIA_TYPE_AUDIO,
	avmedia_type_data = AVMEDIA_TYPE_DATA,
	avmedia_type_subtitle = AVMEDIA_TYPE_SUBTITLE,
	avmedia_type_attachment = AVMEDIA_TYPE_ATTACHMENT,
	avmedia_type_nb = AVMEDIA_TYPE_NB
}

-- | AVSampleFormat
newtype AVSampleFormat = AVSampleFormat {unAVSampleFormat :: CInt} deriving (Eq, Show)
instance CEnum AVSampleFormat where
	fromCEnum = unAVSampleFormat
	toCEnum = AVSampleFormat

#{enum AVSampleFormat, AVSampleFormat,
	av_sample_fmt_none = AV_SAMPLE_FMT_NONE,
	av_sample_fmt_u8 = AV_SAMPLE_FMT_U8,
	av_sample_fmt_s16 = AV_SAMPLE_FMT_S16,
	av_sample_fmt_s32 = AV_SAMPLE_FMT_S32,
	av_sample_fmt_flt = AV_SAMPLE_FMT_FLT,
	av_sample_fmt_dbl = AV_SAMPLE_FMT_DBL,
	av_sample_fmt_u8p = AV_SAMPLE_FMT_U8P,
	av_sample_fmt_s16p = AV_SAMPLE_FMT_S16P,
	av_sample_fmt_s32p = AV_SAMPLE_FMT_S32P,
	av_sample_fmt_fltp = AV_SAMPLE_FMT_FLTP,
	av_sample_fmt_dblp = AV_SAMPLE_FMT_DBLP,
	av_sample_fmt_nb = AV_SAMPLE_FMT_NB
}

-- | AVCodecId
newtype AVCodecId = AVCodecId {unAVCodecId :: CInt} deriving (Eq, Show)
instance CEnum AVCodecId where
	fromCEnum = unAVCodecId
	toCEnum = AVCodecId

#{enum AVCodecId, AVCodecId,
	av_codec_id_none = AV_CODEC_ID_NONE,
	av_codec_id_mpeg1video = AV_CODEC_ID_MPEG1VIDEO,
	av_codec_id_mpeg2video = AV_CODEC_ID_MPEG2VIDEO,
	av_codec_id_h261 = AV_CODEC_ID_H261,
	av_codec_id_h263 = AV_CODEC_ID_H263,
	av_codec_id_rv10 = AV_CODEC_ID_RV10,
	av_codec_id_rv20 = AV_CODEC_ID_RV20,
	av_codec_id_mjpeg = AV_CODEC_ID_MJPEG,
	av_codec_id_mjpegb = AV_CODEC_ID_MJPEGB,
	av_codec_id_ljpeg = AV_CODEC_ID_LJPEG,
	av_codec_id_sp5x = AV_CODEC_ID_SP5X,
	av_codec_id_jpegls = AV_CODEC_ID_JPEGLS,
	av_codec_id_mpeg4 = AV_CODEC_ID_MPEG4,
	av_codec_id_rawvideo = AV_CODEC_ID_RAWVIDEO,
	av_codec_id_msmpeg4v1 = AV_CODEC_ID_MSMPEG4V1,
	av_codec_id_msmpeg4v2 = AV_CODEC_ID_MSMPEG4V2,
	av_codec_id_msmpeg4v3 = AV_CODEC_ID_MSMPEG4V3,
	av_codec_id_wmv1 = AV_CODEC_ID_WMV1,
	av_codec_id_wmv2 = AV_CODEC_ID_WMV2,
	av_codec_id_h263p = AV_CODEC_ID_H263P,
	av_codec_id_h263i = AV_CODEC_ID_H263I,
	av_codec_id_flv1 = AV_CODEC_ID_FLV1,
	av_codec_id_svq1 = AV_CODEC_ID_SVQ1,
	av_codec_id_svq3 = AV_CODEC_ID_SVQ3,
	av_codec_id_dvvideo = AV_CODEC_ID_DVVIDEO,
	av_codec_id_huffyuv = AV_CODEC_ID_HUFFYUV,
	av_codec_id_cyuv = AV_CODEC_ID_CYUV,
	av_codec_id_h264 = AV_CODEC_ID_H264,
	av_codec_id_indeo3 = AV_CODEC_ID_INDEO3,
	av_codec_id_vp3 = AV_CODEC_ID_VP3,
	av_codec_id_theora = AV_CODEC_ID_THEORA,
	av_codec_id_asv1 = AV_CODEC_ID_ASV1,
	av_codec_id_asv2 = AV_CODEC_ID_ASV2,
	av_codec_id_ffv1 = AV_CODEC_ID_FFV1,
	av_codec_id_4xm = AV_CODEC_ID_4XM,
	av_codec_id_vcr1 = AV_CODEC_ID_VCR1,
	av_codec_id_cljr = AV_CODEC_ID_CLJR,
	av_codec_id_mdec = AV_CODEC_ID_MDEC,
	av_codec_id_roq = AV_CODEC_ID_ROQ,
	av_codec_id_interplay_video = AV_CODEC_ID_INTERPLAY_VIDEO,
	av_codec_id_xan_wc3 = AV_CODEC_ID_XAN_WC3,
	av_codec_id_xan_wc4 = AV_CODEC_ID_XAN_WC4,
	av_codec_id_rpza = AV_CODEC_ID_RPZA,
	av_codec_id_cinepak = AV_CODEC_ID_CINEPAK,
	av_codec_id_ws_vqa = AV_CODEC_ID_WS_VQA,
	av_codec_id_msrle = AV_CODEC_ID_MSRLE,
	av_codec_id_msvideo1 = AV_CODEC_ID_MSVIDEO1,
	av_codec_id_idcin = AV_CODEC_ID_IDCIN,
	av_codec_id_8bps = AV_CODEC_ID_8BPS,
	av_codec_id_smc = AV_CODEC_ID_SMC,
	av_codec_id_flic = AV_CODEC_ID_FLIC,
	av_codec_id_truemotion1 = AV_CODEC_ID_TRUEMOTION1,
	av_codec_id_vmdvideo = AV_CODEC_ID_VMDVIDEO,
	av_codec_id_mszh = AV_CODEC_ID_MSZH,
	av_codec_id_zlib = AV_CODEC_ID_ZLIB,
	av_codec_id_qtrle = AV_CODEC_ID_QTRLE,
	av_codec_id_tscc = AV_CODEC_ID_TSCC,
	av_codec_id_ulti = AV_CODEC_ID_ULTI,
	av_codec_id_qdraw = AV_CODEC_ID_QDRAW,
	av_codec_id_vixl = AV_CODEC_ID_VIXL,
	av_codec_id_qpeg = AV_CODEC_ID_QPEG,
	av_codec_id_png = AV_CODEC_ID_PNG,
	av_codec_id_ppm = AV_CODEC_ID_PPM,
	av_codec_id_pbm = AV_CODEC_ID_PBM,
	av_codec_id_pgm = AV_CODEC_ID_PGM,
	av_codec_id_pgmyuv = AV_CODEC_ID_PGMYUV,
	av_codec_id_pam = AV_CODEC_ID_PAM,
	av_codec_id_ffvhuff = AV_CODEC_ID_FFVHUFF,
	av_codec_id_rv30 = AV_CODEC_ID_RV30,
	av_codec_id_rv40 = AV_CODEC_ID_RV40,
	av_codec_id_vc1 = AV_CODEC_ID_VC1,
	av_codec_id_wmv3 = AV_CODEC_ID_WMV3,
	av_codec_id_loco = AV_CODEC_ID_LOCO,
	av_codec_id_wnv1 = AV_CODEC_ID_WNV1,
	av_codec_id_aasc = AV_CODEC_ID_AASC,
	av_codec_id_indeo2 = AV_CODEC_ID_INDEO2,
	av_codec_id_fraps = AV_CODEC_ID_FRAPS,
	av_codec_id_truemotion2 = AV_CODEC_ID_TRUEMOTION2,
	av_codec_id_bmp = AV_CODEC_ID_BMP,
	av_codec_id_cscd = AV_CODEC_ID_CSCD,
	av_codec_id_mmvideo = AV_CODEC_ID_MMVIDEO,
	av_codec_id_zmbv = AV_CODEC_ID_ZMBV,
	av_codec_id_avs = AV_CODEC_ID_AVS,
	av_codec_id_smackvideo = AV_CODEC_ID_SMACKVIDEO,
	av_codec_id_nuv = AV_CODEC_ID_NUV,
	av_codec_id_kmvc = AV_CODEC_ID_KMVC,
	av_codec_id_flashsv = AV_CODEC_ID_FLASHSV,
	av_codec_id_cavs = AV_CODEC_ID_CAVS,
	av_codec_id_jpeg2000 = AV_CODEC_ID_JPEG2000,
	av_codec_id_vmnc = AV_CODEC_ID_VMNC,
	av_codec_id_vp5 = AV_CODEC_ID_VP5,
	av_codec_id_vp6 = AV_CODEC_ID_VP6,
	av_codec_id_vp6f = AV_CODEC_ID_VP6F,
	av_codec_id_targa = AV_CODEC_ID_TARGA,
	av_codec_id_dsicinvideo = AV_CODEC_ID_DSICINVIDEO,
	av_codec_id_tiertexseqvideo = AV_CODEC_ID_TIERTEXSEQVIDEO,
	av_codec_id_tiff = AV_CODEC_ID_TIFF,
	av_codec_id_gif = AV_CODEC_ID_GIF,
	av_codec_id_dxa = AV_CODEC_ID_DXA,
	av_codec_id_dnxhd = AV_CODEC_ID_DNXHD,
	av_codec_id_thp = AV_CODEC_ID_THP,
	av_codec_id_sgi = AV_CODEC_ID_SGI,
	av_codec_id_c93 = AV_CODEC_ID_C93,
	av_codec_id_bethsoftvid = AV_CODEC_ID_BETHSOFTVID,
	av_codec_id_ptx = AV_CODEC_ID_PTX,
	av_codec_id_txd = AV_CODEC_ID_TXD,
	av_codec_id_vp6a = AV_CODEC_ID_VP6A,
	av_codec_id_amv = AV_CODEC_ID_AMV,
	av_codec_id_vb = AV_CODEC_ID_VB,
	av_codec_id_pcx = AV_CODEC_ID_PCX,
	av_codec_id_sunrast = AV_CODEC_ID_SUNRAST,
	av_codec_id_indeo4 = AV_CODEC_ID_INDEO4,
	av_codec_id_indeo5 = AV_CODEC_ID_INDEO5,
	av_codec_id_mimic = AV_CODEC_ID_MIMIC,
	av_codec_id_rl2 = AV_CODEC_ID_RL2,
	av_codec_id_escape124 = AV_CODEC_ID_ESCAPE124,
	av_codec_id_dirac = AV_CODEC_ID_DIRAC,
	av_codec_id_bfi = AV_CODEC_ID_BFI,
	av_codec_id_cmv = AV_CODEC_ID_CMV,
	av_codec_id_motionpixels = AV_CODEC_ID_MOTIONPIXELS,
	av_codec_id_tgv = AV_CODEC_ID_TGV,
	av_codec_id_tgq = AV_CODEC_ID_TGQ,
	av_codec_id_tqi = AV_CODEC_ID_TQI,
	av_codec_id_aura = AV_CODEC_ID_AURA,
	av_codec_id_aura2 = AV_CODEC_ID_AURA2,
	av_codec_id_v210x = AV_CODEC_ID_V210X,
	av_codec_id_tmv = AV_CODEC_ID_TMV,
	av_codec_id_v210 = AV_CODEC_ID_V210,
	av_codec_id_dpx = AV_CODEC_ID_DPX,
	av_codec_id_mad = AV_CODEC_ID_MAD,
	av_codec_id_frwu = AV_CODEC_ID_FRWU,
	av_codec_id_flashsv2 = AV_CODEC_ID_FLASHSV2,
	av_codec_id_cdgraphics = AV_CODEC_ID_CDGRAPHICS,
	av_codec_id_r210 = AV_CODEC_ID_R210,
	av_codec_id_anm = AV_CODEC_ID_ANM,
	av_codec_id_binkvideo = AV_CODEC_ID_BINKVIDEO,
	av_codec_id_iff_ilbm = AV_CODEC_ID_IFF_ILBM,
	av_codec_id_iff_byterun1 = AV_CODEC_ID_IFF_BYTERUN1,
	av_codec_id_kgv1 = AV_CODEC_ID_KGV1,
	av_codec_id_yop = AV_CODEC_ID_YOP,
	av_codec_id_vp8 = AV_CODEC_ID_VP8,
	av_codec_id_pictor = AV_CODEC_ID_PICTOR,
	av_codec_id_ansi = AV_CODEC_ID_ANSI,
	av_codec_id_a64_multi = AV_CODEC_ID_A64_MULTI,
	av_codec_id_a64_multi5 = AV_CODEC_ID_A64_MULTI5,
	av_codec_id_r10k = AV_CODEC_ID_R10K,
	av_codec_id_mxpeg = AV_CODEC_ID_MXPEG,
	av_codec_id_lagarith = AV_CODEC_ID_LAGARITH,
	av_codec_id_prores = AV_CODEC_ID_PRORES,
	av_codec_id_jv = AV_CODEC_ID_JV,
	av_codec_id_dfa = AV_CODEC_ID_DFA,
	av_codec_id_wmv3image = AV_CODEC_ID_WMV3IMAGE,
	av_codec_id_vc1image = AV_CODEC_ID_VC1IMAGE,
	av_codec_id_utvideo = AV_CODEC_ID_UTVIDEO,
	av_codec_id_bmv_video = AV_CODEC_ID_BMV_VIDEO,
	av_codec_id_vble = AV_CODEC_ID_VBLE,
	av_codec_id_dxtory = AV_CODEC_ID_DXTORY,
	av_codec_id_v410 = AV_CODEC_ID_V410,
	av_codec_id_xwd = AV_CODEC_ID_XWD,
	av_codec_id_cdxl = AV_CODEC_ID_CDXL,
	av_codec_id_xbm = AV_CODEC_ID_XBM,
	av_codec_id_zerocodec = AV_CODEC_ID_ZEROCODEC,
	av_codec_id_mss1 = AV_CODEC_ID_MSS1,
	av_codec_id_msa1 = AV_CODEC_ID_MSA1,
	av_codec_id_tscc2 = AV_CODEC_ID_TSCC2,
	av_codec_id_mts2 = AV_CODEC_ID_MTS2,
	av_codec_id_cllc = AV_CODEC_ID_CLLC,
	av_codec_id_mss2 = AV_CODEC_ID_MSS2,
	av_codec_id_vp9 = AV_CODEC_ID_VP9,
	av_codec_id_aic = AV_CODEC_ID_AIC,
	av_codec_id_escape130_deprecated = AV_CODEC_ID_ESCAPE130_DEPRECATED,
	av_codec_id_g2m_deprecated = AV_CODEC_ID_G2M_DEPRECATED,
	av_codec_id_webp_deprecated = AV_CODEC_ID_WEBP_DEPRECATED,
	av_codec_id_hnm4_video = AV_CODEC_ID_HNM4_VIDEO,
	av_codec_id_hevc_deprecated = AV_CODEC_ID_HEVC_DEPRECATED,
	av_codec_id_fic = AV_CODEC_ID_FIC,
	av_codec_id_alias_pix = AV_CODEC_ID_ALIAS_PIX,
	av_codec_id_brender_pix_deprecated = AV_CODEC_ID_BRENDER_PIX_DEPRECATED,
	av_codec_id_paf_video_deprecated = AV_CODEC_ID_PAF_VIDEO_DEPRECATED,
	av_codec_id_exr_deprecated = AV_CODEC_ID_EXR_DEPRECATED,
	av_codec_id_vp7_deprecated = AV_CODEC_ID_VP7_DEPRECATED,
	av_codec_id_sanm_deprecated = AV_CODEC_ID_SANM_DEPRECATED,
	av_codec_id_sgirle_deprecated = AV_CODEC_ID_SGIRLE_DEPRECATED,
	av_codec_id_mvc1_deprecated = AV_CODEC_ID_MVC1_DEPRECATED,
	av_codec_id_mvc2_deprecated = AV_CODEC_ID_MVC2_DEPRECATED,
	av_codec_id_brender_pix = AV_CODEC_ID_BRENDER_PIX,
	av_codec_id_y41p = AV_CODEC_ID_Y41P,
	av_codec_id_escape130 = AV_CODEC_ID_ESCAPE130,
	av_codec_id_exr = AV_CODEC_ID_EXR,
	av_codec_id_avrp = AV_CODEC_ID_AVRP,
	av_codec_id_012v = AV_CODEC_ID_012V,
	av_codec_id_g2m = AV_CODEC_ID_G2M,
	av_codec_id_avui = AV_CODEC_ID_AVUI,
	av_codec_id_ayuv = AV_CODEC_ID_AYUV,
	av_codec_id_targa_y216 = AV_CODEC_ID_TARGA_Y216,
	av_codec_id_v308 = AV_CODEC_ID_V308,
	av_codec_id_v408 = AV_CODEC_ID_V408,
	av_codec_id_yuv4 = AV_CODEC_ID_YUV4,
	av_codec_id_sanm = AV_CODEC_ID_SANM,
	av_codec_id_paf_video = AV_CODEC_ID_PAF_VIDEO,
	av_codec_id_avrn = AV_CODEC_ID_AVRN,
	av_codec_id_cpia = AV_CODEC_ID_CPIA,
	av_codec_id_xface = AV_CODEC_ID_XFACE,
	av_codec_id_sgirle = AV_CODEC_ID_SGIRLE,
	av_codec_id_mvc1 = AV_CODEC_ID_MVC1,
	av_codec_id_mvc2 = AV_CODEC_ID_MVC2,
	av_codec_id_snow = AV_CODEC_ID_SNOW,
	av_codec_id_webp = AV_CODEC_ID_WEBP,
	av_codec_id_smvjpeg = AV_CODEC_ID_SMVJPEG,
	av_codec_id_hevc = AV_CODEC_ID_HEVC,
	av_codec_id_h265 = AV_CODEC_ID_H265,
	av_codec_id_vp7 = AV_CODEC_ID_VP7,
	av_codec_id_apng = AV_CODEC_ID_APNG,
	av_codec_id_first_audio = AV_CODEC_ID_FIRST_AUDIO,
	av_codec_id_pcm_s16le = AV_CODEC_ID_PCM_S16LE,
	av_codec_id_pcm_s16be = AV_CODEC_ID_PCM_S16BE,
	av_codec_id_pcm_u16le = AV_CODEC_ID_PCM_U16LE,
	av_codec_id_pcm_u16be = AV_CODEC_ID_PCM_U16BE,
	av_codec_id_pcm_s8 = AV_CODEC_ID_PCM_S8,
	av_codec_id_pcm_u8 = AV_CODEC_ID_PCM_U8,
	av_codec_id_pcm_mulaw = AV_CODEC_ID_PCM_MULAW,
	av_codec_id_pcm_alaw = AV_CODEC_ID_PCM_ALAW,
	av_codec_id_pcm_s32le = AV_CODEC_ID_PCM_S32LE,
	av_codec_id_pcm_s32be = AV_CODEC_ID_PCM_S32BE,
	av_codec_id_pcm_u32le = AV_CODEC_ID_PCM_U32LE,
	av_codec_id_pcm_u32be = AV_CODEC_ID_PCM_U32BE,
	av_codec_id_pcm_s24le = AV_CODEC_ID_PCM_S24LE,
	av_codec_id_pcm_s24be = AV_CODEC_ID_PCM_S24BE,
	av_codec_id_pcm_u24le = AV_CODEC_ID_PCM_U24LE,
	av_codec_id_pcm_u24be = AV_CODEC_ID_PCM_U24BE,
	av_codec_id_pcm_s24daud = AV_CODEC_ID_PCM_S24DAUD,
	av_codec_id_pcm_zork = AV_CODEC_ID_PCM_ZORK,
	av_codec_id_pcm_s16le_planar = AV_CODEC_ID_PCM_S16LE_PLANAR,
	av_codec_id_pcm_dvd = AV_CODEC_ID_PCM_DVD,
	av_codec_id_pcm_f32be = AV_CODEC_ID_PCM_F32BE,
	av_codec_id_pcm_f32le = AV_CODEC_ID_PCM_F32LE,
	av_codec_id_pcm_f64be = AV_CODEC_ID_PCM_F64BE,
	av_codec_id_pcm_f64le = AV_CODEC_ID_PCM_F64LE,
	av_codec_id_pcm_bluray = AV_CODEC_ID_PCM_BLURAY,
	av_codec_id_pcm_lxf = AV_CODEC_ID_PCM_LXF,
	av_codec_id_s302m = AV_CODEC_ID_S302M,
	av_codec_id_pcm_s8_planar = AV_CODEC_ID_PCM_S8_PLANAR,
	av_codec_id_pcm_s24le_planar_deprecated = AV_CODEC_ID_PCM_S24LE_PLANAR_DEPRECATED,
	av_codec_id_pcm_s32le_planar_deprecated = AV_CODEC_ID_PCM_S32LE_PLANAR_DEPRECATED,
	av_codec_id_pcm_s24le_planar = AV_CODEC_ID_PCM_S24LE_PLANAR,
	av_codec_id_pcm_s32le_planar = AV_CODEC_ID_PCM_S32LE_PLANAR,
	av_codec_id_pcm_s16be_planar = AV_CODEC_ID_PCM_S16BE_PLANAR,
	av_codec_id_adpcm_ima_qt = AV_CODEC_ID_ADPCM_IMA_QT,
	av_codec_id_adpcm_ima_wav = AV_CODEC_ID_ADPCM_IMA_WAV,
	av_codec_id_adpcm_ima_dk3 = AV_CODEC_ID_ADPCM_IMA_DK3,
	av_codec_id_adpcm_ima_dk4 = AV_CODEC_ID_ADPCM_IMA_DK4,
	av_codec_id_adpcm_ima_ws = AV_CODEC_ID_ADPCM_IMA_WS,
	av_codec_id_adpcm_ima_smjpeg = AV_CODEC_ID_ADPCM_IMA_SMJPEG,
	av_codec_id_adpcm_ms = AV_CODEC_ID_ADPCM_MS,
	av_codec_id_adpcm_4xm = AV_CODEC_ID_ADPCM_4XM,
	av_codec_id_adpcm_xa = AV_CODEC_ID_ADPCM_XA,
	av_codec_id_adpcm_adx = AV_CODEC_ID_ADPCM_ADX,
	av_codec_id_adpcm_ea = AV_CODEC_ID_ADPCM_EA,
	av_codec_id_adpcm_g726 = AV_CODEC_ID_ADPCM_G726,
	av_codec_id_adpcm_ct = AV_CODEC_ID_ADPCM_CT,
	av_codec_id_adpcm_swf = AV_CODEC_ID_ADPCM_SWF,
	av_codec_id_adpcm_yamaha = AV_CODEC_ID_ADPCM_YAMAHA,
	av_codec_id_adpcm_sbpro_4 = AV_CODEC_ID_ADPCM_SBPRO_4,
	av_codec_id_adpcm_sbpro_3 = AV_CODEC_ID_ADPCM_SBPRO_3,
	av_codec_id_adpcm_sbpro_2 = AV_CODEC_ID_ADPCM_SBPRO_2,
	av_codec_id_adpcm_thp = AV_CODEC_ID_ADPCM_THP,
	av_codec_id_adpcm_ima_amv = AV_CODEC_ID_ADPCM_IMA_AMV,
	av_codec_id_adpcm_ea_r1 = AV_CODEC_ID_ADPCM_EA_R1,
	av_codec_id_adpcm_ea_r3 = AV_CODEC_ID_ADPCM_EA_R3,
	av_codec_id_adpcm_ea_r2 = AV_CODEC_ID_ADPCM_EA_R2,
	av_codec_id_adpcm_ima_ea_sead = AV_CODEC_ID_ADPCM_IMA_EA_SEAD,
	av_codec_id_adpcm_ima_ea_eacs = AV_CODEC_ID_ADPCM_IMA_EA_EACS,
	av_codec_id_adpcm_ea_xas = AV_CODEC_ID_ADPCM_EA_XAS,
	av_codec_id_adpcm_ea_maxis_xa = AV_CODEC_ID_ADPCM_EA_MAXIS_XA,
	av_codec_id_adpcm_ima_iss = AV_CODEC_ID_ADPCM_IMA_ISS,
	av_codec_id_adpcm_g722 = AV_CODEC_ID_ADPCM_G722,
	av_codec_id_adpcm_ima_apc = AV_CODEC_ID_ADPCM_IMA_APC,
	av_codec_id_adpcm_vima_deprecated = AV_CODEC_ID_ADPCM_VIMA_DEPRECATED,
	av_codec_id_adpcm_vima = AV_CODEC_ID_ADPCM_VIMA,
	av_codec_id_adpcm_afc = AV_CODEC_ID_ADPCM_AFC,
	av_codec_id_adpcm_ima_oki = AV_CODEC_ID_ADPCM_IMA_OKI,
	av_codec_id_adpcm_dtk = AV_CODEC_ID_ADPCM_DTK,
	av_codec_id_adpcm_ima_rad = AV_CODEC_ID_ADPCM_IMA_RAD,
	av_codec_id_adpcm_g726le = AV_CODEC_ID_ADPCM_G726LE,
	av_codec_id_amr_nb = AV_CODEC_ID_AMR_NB,
	av_codec_id_amr_wb = AV_CODEC_ID_AMR_WB,
	av_codec_id_ra_144 = AV_CODEC_ID_RA_144,
	av_codec_id_ra_288 = AV_CODEC_ID_RA_288,
	av_codec_id_roq_dpcm = AV_CODEC_ID_ROQ_DPCM,
	av_codec_id_interplay_dpcm = AV_CODEC_ID_INTERPLAY_DPCM,
	av_codec_id_xan_dpcm = AV_CODEC_ID_XAN_DPCM,
	av_codec_id_sol_dpcm = AV_CODEC_ID_SOL_DPCM,
	av_codec_id_mp2 = AV_CODEC_ID_MP2,
	av_codec_id_mp3 = AV_CODEC_ID_MP3,
	av_codec_id_aac = AV_CODEC_ID_AAC,
	av_codec_id_ac3 = AV_CODEC_ID_AC3,
	av_codec_id_dts = AV_CODEC_ID_DTS,
	av_codec_id_vorbis = AV_CODEC_ID_VORBIS,
	av_codec_id_dvaudio = AV_CODEC_ID_DVAUDIO,
	av_codec_id_wmav1 = AV_CODEC_ID_WMAV1,
	av_codec_id_wmav2 = AV_CODEC_ID_WMAV2,
	av_codec_id_mace3 = AV_CODEC_ID_MACE3,
	av_codec_id_mace6 = AV_CODEC_ID_MACE6,
	av_codec_id_vmdaudio = AV_CODEC_ID_VMDAUDIO,
	av_codec_id_flac = AV_CODEC_ID_FLAC,
	av_codec_id_mp3adu = AV_CODEC_ID_MP3ADU,
	av_codec_id_mp3on4 = AV_CODEC_ID_MP3ON4,
	av_codec_id_shorten = AV_CODEC_ID_SHORTEN,
	av_codec_id_alac = AV_CODEC_ID_ALAC,
	av_codec_id_westwood_snd1 = AV_CODEC_ID_WESTWOOD_SND1,
	av_codec_id_gsm = AV_CODEC_ID_GSM,
	av_codec_id_qdm2 = AV_CODEC_ID_QDM2,
	av_codec_id_cook = AV_CODEC_ID_COOK,
	av_codec_id_truespeech = AV_CODEC_ID_TRUESPEECH,
	av_codec_id_tta = AV_CODEC_ID_TTA,
	av_codec_id_smackaudio = AV_CODEC_ID_SMACKAUDIO,
	av_codec_id_qcelp = AV_CODEC_ID_QCELP,
	av_codec_id_wavpack = AV_CODEC_ID_WAVPACK,
	av_codec_id_dsicinaudio = AV_CODEC_ID_DSICINAUDIO,
	av_codec_id_imc = AV_CODEC_ID_IMC,
	av_codec_id_musepack7 = AV_CODEC_ID_MUSEPACK7,
	av_codec_id_mlp = AV_CODEC_ID_MLP,
	av_codec_id_gsm_ms = AV_CODEC_ID_GSM_MS,
	av_codec_id_atrac3 = AV_CODEC_ID_ATRAC3,
	av_codec_id_ape = AV_CODEC_ID_APE,
	av_codec_id_nellymoser = AV_CODEC_ID_NELLYMOSER,
	av_codec_id_musepack8 = AV_CODEC_ID_MUSEPACK8,
	av_codec_id_speex = AV_CODEC_ID_SPEEX,
	av_codec_id_wmavoice = AV_CODEC_ID_WMAVOICE,
	av_codec_id_wmapro = AV_CODEC_ID_WMAPRO,
	av_codec_id_wmalossless = AV_CODEC_ID_WMALOSSLESS,
	av_codec_id_atrac3p = AV_CODEC_ID_ATRAC3P,
	av_codec_id_eac3 = AV_CODEC_ID_EAC3,
	av_codec_id_sipr = AV_CODEC_ID_SIPR,
	av_codec_id_mp1 = AV_CODEC_ID_MP1,
	av_codec_id_twinvq = AV_CODEC_ID_TWINVQ,
	av_codec_id_truehd = AV_CODEC_ID_TRUEHD,
	av_codec_id_mp4als = AV_CODEC_ID_MP4ALS,
	av_codec_id_atrac1 = AV_CODEC_ID_ATRAC1,
	av_codec_id_binkaudio_rdft = AV_CODEC_ID_BINKAUDIO_RDFT,
	av_codec_id_binkaudio_dct = AV_CODEC_ID_BINKAUDIO_DCT,
	av_codec_id_aac_latm = AV_CODEC_ID_AAC_LATM,
	av_codec_id_qdmc = AV_CODEC_ID_QDMC,
	av_codec_id_celt = AV_CODEC_ID_CELT,
	av_codec_id_g723_1 = AV_CODEC_ID_G723_1,
	av_codec_id_g729 = AV_CODEC_ID_G729,
	av_codec_id_8svx_exp = AV_CODEC_ID_8SVX_EXP,
	av_codec_id_8svx_fib = AV_CODEC_ID_8SVX_FIB,
	av_codec_id_bmv_audio = AV_CODEC_ID_BMV_AUDIO,
	av_codec_id_ralf = AV_CODEC_ID_RALF,
	av_codec_id_iac = AV_CODEC_ID_IAC,
	av_codec_id_ilbc = AV_CODEC_ID_ILBC,
	av_codec_id_opus_deprecated = AV_CODEC_ID_OPUS_DEPRECATED,
	av_codec_id_comfort_noise = AV_CODEC_ID_COMFORT_NOISE,
	av_codec_id_tak_deprecated = AV_CODEC_ID_TAK_DEPRECATED,
	av_codec_id_metasound = AV_CODEC_ID_METASOUND,
	av_codec_id_paf_audio_deprecated = AV_CODEC_ID_PAF_AUDIO_DEPRECATED,
	av_codec_id_on2avc = AV_CODEC_ID_ON2AVC,
	av_codec_id_ffwavesynth = AV_CODEC_ID_FFWAVESYNTH,
	av_codec_id_sonic = AV_CODEC_ID_SONIC,
	av_codec_id_sonic_ls = AV_CODEC_ID_SONIC_LS,
	av_codec_id_paf_audio = AV_CODEC_ID_PAF_AUDIO,
	av_codec_id_opus = AV_CODEC_ID_OPUS,
	av_codec_id_tak = AV_CODEC_ID_TAK,
	av_codec_id_evrc = AV_CODEC_ID_EVRC,
	av_codec_id_smv = AV_CODEC_ID_SMV,
	av_codec_id_dsd_lsbf = AV_CODEC_ID_DSD_LSBF,
	av_codec_id_dsd_msbf = AV_CODEC_ID_DSD_MSBF,
	av_codec_id_dsd_lsbf_planar = AV_CODEC_ID_DSD_LSBF_PLANAR,
	av_codec_id_dsd_msbf_planar = AV_CODEC_ID_DSD_MSBF_PLANAR,
	av_codec_id_first_subtitle = AV_CODEC_ID_FIRST_SUBTITLE,
	av_codec_id_dvd_subtitle = AV_CODEC_ID_DVD_SUBTITLE,
	av_codec_id_dvb_subtitle = AV_CODEC_ID_DVB_SUBTITLE,
	av_codec_id_text = AV_CODEC_ID_TEXT,
	av_codec_id_xsub = AV_CODEC_ID_XSUB,
	av_codec_id_ssa = AV_CODEC_ID_SSA,
	av_codec_id_mov_text = AV_CODEC_ID_MOV_TEXT,
	av_codec_id_hdmv_pgs_subtitle = AV_CODEC_ID_HDMV_PGS_SUBTITLE,
	av_codec_id_dvb_teletext = AV_CODEC_ID_DVB_TELETEXT,
	av_codec_id_srt = AV_CODEC_ID_SRT,
	av_codec_id_microdvd = AV_CODEC_ID_MICRODVD,
	av_codec_id_eia_608 = AV_CODEC_ID_EIA_608,
	av_codec_id_jacosub = AV_CODEC_ID_JACOSUB,
	av_codec_id_sami = AV_CODEC_ID_SAMI,
	av_codec_id_realtext = AV_CODEC_ID_REALTEXT,
	av_codec_id_stl = AV_CODEC_ID_STL,
	av_codec_id_subviewer1 = AV_CODEC_ID_SUBVIEWER1,
	av_codec_id_subviewer = AV_CODEC_ID_SUBVIEWER,
	av_codec_id_subrip = AV_CODEC_ID_SUBRIP,
	av_codec_id_webvtt = AV_CODEC_ID_WEBVTT,
	av_codec_id_mpl2 = AV_CODEC_ID_MPL2,
	av_codec_id_vplayer = AV_CODEC_ID_VPLAYER,
	av_codec_id_pjs = AV_CODEC_ID_PJS,
	av_codec_id_ass = AV_CODEC_ID_ASS,
	av_codec_id_first_unknown = AV_CODEC_ID_FIRST_UNKNOWN,
	av_codec_id_ttf = AV_CODEC_ID_TTF,
	av_codec_id_bintext = AV_CODEC_ID_BINTEXT,
	av_codec_id_xbin = AV_CODEC_ID_XBIN,
	av_codec_id_idf = AV_CODEC_ID_IDF,
	av_codec_id_otf = AV_CODEC_ID_OTF,
	av_codec_id_smpte_klv = AV_CODEC_ID_SMPTE_KLV,
	av_codec_id_dvd_nav = AV_CODEC_ID_DVD_NAV,
	av_codec_id_timed_id3 = AV_CODEC_ID_TIMED_ID3,
	av_codec_id_bin_data = AV_CODEC_ID_BIN_DATA,
	av_codec_id_probe = AV_CODEC_ID_PROBE,
	av_codec_id_mpeg2ts = AV_CODEC_ID_MPEG2TS,
	av_codec_id_mpeg4systems = AV_CODEC_ID_MPEG4SYSTEMS,
	av_codec_id_ffmetadata = AV_CODEC_ID_FFMETADATA
}

-- AV_CODEC_ID_HQX
-- AV_CODEC_ID_TDSC
-- AV_CODEC_ID_HQ_HQA
-- AV_CODEC_ID_HAP
-- AV_CODEC_ID_DDS
-- AV_CODEC_ID_PCM_S16BE_PLANAR_DEPRECATED
-- AV_CODEC_ID_ADPCM_THP_LE
-- AV_CODEC_ID_DSS_SP
-- AV_CODEC_ID_4GV


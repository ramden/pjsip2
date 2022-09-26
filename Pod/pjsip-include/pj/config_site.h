/*
 * PJLIB settings.
 */

/* Both armv6 and armv7 has FP hardware support.
 * See https://trac.pjsip.org/repos/ticket/1589 for more info
 */
#define PJ_HAS_FLOATING_POINT		1

/*
 * PJMEDIA settings
 */

/* We have our own native CoreAudio backend */
#define PJMEDIA_AUDIO_DEV_HAS_PORTAUDIO	0
#define PJMEDIA_AUDIO_DEV_HAS_WMME		0
#define PJMEDIA_AUDIO_DEV_HAS_COREAUDIO	1

/* The CoreAudio backend has built-in echo canceller! */
#define PJMEDIA_HAS_SPEEX_AEC    0

/* Disable some codecs */
#define PJMEDIA_HAS_L16_CODEC					0
#define PJMEDIA_HAS_GSM_CODEC					0
#define PJMEDIA_HAS_SPEEX_CODEC 				0
#define PJMEDIA_HAS_ILBC_CODEC  				0
#define PJMEDIA_HAS_INTEL_IPP_CODEC_AMR  		0
#define PJMEDIA_HAS_INTEL_IPP_CODEC_AMRWB  		0
#define PJMEDIA_HAS_INTEL_IPP_CODEC_G729  		0
#define PJMEDIA_HAS_INTEL_IPP_CODEC_G723_1   	0
#define PJMEDIA_HAS_INTEL_IPP_CODEC_G726   		0
#define PJMEDIA_HAS_INTEL_IPP_CODEC_G728  		0
#define PJMEDIA_HAS_INTEL_IPP_CODEC_G722_1  	0

#define PJMEDIA_HAS_G722_CODEC					1

#define PJMEDIA_HAS_PASSTHROUGH_CODEC_G729  	0
#define PJMEDIA_HAS_PASSTHROUGH_CODEC_ILBC    	0
#define PJMEDIA_HAS_PASSTHROUGH_CODEC_AMR    	0

#define PJMEDIA_HAS_PASSTHROUGH_CODEC_PCMA    	1
#define PJMEDIA_HAS_PASSTHROUGH_CODEC_PCMU    	1

/* Use the built-in CoreAudio's iLBC codec (yay!) */
#define PJMEDIA_HAS_ILBC_CODEC					0
#define PJMEDIA_ILBC_CODEC_USE_COREAUDIO		0

/* Fine tune Speex's default settings for best performance/quality */
#define PJMEDIA_CODEC_SPEEX_DEFAULT_QUALITY		5

/*
 * PJSIP settings.
 */

/* Increase allowable packet size, just in case */
//#define PJSIP_MAX_PKT_LEN			2000

/*
 * PJSUA settings.
 */

/* Default codec quality, previously was set to 5, however it is now
 * set to 4 to make sure pjsua instantiates resampler with small filter.
 */
#define PJSUA_DEFAULT_CODEC_QUALITY		4

/* Set maximum number of dialog/transaction/calls to minimum */
#define PJSIP_MAX_TSX_COUNT 		31
#define PJSIP_MAX_DIALOG_COUNT 		31
#define PJSUA_MAX_CALLS			32

/* Other pjsua settings */
#define PJSUA_MAX_ACC			4
#define PJSUA_MAX_PLAYERS			4
#define PJSUA_MAX_RECORDERS			4
#define PJSUA_MAX_CONF_PORTS		(PJSUA_MAX_CALLS+2*PJSUA_MAX_PLAYERS)
#define PJSUA_MAX_BUDDIES			32

#define PJ_IPHONE_OS_HAS_MULTITASKING_SUPPORT 0
#define PJ_HAS_SSL_SOCK   1
#define PJ_SSL_SOCK_IMP PJ_SSL_SOCK_IMP_DARWIN

#define PJMEDIA_HAS_SRTP 1

#define NDEBUG 1

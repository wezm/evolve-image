include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = EvolveImage

# TODO: Make the SSE flags CPU dependent
ADDITIONAL_OBJCFLAGS += -std=c99 -DDSFMT_MEXP=2203
ADDITIONAL_CFLAGS += -std=c99 -msse2 -DDSFMT_MEXP=2203 -DHAVE_SSE2

ifeq ($(GNUSTEP_TARGET_OS),darwin9.5.0)
    ADDITIONAL_INCLUDE_DIRS = -I/opt/local/include/cairo
    ADDITIONAL_LIB_DIRS += -L/opt/local/lib 
endif

ifeq ($(GNUSTEP_TARGET_OS),mingw32)
    ADDITIONAL_INCLUDE_DIRS = -I/c/gtk-libs/include/cairo
    ADDITIONAL_LIB_DIRS += -L/c/gtk-libs/lib
endif

ifeq ($(GNUSTEP_TARGET_OS),linux-gnu)
    ADDITIONAL_INCLUDE_DIRS = -I/usr/include/cairo
    ADDITIONAL_LIB_DIRS += -L/usr/lib
endif

EvolveImage_C_FILES = dSFMT.c

EvolveImage_OBJC_FILES = FTSWAbstractSingleton.m \
						 EIRand.m            \
						 EIMersenneTwister.m \
						 EICairoImage.m      \
						 EICairoPNGImage.m   \
						 EICairoDnaPainter.m \
						 EIPolygon.m         \
						 EIDna.m             \
						 EIImageEvolver.m    \
						 main.m 

ADDITIONAL_TOOL_LIBS += -lcairo

include $(GNUSTEP_MAKEFILES)/tool.make

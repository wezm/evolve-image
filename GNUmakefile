include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = EvolveImage
ADDITIONAL_OBJCFLAGS += -std=c99 -msse2 -DDSFMT_MEXP=2203 -DHAVE_SSE2
ADDITIONAL_CFLAGS += -std=c99 -msse2 -DDSFMT_MEXP=2203 -DHAVE_SSE2

EvolveImage_C_FILES = dSFMT.c

EvolveImage_OBJC_FILES = EIMersenneTwister.m \
			 EIPolygon.m \
			 EIDna.m \
			 EIImageEvolver.m \
			 main.m 

#EvolveImage_LDFLAGS = -L/Users/wmoore/Source/build/Debug -lobjccairo

include $(GNUSTEP_MAKEFILES)/tool.make

include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME = EvolveImage
ADDITIONAL_OBJCFLAGS += -std=c99

EvolveImage_OBJC_FILES = EIPolygon.m \
			 EIDna.m \
			 EIImageEvolver.m \
			 main.m 

EvolveImage_INCLUDE_DIRS = -I../mtwist
EvolveImage_LDFLAGS = -L../mtwist/static_obj -lmtwist_s

include $(GNUSTEP_MAKEFILES)/tool.make


# playground framework

CC=gcc
STD=-std=c99
WFLAGS=-Wall -Wextra
SUBLIB=utopia fract imgtool photon mass glee gleex glui ethnic nano nerv
_DLIB=glfw freetype z png jpeg enet
_BIN=libplayground

IDIR=-Iinclude/
IDIR += $(patsubst %,-I%/,$(SUBLIB))
DLIB=$(patsubst %,-l%,$(_DLIB))
SRC=$(patsubst %,%/src/*.c,$(SUBLIB))
SRC += imgtool/src/gif/*.c

OS=$(shell uname -s)
ifeq ($(OS),Darwin)
	OSFLAGS=-framework OpenGL -mmacos-version-min=10.9
	DFLAGS=-dynamiclib
	BIN=$(_BIN).dylib
else
	OSFLAGS=-lm -lGL -lGLEW
	DFLAGS=-shared -fPIC
	BIN=$(_BIN).so
endif

CFLAGS=$(STD) $(WFLAGS) $(IDIR)
LFLAGS=$(DLIB) $(OSFLAGS)

$(_BIN).a: $(SRC)
	$(CC) $(CFLAGS) -c $^ && ar -crv $@ *.o && rm *.o
    
shared: $(SRC)
	$(CC) -o $(BIN) $^ $(CFLAGS) $(LFLAGS) $(DFLAGS)

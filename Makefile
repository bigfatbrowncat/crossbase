UNAME := $(shell uname)

SRC = src
BIN = bin
OBJ = obj

DEBUG_OPTIMIZE = -O3 #-O0 -g

ifeq ($(UNAME), Darwin)	# OS X
  PLATFORM_ARCH = darwin x86_64
  PLATFORM_LIBS = osx
  PLATFORM_GENERAL_INCLUDES = -I/System/Library/Frameworks/JavaVM.framework/Headers
  PLATFORM_GENERAL_LINKER_OPTIONS = -framework Carbon
  PLATFORM_CONSOLE_OPTION = 
  EXE_EXT=
  STRIP_OPTIONS=-S -x
  RDYNAMIC=-rdynamic
else ifeq ($(UNAME), Linux)	# linux
  PLATFORM_ARCH = linux x86_64
  PLATFORM_LIBS = linux
  PLATFORM_GENERAL_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/linux"
  PLATFORM_GENERAL_LINKER_OPTIONS = -lpthread -ldl
  PLATFORM_CONSOLE_OPTION = 
  EXE_EXT=
  STRIP_OPTIONS=--strip-all
  RDYNAMIC=-rdynamic
else ifeq ($(OS), Windows_NT)	# Windows
  PLATFORM_ARCH = windows i386
  PLATFORM_LIBS = win32
  PLATFORM_GENERAL_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/win32"
  PLATFORM_GENERAL_LINKER_OPTIONS = -lmingw32 -lmingwthrd -lws2_32 -mwindows -static-libgcc -static-libstdc++
  PLATFORM_CONSOLE_OPTION = -mconsole
  EXE_EXT=.exe
  STRIP_OPTIONS=--strip-all
  RDYNAMIC=
endif

JAVA_CLASSES = $(BIN)/java/crossbase/Application.class
NATIVE_OBJECTS = $(OBJ)/main.o

all: $(BIN)/crossbase

$(BIN)/java/%.class: $(SRC)/java/%.java
	if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
	"$(JAVA_HOME)/bin/javac" -sourcepath "$(SRC)/java" -classpath "$(BIN)/java" -d $(BIN)/java $<

$(OBJ)/%.o: $(SRC)/cpp/%.cpp
	mkdir -p $(OBJ)
	g++ $(DEBUG_OPTIMIZE) -D_JNI_IMPLEMENTATION_ -c $(PLATFORM_GENERAL_INCLUDES) $< -o $@

$(BIN)/crossbase: $(JAVA_CLASSES) $(NATIVE_OBJECTS)
	mkdir -p $(BIN);

	# Extracting libavian objects
	( \
	    cd $(OBJ); \
	    mkdir -p libavian; \
	    cd libavian; \
	    ar x ../../lib/$(PLATFORM_LIBS)/libavian.a; \
	)

	# Making the java class library
	cp lib/java/classpath.jar $(BIN)/boot.jar; \
	( \
	    cd $(BIN); \
	    "$(JAVA_HOME)/bin/jar" u0f boot.jar -C java .; \
	)

	# Making an object file from the java class library
	tools/$(PLATFORM_LIBS)/binaryToObject $(BIN)/boot.jar $(OBJ)/boot.jar.o _binary_boot_jar_start _binary_boot_jar_end $(PLATFORM_ARCH); \
	g++ $(RDYNAMIC) $(DEBUG_OPTIMIZE) -Llib/$(PLATFORM_LIBS) $(OBJ)/boot.jar.o $(NATIVE_OBJECTS) $(OBJ)/libavian/*.o $(PLATFORM_GENERAL_LINKER_OPTIONS) $(PLATFORM_CONSOLE_OPTION) -lm -lz -o $@
	strip $(STRIP_OPTIONS) $@$(EXE_EXT)

clean:
	rm -rf $(OBJ)
	rm -rf $(BIN)

.PHONY: all
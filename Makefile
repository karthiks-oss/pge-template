PROJECT := demo
SRCDIR := src/main/cpp
HEADDIR := src/main/include
TARGET_DIR := target
OBJDIR := $(TARGET_DIR)/obj
BINDIR := $(TARGET_DIR)/bin
EXECUTABLE := $(BINDIR)/$(PROJECT)

ifeq ($(OS),Windows_NT)
	$(error Windows not supported)
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		CC := g++
		CFLAGS := -std=c++2a -O3 -Os
		ARCH_FLAGS	:=
		LINK_FLAG := -lX11 -lGL -lpthread -lpng -lstdc++fs
	endif
	ifeq ($(UNAME_S),Darwin)
		CC := clang++
		CFLAGS := -std=c++2a -O3 -Os -I/opt/homebrew/include
		ARCH_FLAGS :=
		LINK_FLAGS := -framework OpenGL -framework GLUT -framework Carbon -lpng -L/opt/homebrew/lib
	endif
endif

ifneq ($(origin NO_COLOR), undefined)
	COLOUR_RED :=
	COLOUR_BLUE :=
	COLOUR_END :=
else
	COLOUR_RED :=\033[0;31m
	COLOUR_BLUE :=\033[0;34m
	COLOUR_END :=\033[0m
endif

SOURCES := $(wildcard $(SRCDIR)/*.cpp)
INCLUDES := $(wildcard $(HEADDIR)/*.h)
OBJECTS := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

INC_FLAGS := $(addprefix -I,$(HEADDIR))
CPP_FLAGS ?= $(INC_FLAGS) -MMD -MP

all: CFLAGS += -Wall -O3
all: $(EXECUTABLE)

cleandebug: clean debug

debug: CFLAGS += -g -w
debug: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	@echo ""
	@echo "$(COLOUR_BLUE)LINKING...... [{"
	@echo "$(OBJECTS)" | tr ' ' '\n' | sed 's/^/\t\t/'
	@echo "\t} -> $(COLOUR_RED)$@$(COLOUR_BLUE)\n]$(COLOUR_END)"
	@$(CC) $(ARCH_FLAGS) $(LINK_FLAGS) -o $@ $(OBJECTS)

$(OBJDIR)/%.o : $(SRCDIR)/%.cpp | MAKEDIRS
	@echo "$(COLOUR_BLUE)COMPILING.... [$< -> $(COLOUR_RED)$@$(COLOUR_BLUE)]$(COLOUR_END)"
	@$(CC) $(ARCH_FLAGS) $(CPP_FLAGS) $(CFLAGS) -c "$<" -o "$@"

MAKEDIRS:
	@mkdir -p $(OBJDIR)
	@mkdir -p $(BINDIR)

clean:
	@echo "$(COLOUR_BLUE)CLEANING UP.. $(TARGET_DIR)$(COLOUR_END)"
	@rm -rf $(TARGET_DIR)

rebuild: clean all

run: $(EXECUTABLE)
	@$(EXECUTABLE)

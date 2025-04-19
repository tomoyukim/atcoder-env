# Compiler and flags
CXX := g++
CXXFLAGS := -std=c++20 -g -Wall -Wextra -Wshadow -Wconversion -Wfloat-equal \
            -Wno-char-subscripts -ftrapv -fsanitize=address,undefined \
            -fno-omit-frame-pointer -fno-sanitize-recover

# Target and source files
TARGET := main
SRCS := $(wildcard *.cpp)
OBJS := $(SRCS:.cpp=.o)

# Build target
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

# Compile source files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Test with online-judge-tools
.PHONY: test
test: $(TARGET)
	oj t -c "./$(TARGET)" -N -d test

# Clean rule
.PHONY: clean
clean:
	rm -f $(TARGET) $(OBJS)

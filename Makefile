TIMEOUT = $(shell command -v timeout 2> /dev/null)
OVO_TIMEOUT ?= 10s
ifdef TIMEOUT
	TIMEOUT = timeout -k 5s $(OVO_TIMEOUT)
endif

MATH_LIB_FLAGS=-qmkl -fsycl -lmkl_sycl

SRC = $(wildcard *.cpp)
.PHONY: exe
exe: $(SRC:%.cpp=%.exe)

pEXE = $(wildcard *.exe)
.PHONY: run
run: $(addprefix run_, $(basename $(pEXE)))

CXXFLAGS = -fiopenmp -fopenmp-targets=spir64 -D__STRICT_ANSI__ -DMKL_ILP64

%.exe: %.cpp
	-$(CXX) $(CXXFLAGS) $(MATH_LIB_FLAGS) $< -o $@


run_%: %.exe
	-$(TIMEOUT) ./$<

.PHONY: clean
clean:
	rm -f -- $(pEXE) 

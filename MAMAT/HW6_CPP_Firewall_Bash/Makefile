CXX=g++
CXXLINK=$(CXX)
CXXFLAGS=-c -Wall -std=c++11 -g
EXE=firewall.exe
RM=rm -rf *.o *.exe libfirewall.so *.h.gch

$(EXE): main.o libfirewall.so libinput.so
	$(CXXLINK) main.o libfirewall.so libinput.so -L. -o $(EXE)

libfirewall.so: string.o field.o ip.o port.o
	$(CXXLINK) -shared string.o field.o ip.o port.o -o libfirewall.so

main.o: main.cpp field.o ip.o port.o input.h
	$(CXX) $(CXXFLAGS) main.cpp

ip.o: ip.h ip.cpp field.o 
	$(CXX) $(CXXFLAGS) -fpic ip.cpp

port.o: port.h port.cpp field.o 
	$(CXX) $(CXXFLAGS) -fpic port.cpp

field.o: field.h field.cpp string.o 
	$(CXX) $(CXXFLAGS) -fpic field.cpp

string.o: string.h string.cpp
	$(CXX) $(CXXFLAGS) -fpic string.cpp

clean:
	$(RM)
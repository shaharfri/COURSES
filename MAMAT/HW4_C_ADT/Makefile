CC=gcc
CCLINK=$(CC)
CFLAGS=-g -Wall -std=c99 -c -fpic
OBJS=grades.o 
EXEC=libgrades.so
RM=rm -rf *.o $(EXEC)

#LINK
$(EXEC): $(OBJS) liblinked-list.so
	$(CCLINK) -shared $(OBJS) -o $(EXEC) -llinked-list -L.

#compile
grades.o: grades.c grades.h 
	$(CC) $(CFLAGS) grades.c

#clear
Make clean: 
	$(RM)

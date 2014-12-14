dnsseed: dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o
	$(CXX) -pthread -o dnsseed dns.o bitcoin.o netbase.o protocol.o db.o main.o util.o -l crypto

clean:
	rm -f *.o
	rm -f dnsseed

%.o: %.cpp bitcoin.h netbase.h protocol.h db.h serialize.h uint256.h util.h
	$(CXX) -DUSE_IPV6 -pthread -Wno-invalid-offsetof -c -o $@ $<

dns.o: dns.c
	$(CC) -pthread -std=c99 dns.c -c -o dns.o

%.o: %.cpp

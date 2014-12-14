LINK:=$(CXX)

LIBS = -lcrypto
OBJS = obj/bitcoin.o obj/db.o obj/dns.o obj/main.o obj/netbase.o obj/protocol.o obj/util.o

all: dnsseed

-include obj/*.P

obj/dns.o: dns.c
	$(CC) -c -pthread -std=c99 -MMD -MF $(@:%.o=%.d) -o $@ $<
	@cp $(@:%.o=%.d) $(@:%.o=%.P); \
	  sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
	      -e '/^$$/ d' -e 's/$$/ :/' < $(@:%.o=%.d) >> $(@:%.o=%.P); \
	  rm -f $(@:%.o=%.d)

obj/%.o: %.cpp
	$(CXX) -c -DUSE_IPV6 -pthread -Wno-invalid-offsetof -MMD -MF $(@:%.o=%.d) -o $@ $<
	@cp $(@:%.o=%.d) $(@:%.o=%.P); \
	  sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
	      -e '/^$$/ d' -e 's/$$/ :/' < $(@:%.o=%.d) >> $(@:%.o=%.P); \
	  rm -f $(@:%.o=%.d)

dnsseed: $(OBJS:obj/%=obj/%)
	$(LINK) -pthread -o $@ $^ $(LIBS)


clean:
	rm -f obj/*.o
	rm -f obj/*.P
	rm -f dnsseed


#CFLAGS=-Wall -static-libgcc
CFLAGS=-Wall
LIBS=-lssh -ljson-c -lpcap -lssl -lcrypto

RSA=/etc/ssh-honeypot/ssh-honeypot.rsa

ssh-honeypot:
	$(CC) $(CFLAGS) -o bin/ssh-honeypot src/ssh-honeypot.c $(LIBS)

clean:
	rm -f *~ src/*~ bin/ssh-honeypot src/*.o

install: ssh-honeypot install-etc $(RSA)

install-etc:
	mkdir -p /var/log/ssh-honeypot && chmod 777 /var/log/ssh-honeypot
	install -m 755 bin/ssh-honeypot /usr/local/bin/
	install -d /etc/ssh-honeypot
	install -m 644 ssh-honeypot.service /etc/ssh-honeypot/
	ln -sf /etc/ssh-honeypot/ssh-honeypot.service /etc/systemd/system/
	@echo
	@echo "You can enable ssh-honeypot at startup with: systemctl enable --now ssh-honeypot"

$(RSA):
	ssh-keygen -t rsa -f $(RSA) -N ''


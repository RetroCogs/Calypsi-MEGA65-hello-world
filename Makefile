VPATH = src

XEMU=/Applications/Xemu/xmega65.app/Contents/MacOS/xmega65
ETHERLOAD=~/Documents/MEGA65/etherload.osx
ETHERLOAD_ARGS=-r hello.prg


# Common source files
ASM_SRCS =
C_SRCS = main.c

# Object files
OBJS = $(ASM_SRCS:%.s=obj/%.o) $(C_SRCS:%.c=obj/%.o)
OBJS_DEBUG = $(ASM_SRCS:%.s=obj/%-debug.o) $(C_SRCS:%.c=obj/%-debug.o)

obj/%.o: %.s
	as6502 --target=mega65 --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%.o: %.c
	cc6502 --target=mega65 -O2 --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.s
	as6502 --target=mega65 --debug --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.c
	cc6502 --target=mega65 --debug --list-file=$(@:%.o=%.lst) -o $@ $<

hello.prg:  $(OBJS)
	ln6502 --target=mega65 mega65-plain.scm -o $@ $^  --output-format=prg --list-file=hello-mega65.lst

hello.elf: $(OBJS_DEBUG)
	ln6502 --target=mega65 mega65-plain.scm --debug -o $@ $^ --list-file=hello-debug.lst --semi-hosted

clean:
	-rm $(OBJS) $(OBJS:%.o=%.lst) $(OBJS_DEBUG) $(OBJS_DEBUG:%.o=%.lst)
	-rm hello.elf hello.prg hello-mega65.lst hello-debug.lst

run: hello.prg
	$(XEMU) -prg hello.prg -uartmon :4510 -videostd 1

qq: hello.prg
	$(ETHERLOAD) $(ETHERLOAD_ARGS)	


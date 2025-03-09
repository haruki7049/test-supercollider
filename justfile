cc := "sclang"

build:
    {{cc}} src/init.scd

install prefix:
	mkdir -p {{prefix}}
	install output.wav {{prefix}}

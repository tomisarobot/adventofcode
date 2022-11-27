test: official

%: %.question build
	bash program-test.sh $*.question

build:
	nim c program.nim

clean:
	rm program

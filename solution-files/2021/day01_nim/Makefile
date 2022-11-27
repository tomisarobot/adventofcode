test: official

example: build
	bash program-test.sh example.question example

%: %.question build
	bash program-test.sh $*.question

build:
	nim c program.nim

clean:
	rm program

test: official

example: build
	bash program-test.sh example.question example

%: %.question build
	bash program-test.sh $*.question

build:
	cargo build

clean:
	cargo clean

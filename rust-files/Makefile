test: official

%: %.question build
	bash program-test.sh $*.question $*.question.result

build:
	cargo build

clean:
	cargo clean

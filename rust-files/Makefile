test: official

%: %.question build
	bash program-test.sh $*.question $*.solution

build:
	cargo build

clean:
	cargo clean

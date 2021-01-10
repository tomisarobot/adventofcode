use std::fs;
use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    #[structopt(parse(from_os_str))]
    path: std::path::PathBuf,
    part: std::string::String
}

fn main() {
    let args = Cli::from_args();

    let contents = fs::read_to_string(args.path)
        .expect("Something went wrong reading the file");

    if args.part == "example" {
        for line in contents.lines() {
            println!("line: {}", line)
        }
    }

    if args.part == "part1" {
        // TODO
    }

    if args.part == "part2" {
        // TODO
    }
}

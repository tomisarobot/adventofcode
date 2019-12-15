use std::fs;
use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    #[structopt(parse(from_os_str))]
    path: std::path::PathBuf
}

fn main() {
    let args = Cli::from_args();

    let contents = fs::read_to_string(args.path)
        .expect("Something went wrong reading the file");

    for line in contents.lines() {
        println!("line: {}", line)
    }
}

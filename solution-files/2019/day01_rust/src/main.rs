use std::fs;
use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    #[structopt(parse(from_os_str))]
    path: std::path::PathBuf,
    part: std::string::String
}

fn apply_calc(masses: &Vec<i32>, calc: &dyn Fn(i32) -> i32) -> i32 {
    let mut total_fuel = 0;
    for mass in masses {
        let fuel = calc(*mass);
        total_fuel += fuel;
    }
    return total_fuel;
}

fn calc_pt1(mass: i32) -> i32 {
    return mass / 3 - 2;
}

fn calc_pt2(mass: i32) -> i32 {
    let fuel = std::cmp::max(0, mass / 3 - 2);
    if fuel == 0 {
        return 0;
    }
    return fuel + calc_pt2(fuel);
}

fn main() {
    let args = Cli::from_args();

    let contents = fs::read_to_string(args.path)
        .expect("Something went wrong reading the file");

    let masses = contents.lines()
        .map(|x| x.parse::<i32>().unwrap())
        .collect();

    if args.part == "part1" {
        println!("{}", apply_calc(&masses, &calc_pt1));
    }

    if args.part == "part2" {
        println!("{}", apply_calc(&masses, &calc_pt2));
    }
}

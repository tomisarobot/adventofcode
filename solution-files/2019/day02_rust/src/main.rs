use std::fs;
use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    #[structopt(parse(from_os_str))]
    path: std::path::PathBuf,
    part: std::string::String
}

fn update_codes(mut codes: Vec<i32>) -> Vec<i32> {
    // let last = codes.iter().position(|x| *x == 99).unwrap();
    let last = codes.capacity();
    let len = last / 4;
    for i in 0..len {
        let opcode = codes[(i * 4)];
        let input1 = codes[(i * 4) + 1] as usize;
        let input2 = codes[(i * 4) + 2] as usize;
        let output = codes[(i * 4) + 3] as usize;
        if opcode == 1 {
            codes[output] = codes[input1] + codes[input2];
        } else if opcode == 2 {
            codes[output] = codes[input1] * codes[input2];
        } else if opcode == 99 {
            break;
        }
    }
    return codes;
}

#[allow(dead_code)]
fn print_codes(codes: &Vec<i32>) {
    let mut once = false;
    for code in codes {
        let comma = if once { "," } else { "" };
        print!("{}{}", comma, code);
        once = true;
    }
    println!("");
}

fn restore_computer(input: &Vec<i32>, noun: i32, verb: i32) -> i32 {
    let mut codes:Vec<i32> = input.to_vec();
    codes[1] = noun;
    codes[2] = verb;
    codes = update_codes(codes);
    return codes[0];
}

fn main() {
    let args = Cli::from_args();

    let contents = fs::read_to_string(args.path)
        .expect("Something went wrong reading the file");

    let lines = contents.lines();

    for line in lines {
        let input:Vec<i32> = line.split(",")
            .map(|x| x.parse::<i32>().unwrap())
            .collect();

        if args.part == "example" {
            let mut codes_test = input.to_vec();
            codes_test = update_codes(codes_test);
            print_codes(&codes_test);
        }

        if args.part == "part1" {
            let addr0 = restore_computer(&input, 12, 2);
            println!("{}", addr0);
        }

        if args.part == "part2" {
            for noun in 0..99 {
                for verb in 0..99 {
                    let addr0 = restore_computer(&input, noun, verb);
                    if addr0 == 19690720 {
                        println!("{}", 100 * noun + verb);
                        return;
                    }
                }
            }
        }
    }

}

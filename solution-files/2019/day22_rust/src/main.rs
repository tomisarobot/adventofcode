use std::fs;
use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    #[structopt(parse(from_os_str))]
    path: std::path::PathBuf
}

const NEW_DECK: &str = "new ";
const CUT_DECK: &str = "cut ";
const DEAL_INCR: &str = "deal with increment ";
const DEAL_STACK: &str = "deal into new stack";
const PRINT_DECK: &str = "print";

fn match_technique(line: &str, technique: &str) -> bool {
    return line.starts_with(technique);
}

fn parse_technique(line: &str, technique: &str) -> i32 {
    return line[technique.bytes().count()..].parse::<i32>().unwrap();
}
/*
fn deal_into_new_stack<'a>(head: &'a mut Vec<i32>, tail: &'a mut Vec<i32>) -> (&'a mut Vec<i32>, &'a mut Vec<i32>) {
    head.reverse();
    return (head, tail);
}
fn deal_with_increment<'a>(head: &'a mut Vec<i32>, tail: &'a mut Vec<i32>, incr: i32) -> (&'a mut Vec<i32>, &'a mut Vec<i32>) {
    let offset = incr as usize;
    let len = head.len();
    for i in 0..len {
        tail[(i * offset) % len] = head[i];
        //println!("Result: {:?}", tail);
    }
    return (tail, head);
}
fn cut_deck<'a>(head: &'a mut Vec<i32>, tail: &'a mut Vec<i32>, cut: i32) -> (&'a mut Vec<i32>, &'a mut Vec<i32>) {
    let len = head.len();
    let len_i = len as i32;
    let offset = ((cut + len_i) % len_i) as usize;
    head.rotate_left(offset);
    return (head, tail);
}
// */
fn deal_into_new_stack(head: &mut Vec<i32>) {
    head.reverse();
}
fn deal_with_increment(head: &mut Vec<i32>, incr: i32)  {
    println!("incr {}", incr);
    let offset = incr as usize;
    let len = head.len();
    let dupe = head.to_vec();
    for i in 0..len {
        head[i] = -1;
    }
    for i in 0..len {
        head[(i * offset) % len] = dupe[i];
        //println!("Result: {:?}", tail);
    }
}
fn cut_deck(head: & mut Vec<i32>, cut: i32) {
    let len = head.len();
    let len_i = len as i32;
    let offset = ((cut + len_i) % len_i) as usize;
    println!("cut {}", offset);
    head.rotate_left(offset);
}


fn main() {
    let args = Cli::from_args();

    let contents = fs::read_to_string(args.path)
        .expect("Something went wrong reading the file");

    let mut length = 10007 as usize;

    {
        let first_line = contents.lines().next().unwrap();
        if match_technique(first_line, NEW_DECK) {
            length = parse_technique(first_line, NEW_DECK) as usize;
        }
    }

    let mut cards: Vec<i32> = Vec::with_capacity(length);

    let mut i = 0;
    cards.resize_with(length, || { i += 1; i - 1 });

    for line in contents.lines() {
        println!("line: {}", line);
        if match_technique(line, PRINT_DECK) {
            println!("Result: {:?}", cards);
        }
        else if match_technique(line, DEAL_STACK) {
            deal_into_new_stack(&mut cards);
        }
        else if match_technique(line, DEAL_INCR) {
            let param = parse_technique(line, DEAL_INCR);
            deal_with_increment(&mut cards, param);
        }
        else if match_technique(line, CUT_DECK) {
            let param = parse_technique(line, CUT_DECK);
            cut_deck(&mut cards, param);
        }
        else if match_technique(line, NEW_DECK) {
            // no-op
        }
        else {
            assert!(false);
        }
    println!("Result: {:?}", cards);
    }
    println!("Result: {:?}", cards);
}

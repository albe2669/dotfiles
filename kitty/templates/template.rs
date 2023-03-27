use std::io::{self, Read};

fn main() {
    let mut buffer = String::new();
    let stdin = io::stdin();
    let mut handle = stdin.lock();

    handle.read_to_string(&mut buffer).unwrap();

    let n: u32 = buffer.trim().parse().unwrap();

    if n > 1 {
        println!("still running");
    } else {
        println!("{}", n);
    }
}


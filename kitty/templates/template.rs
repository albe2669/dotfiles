use std::io;

fn get_input(io: &std::io::Stdin) -> String {
    let mut buffer = String::new();
    io.read_line(&mut buffer).expect("Failed");
    buffer
}

fn main() {
    let stdin = io::stdin();

    let n: u32 = get_input(&stdin).trim().parse().unwrap();

    if n > 1 {
        println!("still running");
    } else {
        println!("{}", n);
    }
}

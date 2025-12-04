use std::process::Command;

fn main() {
    // Sử dụng dumpbin từ Visual Studio nếu có trong PATH
    let output = Command::new("cmd")
        .args(&["/C", "where", "dumpbin"])
        .output();
    
    if let Ok(out) = output {
        if out.status.success() {
            let dumpbin_path = String::from_utf8_lossy(&out.stdout);
            println!("Found dumpbin at: {}", dumpbin_path);
            
            // Chạy dumpbin để list exports
            let dll_output = Command::new("dumpbin")
                .args(&["/EXPORTS", "target\\debug\\librustdesk.dll"])
                .output();
            
            if let Ok(dll_out) = dll_output {
                let exports = String::from_utf8_lossy(&dll_out.stdout);
                println!("\nExported symbols:");
                for line in exports.lines() {
                    if line.contains("rustdesk") || line.contains("core_main") || line.contains("free_c_args") {
                        println!("{}", line);
                    }
                }
            }
        } else {
            println!("dumpbin not found in PATH. Please run from Visual Studio Developer Command Prompt.");
        }
    }
}

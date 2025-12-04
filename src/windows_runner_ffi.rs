/// Windows FFI exports for the Flutter runner
/// This module provides entry points for the Windows desktop app
/// WITHOUT requiring the flutter feature to be enabled

use std::ffi::CString;
use std::os::raw::{c_char, c_int};

#[no_mangle]
pub extern "C" fn test_export() -> i32 {
    42
}

#[no_mangle]
pub extern "C" fn rustdesk_core_main_args(args_len: *mut c_int) -> *mut *mut c_char {
    unsafe { std::ptr::write(args_len, 0) };
    
    // Call core_main to get command line arguments
    if let Some(args) = crate::core_main::core_main() {
        return rust_args_to_c_args(args, args_len);
    }
    
    std::ptr::null_mut() as _
}

// Convert Rust Vec<String> to C char** array
// https://gist.github.com/iskakaushik/1c5b8aa75c77479c33c4320913eebef6
fn rust_args_to_c_args(args: Vec<String>, outlen: *mut c_int) -> *mut *mut c_char {
    let mut v = vec![];

    // Convert each String to CString
    for arg in args {
        match CString::new(arg) {
            Ok(s) => v.push(s.into_raw()),
            Err(_) => {} // Skip invalid strings
        }
    }

    unsafe {
        std::ptr::write(outlen, v.len() as c_int);
    }

    // Convert Vec to raw pointer  
    let boxed = v.into_boxed_slice();
    let ptr = Box::into_raw(boxed);
    ptr as _
}

#[no_mangle]
pub unsafe extern "C" fn free_c_args(ptr: *mut *mut c_char, len: c_int) {
    let len = len as usize;

    // Reconstruct the vector
    let v = Vec::from_raw_parts(ptr, len, len);

    // Drop each CString
    for elem in v {
        let s = CString::from_raw(elem);
        std::mem::drop(s);
    }
}

#[no_mangle]
pub unsafe extern "C" fn get_rustdesk_app_name(buffer: *mut u16, length: i32) -> i32 {
    let name = crate::platform::wide_string(&crate::get_app_name());
    if length > name.len() as i32 {
        std::ptr::copy_nonoverlapping(name.as_ptr(), buffer, name.len());
        return 0;
    }
    -1
}
